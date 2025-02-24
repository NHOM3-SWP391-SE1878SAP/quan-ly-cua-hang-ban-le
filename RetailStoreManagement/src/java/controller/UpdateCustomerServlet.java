package controller;

import dao.CustomerDAO;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class UpdateCustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO = new CustomerDAO();

   protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Customer customer = customerDAO.getCustomerById(id);

        if (customer == null) {
            response.sendRedirect("CustomerServlet?error=Customer%20not%20found");
        } else {
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("update_customer.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        Integer points = parseInteger(request.getParameter("points"));

        Customer customer = new Customer(id, name, phone, address, points);
        customerDAO.updateCustomer(customer);

          response.sendRedirect("CustomerServlet");
    }

    private Integer parseInteger(String value) {
        try {
            return (value != null && !value.trim().isEmpty()) ? Integer.parseInt(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
