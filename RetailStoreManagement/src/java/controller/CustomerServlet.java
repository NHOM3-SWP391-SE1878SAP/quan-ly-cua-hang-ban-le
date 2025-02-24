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

    private CustomerDAO customerDAO = new CustomerDAO();

     protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        List<Customer> customers;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customers = customerDAO.searchCustomers(searchQuery);
        } else {
            customers = customerDAO.getAllCustomers();
        }

        // ✅ Lưu danh sách khách hàng vào session để không bị mất khi quay lại
        HttpSession session = request.getSession();
        session.setAttribute("customers", customers);

       response.sendRedirect("customers.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            customerDAO.deleteCustomer(Integer.parseInt(request.getParameter("id")));
        }
        response.sendRedirect("CustomerServlet");
    }

    
}
