package controller;

import entity.Attendance;
import entity.AttendanceInfo;
import entity.WeeklySchedule;
import entity.Shift;
import entity.WeekDay;
import entity.Employee;
import model.DAOWeeklySchedule;
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
import model.DAOAttendance;
import model.DAOEmployee;

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
case "viewCurrentShift":
    Vector<Employee> currentShiftEmployees = dao.getEmployeesInCurrentShift();
    Vector<Shift> currentShifts = dao.getCurrentShifts();
    
    // Lấy thông tin điểm danh
    Vector<Integer> attendanceRecords = daoAttendance.getTodayAttendance();
    
    request.setAttribute("currentEmployees", currentShiftEmployees);
    request.setAttribute("currentShifts", currentShifts);
    request.setAttribute("attendanceRecords", attendanceRecords);
    
    request.getRequestDispatcher("CurrentShiftAttendance.jsp").forward(request, response);
    break;


case "markAttendance":
    int employeeId = Integer.parseInt(request.getParameter("employeeId"));
    int shiftId = Integer.parseInt(request.getParameter("shiftId"));
    boolean isPresent = Boolean.parseBoolean(request.getParameter("isPresent"));
    
    boolean result = new DAOAttendance().markAttendance(employeeId, shiftId, isPresent);
    
    if(result) {
        request.setAttribute("message", "Điểm danh thành công!");
    } else {
        request.setAttribute("error", "Lỗi khi điểm danh!");
    }
    response.sendRedirect("WeeklyScheduleController?service=getAllAttendanceHistory");
    break;    
    
case "updateAttendance":
    int attendanceId = Integer.parseInt(request.getParameter("attendanceId"));
    boolean newStatus = Boolean.parseBoolean(request.getParameter("isPresent"));
    
    boolean updateSuccess = new DAOAttendance().updateAttendance(attendanceId, newStatus);
    
    if (updateSuccess) {
        request.setAttribute("message", "Cập nhật trạng thái thành công!");
    } else {
        request.setAttribute("error", "Cập nhật trạng thái thất bại!");
    }
    
    // Load lại dữ liệu
    Vector<Attendance> updatedList = new DAOAttendance().getAllAttendanceHistory();
    request.setAttribute("attendanceList", updatedList);
    
    dispatcher = request.getRequestDispatcher("AttendanceHistory.jsp");
    dispatcher.forward(request, response);
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
