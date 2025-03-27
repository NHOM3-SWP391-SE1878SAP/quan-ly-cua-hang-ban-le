package controller;

import entity.Category;
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
import jxl.Workbook;
import jxl.write.*;
import model.DAOCategory;

@WebServlet("/ExportCategoryExcelServlet")
public class ExportCategoryExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DAOCategory DAOCategory;

    @Override
    public void init() throws ServletException {
        DAOCategory = new DAOCategory();  // Khởi tạo đối tượng CategoryDAO để lấy dữ liệu loại hàng
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 📌 Lấy ngày hiện tại để tạo tên file
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String currentDate = sdf.format(new java.util.Date()); // Lấy ngày hiện tại với định dạng yyyy-MM-dd

            // 📌 Thiết lập header để tải file Excel với tên file theo định dạng Category+ngày hiện tại.xls
            String fileName = "Category_" + currentDate + ".xls";
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

            // 📌 Lấy danh sách các loại hàng từ database
            Vector<Category> categories = DAOCategory.getAllCategories();

            // 📌 Ghi dữ liệu vào file Excel
            OutputStream out = response.getOutputStream();
            WritableWorkbook workbook = Workbook.createWorkbook(out);
            WritableSheet sheet = workbook.createSheet("Categories", 0);

            // 📌 Ghi tiêu đề cột
            sheet.addCell(new Label(0, 0, "Category ID"));
            sheet.addCell(new Label(1, 0, "Category Name"));
            sheet.addCell(new Label(2, 0, "Description"));

            // 📌 Ghi dữ liệu loại hàng
            int row = 1;
            for (Category category : categories) {
                sheet.addCell(new Label(0, row, String.valueOf(category.getCategoryID())));
                sheet.addCell(new Label(1, row, category.getCategoryName()));
                sheet.addCell(new Label(2, row, category.getDescription()));
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
