package controller;

import entity.EmployeePayroll;
import model.DAOEmployeePayroll;
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
import jxl.write.Number;

@WebServlet(name = "ExportPayrollExcelServlet", urlPatterns = {"/ExportPayrollExcelServlet"})
public class ExportPayrollExcelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DAOEmployeePayroll payrollDAO;

    @Override
    public void init() throws ServletException {
        payrollDAO = new DAOEmployeePayroll();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tham số tháng/năm từ request
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));

            // Lấy dữ liệu từ DAO
            Vector<EmployeePayroll> payrollList = payrollDAO.getPayrollWithAttendance(month, year);

            // Thiết lập header response
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=bang_luong_" + month + "_" + year + ".xls");

            try (OutputStream out = response.getOutputStream()) {
                WritableWorkbook workbook = Workbook.createWorkbook(out);
                WritableSheet sheet = workbook.createSheet("Bảng Lương", 0);

                // Định dạng header
                WritableFont headerFont = new WritableFont(WritableFont.ARIAL, 12, WritableFont.BOLD);
                WritableCellFormat headerFormat = new WritableCellFormat(headerFont);

                // Định dạng số tiền
                NumberFormat currencyFormat = new NumberFormat("#,##0");
                WritableCellFormat moneyFormat = new WritableCellFormat(currencyFormat);

                // Định dạng ngày tháng
                DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
                WritableCellFormat dateFormatCell = new WritableCellFormat(dateFormat);

                // Tạo tiêu đề cột (THÊM CỘT OffDays)
                String[] headers = {
                    "Mã NV", 
                    "Tên Nhân Viên", 
                    "Số Ngày Công",
                    "Số Ngày Nghỉ",  // Thêm cột mới
                    "Lương Cơ Bản", 
                    "Tổng Lương", 
                    "Ngày Thanh Toán"
                };

                // Thiết lập độ rộng cột (CẬP NHẬT THEO CỘT MỚI)
                int[] columnWidths = {10, 25, 15, 15, 15, 15, 20};
                for (int i = 0; i < columnWidths.length; i++) {
                    sheet.setColumnView(i, columnWidths[i]);
                }

                // Ghi tiêu đề
                for (int i = 0; i < headers.length; i++) {
                    sheet.addCell(new Label(i, 0, headers[i], headerFormat));
                }

                // Ghi dữ liệu
                int rowNum = 1;
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

                for (EmployeePayroll payroll : payrollList) {
                    // Tính toán tổng lương (THÊM OffDays)
                    double totalSalary = Math.max(
                        payroll.getEmployee().getSalary() * payroll.getWorkDays() 
                        - (payroll.getEmployee().getSalary() * 0.1 * payroll.getOffDays()), 
                        0
                    );

                    // Dữ liệu từng cột
                    sheet.addCell(new Label(0, rowNum, "NV" + payroll.getEmployee().getEmployeeID())); // Cột 0: Mã NV
                    sheet.addCell(new Label(1, rowNum, payroll.getEmployee().getEmployeeName()));      // Cột 1: Tên NV
                    sheet.addCell(new Number(2, rowNum, payroll.getWorkDays()));                       // Cột 2: Ngày công
                    sheet.addCell(new Number(3, rowNum, payroll.getOffDays()));                        // Cột 3: Ngày nghỉ (MỚI)
                    sheet.addCell(new Number(4, rowNum, payroll.getEmployee().getSalary(), moneyFormat)); // Cột 4: Lương cơ bản
                    sheet.addCell(new Number(5, rowNum, totalSalary, moneyFormat));                    // Cột 5: Tổng lương (ĐÃ CẬP NHẬT)
                    
                    // Cột 6: Ngày thanh toán
                    if (payroll.getPayDate() != null) {
                        sheet.addCell(new DateTime(6, rowNum, payroll.getPayDate(), dateFormatCell));
                    } else {
                        sheet.addCell(new Label(6, rowNum, "Chưa thanh toán"));
                    }

                    rowNum++;
                }

                workbook.write();
                workbook.close();
                out.flush();
            }
        } catch (NumberFormatException | WriteException e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("Lỗi khi xuất file Excel: " + e.getMessage());
        }
    }
}