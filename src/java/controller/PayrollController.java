package controller;

import entity.EmployeePayroll;
import model.DAOEmployeePayroll;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.YearMonth;
import java.util.Vector;

@WebServlet(name = "PayrollController", urlPatterns = {"/PayrollController"})
public class PayrollController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOEmployeePayroll dao = new DAOEmployeePayroll();
        
        // Retrieve month and year from request
        String monthStr = request.getParameter("month");
        String yearStr = request.getParameter("year");

        int month, year;
        
        if (monthStr != null && yearStr != null) {
            try {
                month = Integer.parseInt(monthStr);
                year = Integer.parseInt(yearStr);
            } catch (NumberFormatException e) {
                month = YearMonth.now().getMonthValue(); // Current month
                year = YearMonth.now().getYear();        // Current year
            }
        } else {
            month = YearMonth.now().getMonthValue();
            year = YearMonth.now().getYear();
        }

        // Step 1: Ensure Payroll Exists
        dao.createPayrollForMonth(month, year);

        // Step 2: Generate Payroll from Attendance
        dao.generateEmployeePayroll(month, year);

        // Step 3: Retrieve Payroll Data
        Vector<EmployeePayroll> payrollList = dao.getPayrollWithAttendance(month, year);

        // Send data to JSP
        request.setAttribute("payrollList", payrollList);
        request.setAttribute("selectedMonth", month);
        request.setAttribute("selectedYear", year);

        RequestDispatcher dispatcher = request.getRequestDispatcher("Payroll.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

  @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    String payButton = request.getParameter("payButton");
    
    if (payButton != null) {
        int payrollID = Integer.parseInt(request.getParameter("payrollID"));
        int employeeID = Integer.parseInt(request.getParameter("employeeID"));
        
        DAOEmployeePayroll dao = new DAOEmployeePayroll();
        boolean success = dao.updatePayDate(payrollID, employeeID);
        
        if (success) {
            System.out.println("Payment completed for Employee ID " + employeeID);
        } else {
            System.out.println("Payment update failed for Employee ID " + employeeID);
        }
    }
    
    // Refresh the page to update payroll list
    processRequest(request, response);
}

}
