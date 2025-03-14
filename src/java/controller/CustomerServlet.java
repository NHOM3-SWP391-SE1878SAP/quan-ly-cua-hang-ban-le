package controller;

import java.sql.Connection;
import dao.CustomerDAO;
import database.DatabaseConnection;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/CustomerServlet"})


public class CustomerServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private CustomerDAO customerDAO;

    @Override
    public void init() throws ServletException {
        Connection conn = new DatabaseConnection().getConnection();
        this.customerDAO = new CustomerDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String keyword = request.getParameter("search");

        int page = 1; 
        int recordsPerPage = 10; 

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1; 
            }
        }

        paginateCustomers(request, keyword, page, recordsPerPage);
        request.getRequestDispatcher("customers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("customerName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                Integer points = parseInteger(request.getParameter("points"));
                Customer customer = new Customer(name, phone, address, points);
                customerDAO.addCustomer(customer);
                session.setAttribute("message", "✅ Customer added successfully!");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("customerName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                Integer points = parseInteger(request.getParameter("points"));
                Customer customer = new Customer(id, name, phone, address, points);
                customerDAO.updateCustomer(customer);
                session.setAttribute("message", "✅ Customer updated successfully!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                customerDAO.deleteCustomer(id);
                session.setAttribute("message", "🗑️ Customer deleted successfully!");
            }

            // ✅ Cập nhật danh sách khách hàng ngay sau CRUD
            paginateCustomers(request, null, 1, 10);

        } catch (Exception e) {
            session.setAttribute("message", "❌ Error: " + e.getMessage());
        }

        response.sendRedirect("CustomerServlet?page=1"); 
    }

    private void paginateCustomers(HttpServletRequest request, String keyword, int page, int recordsPerPage) {
        List<Customer> customers;
        int totalRecords;

        if (keyword == null || keyword.trim().isEmpty()) {
            totalRecords = customerDAO.getTotalCustomerCount(); 
            customers = customerDAO.getCustomersByPage(page, recordsPerPage);
        } else {
            customers = customerDAO.searchCustomers(keyword);
            totalRecords = customers.size();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("customers", customers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
    }

    private Integer parseInteger(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value) : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
