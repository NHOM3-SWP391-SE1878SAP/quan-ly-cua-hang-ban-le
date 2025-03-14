package controller;

import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import entity.Employee;
import dao.DAOWeeklySchedule;
import dao.DAOAttendance;
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

        if (employee == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        DAOWeeklySchedule daoWeeklySchedule = new DAOWeeklySchedule();
        DAOAttendance daoAttendance = new DAOAttendance();

        String action = request.getParameter("action");

        if ("markAttendance".equals(action)) {
            int employeeID = employee.getEmployeeID();
            LocalDate currentDate = LocalDate.now();
            LocalTime currentTime = LocalTime.now();

            // Xác định thứ trong tuần (1 = Monday, 7 = Sunday)
            int currentWeekDayID = currentDate.getDayOfWeek().getValue(); 

            // Lấy danh sách ca làm của nhân viên
            Vector<WeeklySchedule> employeeSchedules = daoWeeklySchedule.getEmployeeSchedule(employeeID);
            boolean isShiftValid = false;
            int validShiftID = -1;

            for (WeeklySchedule schedule : employeeSchedules) {
                Shift shift = schedule.getShift();
                WeekDay weekDay = schedule.getWeekDay();

                if (weekDay.getId() == currentWeekDayID) {
                    Time startTime = (Time) shift.getStartTime();
                    Time endTime = (Time) shift.getEndTime();

                    if (currentTime.isAfter(startTime.toLocalTime()) && currentTime.isBefore(endTime.toLocalTime())) {
                        isShiftValid = true;
                        validShiftID = shift.getShiftId();
                        break;
                    }
                }
            }

            if (isShiftValid) {
                // Chấm công nếu đúng ca
                boolean success = daoAttendance.addAttendance(employeeID, validShiftID, Date.valueOf(currentDate), true);
                request.setAttribute("message", success ? "Chấm công thành công!" : "Lỗi khi chấm công.");
            } else {
                // Nếu không đúng ca, gửi thông báo lỗi
                request.setAttribute("message", "Ca này không phải lịch của bạn hoặc không trong khung giờ làm việc.");
            }

            // Chuyển tiếp về trang điểm danh
            RequestDispatcher dispatcher = request.getRequestDispatcher("attendance.jsp");
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
