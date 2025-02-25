package controller;

import dao.CustomerDAO;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;


public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String searchQuery = request.getParameter("search");
        String editId = request.getParameter("editId");

        List<Customer> customers;

        // 🔍 Nếu có tìm kiếm, lấy dữ liệu tìm kiếm mà không lưu vào session
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customers = customerDAO.searchCustomers(searchQuery);
            request.setAttribute("customers", customers);
        } else {
            // 🛠 Nếu không tìm kiếm, lấy danh sách từ session hoặc database
            customers = (List<Customer>) session.getAttribute("customers");
            if (customers == null || request.getParameter("refresh") != null) {
                customers = customerDAO.getAllCustomers();
                session.setAttribute("customers", customers);
            }
            request.setAttribute("customers", customers);
        }

        // 📌 Nếu đang vào Edit, lấy dữ liệu khách hàng cần chỉnh sửa
        

        request.getRequestDispatcher("customers.jsp").forward(request, response);
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");
    HttpSession session = request.getSession();
    String message = "";

    try {
        List<Customer> customers = (List<Customer>) session.getAttribute("customers");
        if (customers == null) {
            customers = customerDAO.getAllCustomers(); // Lấy từ database nếu session rỗng
        }

        if ("add".equals(action)) {
            String name = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            Integer points = parseInteger(request.getParameter("points"));

            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Customer name is required!");
            }

            Customer customer = new Customer(0, name, phone, address, points);
            customerDAO.addCustomer(customer);
            customers = customerDAO.getAllCustomers(); // Cập nhật danh sách mới nhất
            message = "✅ Customer added successfully!";

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            Integer points = parseInteger(request.getParameter("points"));

            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Customer name is required!");
            }

            Customer customer = new Customer(id, name, phone, address, points);
            customerDAO.updateCustomer(customer);
            customers = customerDAO.getAllCustomers(); // Cập nhật danh sách mới nhất
            message = "✅ Customer updated successfully!";

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            customerDAO.deleteCustomer(id);
            customers = customerDAO.getAllCustomers(); // Cập nhật danh sách mới nhất
            message = "❌ Customer deleted successfully!";
        }

        // 🔄 Cập nhật session với danh sách mới
        session.setAttribute("customers", customers);
        session.setAttribute("message", message);

    } catch (Exception e) {
        session.setAttribute("message", "⚠️ Error: " + e.getMessage());
    }

    response.sendRedirect("CustomerServlet");  // Reload lại danh sách sau CRUD
}


    private Integer parseInteger(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
