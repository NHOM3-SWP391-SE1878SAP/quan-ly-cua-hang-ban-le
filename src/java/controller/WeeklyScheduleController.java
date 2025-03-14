package controller;

import entity.Attendance;
import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import entity.Employee;
import dao.DAOWeeklySchedule;
import jakarta.servlet.RequestDispatcher;
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
import java.util.Date;
import java.util.Vector;
import dao.DAOAttendance;
import dao.DAOEmployee;

@WebServlet(name = "WeeklyScheduleController", urlPatterns = {"/WeeklyScheduleController"})
public class WeeklyScheduleController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOWeeklySchedule dao = new DAOWeeklySchedule();
        DAOEmployee daoEmployee = new DAOEmployee(); // Gọi DAOEmployee để lấy nhân viên
        DAOAttendance daoAttendance = new DAOAttendance(); // Gọi DAOAttendance để lấy lịch sử điểm danh

        String service = request.getParameter("service");

        if (service == null) {
            service = "getAllSchedules";
        }

        switch (service) {
            case "getAllSchedules":
                Vector<WeeklySchedule> allSchedules = dao.getAllEmployeeSchedule();
                Vector<Shift> shifts = dao.getAllShifts();
                Vector<WeekDay> weekDays = dao.getAllWeekDays();
                Vector<Employee> employees = daoEmployee.getAllEmployees(); // Lấy danh sách nhân viên từ CSDL

                request.setAttribute("schedule", allSchedules);
                request.setAttribute("shifts", shifts);
                request.setAttribute("weekDays", weekDays);
                request.setAttribute("employees", employees); // Gửi danh sách nhân viên đến JSP

                RequestDispatcher dispatcher = request.getRequestDispatcher("WeeklySchedule.jsp");
                dispatcher.forward(request, response);
                break;

            case "addSchedule":
                int empID = Integer.parseInt(request.getParameter("employeeID"));
                int shiftID = Integer.parseInt(request.getParameter("shiftID"));
                int weekDayID = Integer.parseInt(request.getParameter("weekDayID"));

                boolean success = dao.addEmployeeSchedule(empID, shiftID, weekDayID);

                // Nếu lịch đã tồn tại, gửi thông báo lỗi
                if (success) {
                    request.setAttribute("message", "Lịch làm việc đã được thêm.");
                } else {
                    request.setAttribute("message", "Không thể thêm lịch. Lịch làm việc đã tồn tại cho ca và ngày này.");
                }

                // Sau khi xử lý, chuyển tiếp đến trang WeeklySchedule.jsp
                request.getRequestDispatcher("WeeklyScheduleController?service=getAllSchedules").forward(request, response);
                break;

            case "deleteSchedule":
                int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
                boolean deleteSuccess = dao.deleteEmployeeSchedule(scheduleID);
                if (deleteSuccess) {
                    request.setAttribute("message", "Lịch làm việc đã được xóa.");
                } else {
                    request.setAttribute("message", "Không thể xóa lịch.");
                }

                response.sendRedirect("WeeklyScheduleController?service=getAllSchedules");
                break;

            // Ajouter l'option pour récupérer l'historique des présences
            case "getAllAttendanceHistory":
                Vector<Attendance> attendanceHistory = daoAttendance.getAllAttendanceHistory();
                request.setAttribute("attendanceList", attendanceHistory); // Envoyer l'historique à la JSP
                RequestDispatcher dispatcherHistory = request.getRequestDispatcher("AttendanceHistory.jsp");
                dispatcherHistory.forward(request, response);
                break;
            case "attendanceForEmployee":
    

                
                
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
