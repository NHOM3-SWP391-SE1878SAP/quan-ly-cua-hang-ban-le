package controller;

import entity.Account;
import entity.Employee;
import entity.Role;
import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import model.DAOAccount;
import model.DAOWeeklySchedule;
import model.DAOAttendance;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Vector;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        
        DAOAccount daoAccount = new DAOAccount();
        DAOWeeklySchedule daoWeeklySchedule = new DAOWeeklySchedule();
        DAOAttendance daoAttendance = new DAOAttendance();

        Account account = daoAccount.checkLogin1(userName, password);
        
        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            
            Role role = account.getRole();
            if (role != null) {
                String roleName = role.getRoleName();
                if ("Admin".equalsIgnoreCase(roleName)) {
                    response.sendRedirect("SalesReport.jsp"); 
                } else if ("Employee".equalsIgnoreCase(roleName)) {
                    Employee employee = daoAccount.getEmployeeByAccountID(account.getId());
                    
                    if (employee == null) {
                        session.setAttribute("errorMessage", "Tài khoản hiện không hoạt động");
                        request.getRequestDispatcher("Login.jsp").forward(request, response);
                        return;
                    }
                    
                    session.setAttribute("employee", employee);
                    
                    // Get current date and time
                    LocalDate currentDate = LocalDate.now();
                    LocalTime currentTime = LocalTime.now();
                    
                    // Get all employees in current shift
                    Vector<Employee> currentShiftEmployees = daoWeeklySchedule.getEmployeesInCurrentShift();
                    
                    // Check if current employee is in the current shift
                    boolean isInCurrentShift = false;
                    Shift currentShift = null;
                    
                    for (Employee emp : currentShiftEmployees) {
                        if (emp.getEmployeeID() == employee.getEmployeeID()) {
                            isInCurrentShift = true;
                            // Get the current shift details
                            Vector<Shift> currentShifts = daoWeeklySchedule.getCurrentShifts();
                            if (!currentShifts.isEmpty()) {
                                currentShift = currentShifts.get(0); // Assuming one shift per employee
                            }
                            break;
                        }
                    }
                    
                    if (!isInCurrentShift || currentShift == null) {
                        session.setAttribute("errorMessage", "HIỆN KHÔNG PHẢI CA LÀM CỦA BẠN");
                        request.getRequestDispatcher("Login.jsp").forward(request, response);
                        return;
                    }
                    
                    session.setAttribute("currentShift", currentShift);
                    
                    // Check if attendance has been marked for today
                    boolean isAttendanceMarked = daoAttendance.isEmployeeScheduled(
                            employee.getEmployeeID(), 
                            currentShift.getShiftId(), 
                            java.sql.Date.valueOf(currentDate));
                    
                    if (isAttendanceMarked) {
                        response.sendRedirect("sale"); // Redirect to home if attendance is already marked
                    } else {
                        response.sendRedirect("attendance.jsp"); // Redirect to attendance page if not
                    }
                } else {
                    response.sendRedirect("Login.jsp"); 
                }
            } else {
                response.sendRedirect("Login.jsp"); 
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}