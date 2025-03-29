package controller;

import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import entity.Employee;
import model.DAOWeeklySchedule;
import model.DAOAttendance;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Vector;

@WebServlet(name = "AttendanceController", urlPatterns = {"/AttendanceController"})
public class AttendanceController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");
        Shift currentShift = (Shift) session.getAttribute("currentShift");

        if (employee == null || currentShift == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        DAOAttendance daoAttendance = new DAOAttendance();
        String action = request.getParameter("action");

        if ("markAttendance".equals(action)) {
            try {
                int employeeID = employee.getEmployeeID();
                int shiftID = currentShift.getShiftId(); // Sử dụng shiftID từ session
                LocalDate currentDate = LocalDate.now();
                
                // Kiểm tra xem đã chấm công chưa
                boolean isAttendanceMarked = daoAttendance.isEmployeeScheduled(
                    employeeID, 
                    shiftID, 
                    Date.valueOf(currentDate)
                );
                
                if (isAttendanceMarked) {
                    request.setAttribute("message", "Bạn đã chấm công ca này rồi.");
                } else {
                    // Chấm công (luôn là true vì đã bỏ checkbox)
                    boolean success = daoAttendance.addAttendance(
                        employeeID, 
                        shiftID, 
                        Date.valueOf(currentDate), 
                        true
                    );
                    
                    if (success) {
                        request.setAttribute("message", "Chấm công thành công!");
                        // Cập nhật trạng thái trong session
                        session.setAttribute("attendanceMarked", true);
                    } else {
                        request.setAttribute("message", "Lỗi khi chấm công vào database.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("message", "Lỗi hệ thống khi chấm công: " + e.getMessage());
            }
            
            // Chuyển hướng về trang chấm công
            RequestDispatcher dispatcher = request.getRequestDispatcher("sale");
            dispatcher.forward(request, response);
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