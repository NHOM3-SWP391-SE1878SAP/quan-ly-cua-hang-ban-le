package controller;

import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import jxl.Workbook;
import jxl.write.*;
import dao.CustomerDAO;

@WebServlet("/ExportCustomerExcelServlet")
public class ExportCustomerExcelServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 📌 Thiết lập header để tải file Excel
            response.setContentType("application/vnd.ms-excel");
            response.setHeader("Content-Disposition", "attachment; filename=customers.xls");

            // 📌 Lấy danh sách khách hàng từ database
            List<Customer> customers = customerDAO.getAllCustomers();

            // 📌 Ghi dữ liệu vào file Excel
            OutputStream out = response.getOutputStream();
            WritableWorkbook workbook = Workbook.createWorkbook(out);
            WritableSheet sheet = workbook.createSheet("Customers", 0);

            // 📌 Ghi tiêu đề cột
            sheet.addCell(new Label(0, 0, "ID"));
            sheet.addCell(new Label(1, 0, "Customer Name"));
            sheet.addCell(new Label(2, 0, "Phone"));
            sheet.addCell(new Label(3, 0, "Address"));
            sheet.addCell(new Label(4, 0, "Points"));

            // 📌 Ghi dữ liệu khách hàng
            int row = 1;
            for (Customer customer : customers) {
                sheet.addCell(new Label(0, row, String.valueOf(customer.getId())));
                sheet.addCell(new Label(1, row, customer.getCustomerName()));
                sheet.addCell(new Label(2, row, customer.getPhone()));
                sheet.addCell(new Label(3, row, customer.getAddress()));
                sheet.addCell(new Label(4, row, customer.getPoints() != null ? String.valueOf(customer.getPoints()) : "0"));
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
