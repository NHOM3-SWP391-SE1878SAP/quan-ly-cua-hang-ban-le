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
        try {
            String searchQuery = request.getParameter("search");
            List<Customer> customers;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                customers = customerDAO.searchCustomers(searchQuery);
            } else {
                // 🛠 Kiểm tra session trước khi lấy từ database
                customers = (List<Customer>) session.getAttribute("customers");
                if (customers == null || request.getParameter("refresh") != null) {
                    customers = customerDAO.getAllCustomers();
                    session.setAttribute("customers", customers);  // Cập nhật lại session
                }
            }

            request.setAttribute("customers", customers);
            request.getRequestDispatcher("customers.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "⚠️ Error fetching customers: " + e.getMessage());
            request.getRequestDispatcher("customers.jsp").forward(request, response);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String message = "";

        try {
            // Danh sách khách hàng để cập nhật session

            if ("add".equals(action)) {
                String name = request.getParameter("customerName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                Integer points = request.getParameter("points") == null || request.getParameter("points").isEmpty()
                        ? 0 : Integer.parseInt(request.getParameter("points"));

                // ✅ Sử dụng constructor không có id
                Customer customer = new Customer(name, phone, address, points);

                CustomerDAO customerDAO = new CustomerDAO();
                boolean success = customerDAO.addCustomer(customer);

                if (success) {
                    session.setAttribute("message", "✅ Customer added successfully!");
                } else {
                    session.setAttribute("message", "❌ Failed to add customer!");
                }
                List<Customer> customers = customerDAO.getAllCustomers();
                session.setAttribute("customers", customers);

                response.sendRedirect("CustomerServlet");
            } else if ("update".equals(action)) {
    String idParam = request.getParameter("id");
    System.out.println("🚀 Received update request - ID: " + idParam);

    if (idParam == null || idParam.trim().isEmpty()) {
        session.setAttribute("message", "⚠️ Customer ID is required for update!");
        response.sendRedirect("CustomerServlet");
        return;
    }

    int id = Integer.parseInt(idParam);
    String name = request.getParameter("customerName");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    Integer points = parseInteger(request.getParameter("points"));

    System.out.println("📌 Received Data - ID: " + id + ", Name: " + name + ", Phone: " + phone + ", Address: " + address + ", Points: " + points);

    if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
        session.setAttribute("message", "⚠️ Name and Phone are required!");
        response.sendRedirect("CustomerServlet");
        return;
    }

    Customer updatedCustomer = new Customer(id, name, phone, address, points);
    System.out.println("📌 Sending to DAO - ID: " + updatedCustomer.getId());

    customerDAO.updateCustomer(updatedCustomer);

    // 🔄 Cập nhật lại danh sách khách hàng sau khi update
    List<Customer> customers = customerDAO.getAllCustomers();
    session.setAttribute("customers", customers);

    session.setAttribute("message", "✅ Customer updated successfully!");
    response.sendRedirect("CustomerServlet");
}
 else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean success = customerDAO.deleteCustomer(id);

                session.setAttribute("message", success ? "✅ Customer deleted successfully!" : "❌ Failed to delete customer!");
                List<Customer> customers = customerDAO.getAllCustomers();
                session.setAttribute("customers", customers);

                response.sendRedirect("CustomerServlet");
            }

            // 🔄 Luôn cập nhật session sau khi thêm/xóa/sửa khách hàng
//            customers = customerDAO.getAllCustomers();
//            session.setAttribute("customers", customers);
//            session.setAttribute("message", message);
        } catch (NumberFormatException e) {
            session.setAttribute("message", "⚠️ Invalid ID format!");
        } catch (Exception e) {
            session.setAttribute("message", "⚠️ Error: " + e.getMessage());
        }

        // Reload lại danh sách
    }

    private Integer parseInteger(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
