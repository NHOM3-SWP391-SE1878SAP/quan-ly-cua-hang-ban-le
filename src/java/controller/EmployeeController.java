package controller;

import entity.Account;
import entity.Employee;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.util.Vector;
import model.DAOEmployee;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "EmployeeController", urlPatterns = {"/EmployeeControllerURL"})
public class EmployeeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAOEmployee dao = new DAOEmployee();

        String service = request.getParameter("service");
        if (service == null) {
            service = "getAllEmployees";
        }

        switch (service) {
            case "getAllEmployees":
                Vector<Employee> employees = dao.getAllEmployees();
                request.setAttribute("employees", employees);
                RequestDispatcher dispatcher = request.getRequestDispatcher("EmployeeManagement.jsp");
                dispatcher.forward(request, response);
                break;

            case "addEmployee":
                String name = request.getParameter("employeeName");
                String avatar = request.getParameter("avatar");
                String dobStr = request.getParameter("dob");
                String gender = request.getParameter("gender");
                int salary = Integer.parseInt(request.getParameter("salary"));
                String cccd = request.getParameter("cccd");
                boolean isAvailable = Boolean.parseBoolean(request.getParameter("isAvailable"));

                String username = request.getParameter("userName");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                int phone = Integer.parseInt(request.getParameter("phone"));
                String address = request.getParameter("address");

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dob = null;
                try {
                    dob = sdf.parse(dobStr);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                Account account = new Account(0, username, password, email, phone, address, null);
                Employee emp = new Employee(0, name, avatar, dob, gender, salary, cccd, isAvailable, account);

                boolean isAdded = dao.addEmployee(emp);
                if (isAdded) {
                    request.setAttribute("message", "Employee added successfully.");
                } else {
                    request.setAttribute("message", "Failed to add employee.");
                }

                response.sendRedirect("EmployeeControllerURL?service=getAllEmployees");
                break;

            
            case "deleteEmployee":
                String employeeID = request.getParameter("employeeID");
                if (employeeID != null) {
                    boolean isDeleted = dao.deleteEmployee(Integer.parseInt(employeeID));
                    if (isDeleted) {
                        request.setAttribute("message", "Employee deleted successfully.");
                    } else {
                        request.setAttribute("message", "Failed to delete employee.");
                    }
                } else {
                    request.setAttribute("message", "Employee ID is required.");
                }
                // After deleting, redirect to the employee list page
                response.sendRedirect("EmployeeControllerURL?service=getAllEmployees");
                break;

        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
