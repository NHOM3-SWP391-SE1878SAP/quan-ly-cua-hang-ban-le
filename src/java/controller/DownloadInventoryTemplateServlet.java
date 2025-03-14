package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import jxl.Workbook;
import jxl.format.Colour;
import jxl.write.*;

public class DownloadInventoryTemplateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Thiết lập header để tải file Excel
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=mau_nhap_hang.xls");

            // Tạo workbook và sheet
            OutputStream out = response.getOutputStream();
            WritableWorkbook workbook = Workbook.createWorkbook(out);
            WritableSheet sheet = workbook.createSheet("Mẫu Nhập Hàng", 0);

            // Định dạng cho tiêu đề
            WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);
            WritableCellFormat headerFormat = new WritableCellFormat(headerFont);
            headerFormat.setBackground(Colour.LIGHT_BLUE);
            headerFormat.setAlignment(jxl.format.Alignment.CENTRE);
            headerFormat.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
            headerFormat.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);

            // Định dạng cho ô dữ liệu
            WritableCellFormat dataFormat = new WritableCellFormat();
            dataFormat.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);

            // Định dạng cho ô ghi chú
            WritableFont noteFont = new WritableFont(WritableFont.ARIAL, 10, WritableFont.NO_BOLD);
            WritableCellFormat noteFormat = new WritableCellFormat(noteFont);
            noteFormat.setWrap(true);

            // Thêm tiêu đề cột
            sheet.addCell(new Label(0, 0, "Mã sản phẩm", headerFormat));
            sheet.addCell(new Label(1, 0, "Tên sản phẩm", headerFormat));
            sheet.addCell(new Label(2, 0, "Số lượng", headerFormat));
            sheet.addCell(new Label(3, 0, "Đơn giá", headerFormat));

            // Thiết lập độ rộng cột
            sheet.setColumnView(0, 15);
            sheet.setColumnView(1, 30);
            sheet.setColumnView(2, 15);
            sheet.setColumnView(3, 15);

            // Thêm một số dòng mẫu
            for (int i = 1; i <= 5; i++) {
                sheet.addCell(new Label(0, i, "", dataFormat));
                sheet.addCell(new Label(1, i, "", dataFormat));
                sheet.addCell(new Label(2, i, "", dataFormat));
                sheet.addCell(new Label(3, i, "", dataFormat));
            }

            // Thêm hướng dẫn
            sheet.addCell(new Label(0, 7, "Hướng dẫn:"));
            sheet.addCell(new Label(0, 8, "1. Nhập mã sản phẩm hoặc tên sản phẩm (ít nhất một trong hai trường)"));
            sheet.addCell(new Label(0, 9, "2. Nhập số lượng (bắt buộc)"));
            sheet.addCell(new Label(0, 10, "3. Nhập đơn giá (bắt buộc)"));
            sheet.addCell(new Label(0, 11, "4. Nếu sản phẩm chưa tồn tại trong hệ thống, hệ thống sẽ tự động tạo mới"));

            // Ghi và đóng workbook
            workbook.write();
            workbook.close();
            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("Lỗi khi tạo mẫu Excel: " + e.getMessage());
        }
    }
} 