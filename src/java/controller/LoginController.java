package controller;

import entity.Account;
import entity.Employee;
import entity.Role;
import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import dao.DAOAccount;
import dao.DAOWeeklySchedule;
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
import dao.DAOAttendance;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        
        DAOAccount dao = new DAOAccount();
        DAOWeeklySchedule daoWeeklySchedule = new DAOWeeklySchedule();
        DAOAttendance daoAttendance = new DAOAttendance();  // DAO to check attendance

        Account account = dao.checkLogin(userName, password);
        
        if (account != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            
            Role role = account.getRole();
            if (role != null) {
                String roleName = role.getRoleName();
                if ("Admin".equalsIgnoreCase(roleName)) {
                    response.sendRedirect("HeaderAdmin.jsp"); 
                } else if ("Employee".equalsIgnoreCase(roleName)) {
                    session.setAttribute("account", account);
            
                    Employee employee = dao.getEmployeeByAccountID(account.getId());
                    session.setAttribute("employee", employee);

                    // Xác định ca làm hiện tại
                    LocalDate currentDate = LocalDate.now();
                    LocalTime currentTime = LocalTime.now();
                    int currentWeekDayID = currentDate.getDayOfWeek().getValue(); 

                    Vector<WeeklySchedule> employeeSchedules = daoWeeklySchedule.getEmployeeSchedule(employee.getEmployeeID());
                    Shift currentShift = null;
                    boolean isShiftValid = false;

                    for (WeeklySchedule schedule : employeeSchedules) {
                        Shift shift = schedule.getShift();
                        WeekDay weekDay = schedule.getWeekDay();

                        if (weekDay.getId() == currentWeekDayID) {
                            Time startTime = (Time) shift.getStartTime();
                            Time endTime = (Time) shift.getEndTime();

                            if (currentTime.isAfter(startTime.toLocalTime()) && currentTime.isBefore(endTime.toLocalTime())) {
                                isShiftValid = true;
                                currentShift = shift;
                                break;
                            }
                        }
                    }

                    // If no valid shift is found, display message and stay on current page
                    if (currentShift == null) {
                        session.setAttribute("shiftMessage", "ĐÂY KHÔNG PHẢI CA LÀM CỦA BẠN");
                        request.getRequestDispatcher("attendance.jsp").forward(request, response);
                        return;  // Exit the method and stay on the current page
                    }

                    // Set currentShift if it's valid
                    session.setAttribute("currentShift", currentShift);

                    if (isShiftValid) {
                        session.setAttribute("shiftMessage", "Bạn đang trong ca làm của mình.");
                    } else {
                        session.setAttribute("shiftMessage", "Ca làm hiện tại không phải lịch của bạn.");
                    }

                    // Check if attendance has been marked for today
                    boolean isAttendanceMarked = daoAttendance.isEmployeeScheduled(employee.getEmployeeID(), currentShift.getShiftId(), java.sql.Date.valueOf(currentDate));

                    if (isAttendanceMarked) {
                        response.sendRedirect("homeEmployee.jsp"); // Redirect to home if attendance is already marked
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
