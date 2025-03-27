package controller;

import com.google.gson.Gson;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DAOCustomer;

import java.io.IOException;
import java.util.stream.Collectors;

@WebServlet(name = "CustomerController", urlPatterns = {"/CustomerControllerURL"})
public class CustomerController extends HttpServlet {
    private DAOCustomer daoCustomer = new DAOCustomer();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String service = request.getParameter("service");

        if (service == null) {
            service = "listAll"; 
        }

        switch (service) {
            case "addCustomerInSale":
                addCustomerInSale(request, response);
                break;
            default:
                response.sendRedirect("customers.jsp");
        }
    }

    private void addCustomerInSale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get customer data from request (via JSON)
        String jsonData = request.getReader().lines().collect(Collectors.joining());
        Gson gson = new Gson();
        Customer customer = gson.fromJson(jsonData, Customer.class);

        // Validate if required fields are provided
        if (customer.getCustomerName() == null || customer.getPhone() == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Customer Name and Phone are required!\"}");
            return;
        }

        // Add customer to database using the DAO
        boolean success = daoCustomer.addCustomerInSale(customer);

        // Return the added customer information in the response
        response.setContentType("application/json");
        String responseJson = "{\"success\": " + success + ", \"customer\": " + gson.toJson(customer) + "}";
        response.getWriter().write(responseJson);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
