package controller;

import entity.Product;
import entity.GoodReceiptDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Vector;
import jxl.Workbook;
import jxl.write.*;
import model.DAOProduct;

@WebServlet("/ExportSetPriceExcelServlet")
public class ExportSetPriceExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DAOProduct daoProduct;

    @Override
    public void init() throws ServletException {
        daoProduct = new DAOProduct();  // Khởi tạo đối tượng DAOProduct để lấy dữ liệu sản phẩm
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 📌 Lấy ngày hiện tại để tạo tên file
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = sdf.format(new java.util.Date()); // Lấy ngày hiện tại với định dạng yyyy-MM-dd

            // 📌 Thiết lập header để tải file Excel với tên file theo định dạng SetPrice_yyyy-MM-dd.xls
            String fileName = "SetPrice_" + currentDate + ".xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

            // 📌 Lấy danh sách sản phẩm từ database
            Vector<Product> products = daoProduct.getProductsWithUnitCost();  // Dùng phương thức đã tạo để lấy sản phẩm với giá vốn

            // 📌 Ghi dữ liệu vào file Excel
            OutputStream out = response.getOutputStream();
            WritableWorkbook workbook = Workbook.createWorkbook(out);
            WritableSheet sheet = workbook.createSheet("Products", 0);

            // 📌 Ghi tiêu đề cột
            sheet.addCell(new Label(0, 0, "Product Code"));
            sheet.addCell(new Label(1, 0, "Product Name"));
            sheet.addCell(new Label(2, 0, "Unit Cost"));
            sheet.addCell(new Label(3, 0, "Selling Price"));

            // 📌 Ghi dữ liệu sản phẩm
            int row = 1;
            for (Product product : products) {
                GoodReceiptDetail grd = product.getGoodReceiptDetail();  // Lấy giá vốn từ GoodReceiptDetail
                int unitCost = grd != null ? grd.getUnitCost() : 0;

                sheet.addCell(new Label(0, row, product.getProductCode()));
                sheet.addCell(new Label(1, row, product.getProductName()));
                sheet.addCell(new Label(2, row, String.valueOf(unitCost)));
                sheet.addCell(new Label(3, row, String.valueOf(product.getPrice())));
                row++;
            }

            workbook.write();
            workbook.close();
            out.flush();
            out.close();

        } catch (IOException | WriteException e) {
            e.printStackTrace();
            response.getWriter().write("❌ Lỗi khi xuất file Excel: " + e.getMessage());
        }
    }
}
