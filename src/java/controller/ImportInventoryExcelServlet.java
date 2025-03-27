package controller;

import entity.GoodReceipt;
import entity.GoodReceiptDetail;
import entity.Product;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import jxl.Sheet;
import jxl.Workbook;
import jxl.Cell;
import jxl.read.biff.BiffException;
import dao.DAOSupplier;
import dao.GoodReceiptDAO;
import dao.GoodReceiptDetailDAO;
import dao.ProductDAO;

@WebServlet("/ImportInventoryExcelServlet")
@MultipartConfig
public class ImportInventoryExcelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy thông tin nhà cung cấp
            int supplierId = Integer.parseInt(request.getParameter("supplierID"));
            DAOSupplier supplierDAO = new DAOSupplier();
            Supplier supplier = supplierDAO.getSupplierById(supplierId);

            if (supplier == null) {
                request.setAttribute("errorMessage", "Không tìm thấy nhà cung cấp");
                request.getRequestDispatcher("inventory").forward(request, response);
                return;
            }

            // Lấy file Excel từ request
            Part filePart = request.getPart("excelFile");
            InputStream fileContent = filePart.getInputStream();

            // Đọc file Excel
            Workbook workbook = Workbook.getWorkbook(fileContent);
            Sheet sheet = workbook.getSheet(0);

            // Kiểm tra định dạng file
            if (sheet.getColumns() < 4 || sheet.getRows() < 2) {
                request.setAttribute("errorMessage", "File Excel không đúng định dạng");
                request.getRequestDispatcher("inventory").forward(request, response);
                return;
            }

            // Tạo phiếu nhập hàng mới
            GoodReceipt goodReceipt = new GoodReceipt();
            goodReceipt.setReceivedDate(new Date());
            goodReceipt.setSupplier(supplier);
            goodReceipt.setTotalCost(0); // Sẽ được cập nhật sau

            GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
            int receiptId = goodReceiptDAO.addGoodReceipt(goodReceipt);

            if (receiptId == -1) {
                request.setAttribute("errorMessage", "Không thể tạo phiếu nhập hàng");
                request.getRequestDispatcher("inventory").forward(request, response);
                return;
            }

            goodReceipt.setGoodReceiptID(receiptId);

            // Đọc dữ liệu từ file Excel và tạo chi tiết phiếu nhập hàng
            ProductDAO productDAO = new ProductDAO();
            GoodReceiptDetailDAO detailDAO = new GoodReceiptDetailDAO();
            List<String> errors = new ArrayList<>();
            int totalCost = 0;

            // Bắt đầu từ dòng 1 (bỏ qua tiêu đề)
            for (int i = 1; i < sheet.getRows(); i++) {
                Cell[] row = sheet.getRow(i);

                // Kiểm tra nếu dòng trống
                if (row.length < 4 || (row[0].getContents().trim().isEmpty() && row[1].getContents().trim().isEmpty())) {
                    continue;
                }

                String productCode = row[0].getContents().trim();
                String productName = row[1].getContents().trim();

                // Kiểm tra số lượng và đơn giá
                if (row[2].getContents().trim().isEmpty() || row[3].getContents().trim().isEmpty()) {
                    errors.add("Dòng " + (i + 1) + ": Thiếu số lượng hoặc đơn giá");
                    continue;
                }

                int quantity;
                int unitCost;

                try {
                    quantity = Integer.parseInt(row[2].getContents().trim().replaceAll(",", ""));
                    unitCost = Integer.parseInt(row[3].getContents().trim().replaceAll(",", ""));
                } catch (NumberFormatException e) {
                    errors.add("Dòng " + (i + 1) + ": Số lượng hoặc đơn giá không hợp lệ");
                    continue;
                }

                if (quantity <= 0 || unitCost <= 0) {
                    errors.add("Dòng " + (i + 1) + ": Số lượng và đơn giá phải lớn hơn 0");
                    continue;
                }

                // Tìm hoặc tạo sản phẩm
                Product product = null;

                if (!productCode.isEmpty()) {
                    product = productDAO.getProductByCode(productCode);
                }

                if (product == null && !productName.isEmpty()) {
                    // Tìm sản phẩm theo tên
                    List<Product> products = productDAO.searchProductsByName(productName);
                    if (!products.isEmpty()) {
                        product = products.get(0);
                    }
                }

                // Nếu sản phẩm không tồn tại, tạo mới
                if (product == null) {
                    if (productName.isEmpty()) {
                        errors.add("Dòng " + (i + 1) + ": Không thể tạo sản phẩm mới vì thiếu tên sản phẩm");
                        continue;
                    }

                    product = new Product();
                    product.setProductName(productName);
                    product.setProductCode(productCode.isEmpty() ? "SP" + System.currentTimeMillis() : productCode);
                    product.setUnitPrice(unitCost); // Giá bán mặc định = giá nhập
                    product.setStockQuantity(0); // Sẽ được cập nhật sau
                    product.setAvailable(true);
                    product.setCategoryID(1); // Danh mục mặc định

                    boolean added = productDAO.addProduct(product);
                    if (!added) {
                        errors.add("Dòng " + (i + 1) + ": Không thể tạo sản phẩm mới");
                        continue;
                    }

                    // Lấy lại sản phẩm để có ID
                    product = productDAO.getProductByCode(product.getProductCode());
                    if (product == null) {
                        errors.add("Dòng " + (i + 1) + ": Không thể tìm thấy sản phẩm sau khi tạo");
                        continue;
                    }
                }

                // Tạo chi tiết phiếu nhập hàng
                GoodReceiptDetail detail = new GoodReceiptDetail();
                detail.setGoodReceipt(goodReceipt);
                detail.setProduct(product);
                detail.setQuantityReceived(quantity);
                detail.setUnitCost(unitCost);
                detail.setBatchNumber("B" + System.currentTimeMillis());
                detail.setExpirationDate(new Date(System.currentTimeMillis() + 365L * 24 * 60 * 60 * 1000)); // 1 năm sau

                int detailId = detailDAO.addGoodReceiptDetail(detail);
                if (detailId == -1) {
                    errors.add("Dòng " + (i + 1) + ": Không thể thêm chi tiết phiếu nhập hàng");
                    continue;
                }

                // Cập nhật tổng tiền
                totalCost += quantity * unitCost;
            }

            // Cập nhật tổng tiền cho phiếu nhập hàng
            goodReceipt.setTotalCost(totalCost);
            goodReceiptDAO.updateGoodReceipt(goodReceipt);

            // Đóng workbook
            workbook.close();

            // Chuyển hướng về trang danh sách phiếu nhập hàng
            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errorMessages", errors);
                response.sendRedirect("inventory");
            return;
            }

            request.getSession().setAttribute("successMessage", "Đã nhập hàng thành công từ file Excel. ID phiếu nhập: " + receiptId);
              response.sendRedirect("inventory");

        } catch (ServletException | IOException | IndexOutOfBoundsException | NumberFormatException | BiffException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi nhập hàng từ file Excel: " + e.getMessage());
            response.sendRedirect("inventory");
        }
    }
}
