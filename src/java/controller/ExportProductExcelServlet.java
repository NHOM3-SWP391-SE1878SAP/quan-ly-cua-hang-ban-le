package controller;

import entity.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Vector;
import java.util.Date;
import jxl.Workbook;
import jxl.write.*;
import model.DAOProduct;

@WebServlet("/ExportProductExcelServlet")
public class ExportProductExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DAOProduct DAOProduct;

    @Override
    public void init() throws ServletException {
        DAOProduct = new DAOProduct();  // Khởi tạo đối tượng ProductDAO để lấy dữ liệu sản phẩm
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 📌 Lấy ngày hiện tại để tạo tên file
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = sdf.format(new Date()); // Lấy ngày hiện tại với định dạng yyyy-MM-dd

            // 📌 Thiết lập header để tải file Excel với tên file theo định dạng Product+ngày hiện tại.xls
            String fileName = "Product_" + currentDate + ".xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

            // 📌 Lấy danh sách sản phẩm từ database
            Vector<Product> products = DAOProduct.getAllProducts1();

            // 📌 Ghi dữ liệu vào file Excel
            OutputStream out = response.getOutputStream();
            WritableWorkbook workbook = Workbook.createWorkbook(out);
            WritableSheet sheet = workbook.createSheet("Products", 0);

            // 📌 Ghi tiêu đề cột
            sheet.addCell(new Label(0, 0, "Product Code"));
            sheet.addCell(new Label(1, 0, "Product Name"));
            sheet.addCell(new Label(2, 0, "Category"));
            sheet.addCell(new Label(3, 0, "Price"));
            sheet.addCell(new Label(4, 0, "Stock Quantity"));
            sheet.addCell(new Label(5, 0, "Status"));

            // 📌 Ghi dữ liệu sản phẩm
            int row = 1;
            for (Product product : products) {
                sheet.addCell(new Label(0, row, product.getProductCode()));
                sheet.addCell(new Label(1, row, product.getProductName()));
                sheet.addCell(new Label(2, row, product.getCategory() != null ? product.getCategory().getCategoryName() : "N/A"));
                sheet.addCell(new Label(3, row, String.valueOf(product.getPrice())));
                sheet.addCell(new Label(4, row, String.valueOf(product.getStockQuantity())));
                sheet.addCell(new Label(5, row, product.getStockQuantity() == 0 ? "Out of Stock" : "In Stock"));
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
