package controller;

import dao.CustomerDAO;
import model.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class CustomerServlet extends HttpServlet {
    private CustomerDAO customerDAO = new CustomerDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Customer> customers = customerDAO.getAllCustomers();

        // Kiểm tra nếu danh sách null, gán danh sách rỗng để tránh lỗi NullPointerException
        if (customers == null) {
            customers = new ArrayList<>();
        }

        request.setAttribute("customers", customers);
        request.getRequestDispatcher("customers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String customerName = request.getParameter("customerName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Kiểm tra giá trị "points" có null không trước khi chuyển đổi
            Integer points = null;
            String pointsParam = request.getParameter("points");
            if (pointsParam != null && !pointsParam.trim().isEmpty()) {
                try {
                    points = Integer.parseInt(pointsParam);
                } catch (NumberFormatException e) {
                    points = null; // Nếu không hợp lệ, gán giá trị null
                }
            }

            Customer customer = new Customer(0, customerName, phone, address, points);
            customerDAO.addCustomer(customer);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            customerDAO.deleteCustomer(id);
        }
        response.sendRedirect("CustomerServlet");
    }
}
