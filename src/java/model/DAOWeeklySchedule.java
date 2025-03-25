package model;

import entity.WeeklySchedule;
import entity.Employee;
import entity.Shift;
import entity.WeekDay;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOWeeklySchedule extends DBConnect {

    // Lấy toàn bộ lịch làm việc của tất cả nhân viên
    public Vector<WeeklySchedule> getAllEmployeeSchedule() {
        Vector<WeeklySchedule> schedules = new Vector<>();
        String sql = "SELECT ws.*, w.WeekDay, s.ShiftName, s.StartTime, s.EndTime, e.EmployeeName " +
                     "FROM WeeklySchedule ws " +
                     "JOIN WeekDays w ON ws.WeekDaysID = w.ID " +
                     "JOIN Shifts s ON ws.ShiftsID = s.ID " +
                     "JOIN Employees e ON ws.EmployeesID = e.ID";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                WeekDay weekDay = new WeekDay(rs.getInt("WeekDaysID"), rs.getString("WeekDay"));
                Shift shift = new Shift(rs.getInt("ShiftsID"), rs.getString("ShiftName"), rs.getTime("StartTime"), rs.getTime("EndTime"));
                Employee employee = new Employee(rs.getInt("EmployeesID"), rs.getString("EmployeeName"), null, null, true, 0, null, true, null);

                schedules.add(new WeeklySchedule(rs.getInt("ID"), weekDay, shift, employee));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
        }
        return schedules;
    }

    // Lấy danh sách tất cả ca làm việc
    public Vector<Shift> getAllShifts() {
        Vector<Shift> shifts = new Vector<>();
        String sql = "SELECT * FROM Shifts";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                shifts.add(new Shift(
                        rs.getInt("ID"),
                        rs.getString("ShiftName"),
                        rs.getTime("StartTime"),
                        rs.getTime("EndTime")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
        }
        return shifts;
    }

    // Lấy danh sách tất cả ngày trong tuần
    public Vector<WeekDay> getAllWeekDays() {
        Vector<WeekDay> weekDays = new Vector<>();
        String sql = "SELECT * FROM WeekDays";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                weekDays.add(new WeekDay(
                        rs.getInt("ID"),
                        rs.getString("WeekDay")
                ));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
        }
        return weekDays;
    }
    
// Phương thức xóa lịch làm việc của một nhân viên
public boolean deleteEmployeeSchedule(int scheduleID) {
    String sql = "DELETE FROM WeeklySchedule WHERE ID = ?";
    
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, scheduleID);
        return pstmt.executeUpdate() > 0;
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    }
}




// Thêm lịch làm việc mới cho nhân viên, kiểm tra trùng lặp
public boolean addEmployeeSchedule(int employeeID, int shiftID, int weekDayID) {
    // Trước khi thêm, kiểm tra xem có lịch nào đã tồn tại cho ca và ngày này chưa
    if (isScheduleExist(shiftID, weekDayID)) {
        return false; // Nếu có, không thêm được lịch và trả về false
    }

    String sql = "INSERT INTO WeeklySchedule (EmployeesID, ShiftsID, WeekDaysID) VALUES (?, ?, ?)";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);
        pstmt.setInt(2, shiftID);
        pstmt.setInt(3, weekDayID);
        return pstmt.executeUpdate() > 0;
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    }
}

// Kiểm tra xem lịch làm việc của ca và ngày này có tồn tại hay không
private boolean isScheduleExist(int shiftID, int weekDayID) {
    String sql = "SELECT COUNT(*) FROM WeeklySchedule WHERE ShiftsID = ? AND WeekDaysID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, shiftID);
        pstmt.setInt(2, weekDayID);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // Nếu số lượng lịch làm việc lớn hơn 0, tức là đã tồn tại lịch cho ca và ngày này
            return rs.getInt(1) > 0;
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return false; // Nếu không có lịch trùng lặp, trả về false
}

    // Lấy lịch làm việc của một nhân viên cụ thể
public Vector<WeeklySchedule> getEmployeeSchedule(int employeeID) {
    Vector<WeeklySchedule> schedules = new Vector<>();
    String sql = "SELECT ws.*, w.WeekDay, s.ShiftName, s.StartTime, s.EndTime, e.EmployeeName " +
                 "FROM WeeklySchedule ws " +
                 "JOIN WeekDays w ON ws.WeekDaysID = w.ID " +
                 "JOIN Shifts s ON ws.ShiftsID = s.ID " +
                 "JOIN Employees e ON ws.EmployeesID = e.ID " +
                 "WHERE ws.EmployeesID = ?"; // Sử dụng PreparedStatement để tránh SQL injection

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID); // Đảm bảo truyền đúng employeeID vào truy vấn
        ResultSet rs = pstmt.executeQuery(); // Thực thi truy vấn
        while (rs.next()) {
            // Tạo đối tượng WeekDay từ dữ liệu trả về
            WeekDay weekDay = new WeekDay(rs.getInt("WeekDaysID"), rs.getString("WeekDay"));
            
            // Tạo đối tượng Shift từ dữ liệu trả về
            Shift shift = new Shift(rs.getInt("ShiftsID"), rs.getString("ShiftName"), 
                                    rs.getTime("StartTime"), rs.getTime("EndTime"));
            
            // Tạo đối tượng Employee (chỉ lấy thông tin tên nhân viên từ query)
            Employee employee = new Employee(rs.getInt("EmployeesID"), rs.getString("EmployeeName"), 
                                             null, null, true, 0, null, true, null);
            
            // Tạo đối tượng WeeklySchedule và thêm vào danh sách
            schedules.add(new WeeklySchedule(rs.getInt("ID"), weekDay, shift, employee));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return schedules;
}
public boolean isEmployeeScheduled(int employeeID, int shiftID, Date workDate) {
    String sql = "SELECT COUNT(*) FROM WeeklySchedule WHERE EmployeesID = ? AND ShiftsID = ? AND WeekDaysID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);
        pstmt.setInt(2, shiftID);
        
        // Lấy ID của ngày hôm nay từ bảng WeekDays
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(workDate);
        int weekDayID = calendar.get(Calendar.DAY_OF_WEEK); // Java trả về 1 (Chủ nhật) -> 7 (Thứ 7)

        pstmt.setInt(3, weekDayID);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            return rs.getInt(1) > 0; // Trả về true nếu có lịch
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return false;
}
public Vector<Shift> getEmployeeShifts(int employeeID) {
    Vector<Shift> shifts = new Vector<>();
    String sql = "SELECT s.ID, s.ShiftName, s.StartTime, s.EndTime " +
                 "FROM WeeklySchedule ws " +
                 "JOIN Shifts s ON ws.ShiftsID = s.ID " +
                 "WHERE ws.EmployeesID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            shifts.add(new Shift(
                    rs.getInt("ID"),
                    rs.getString("ShiftName"),
                    rs.getTime("StartTime"),
                    rs.getTime("EndTime")
            ));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return shifts;
}
public Vector<Shift> getEmployeeShiftsToday(int employeeID) {
    Vector<Shift> shifts = new Vector<>();
    String sql = "SELECT s.* FROM WeeklySchedule ws " +
                 "JOIN Shifts s ON ws.ShiftsID = s.ID " +
                 "JOIN WeekDays w ON ws.WeekDaysID = w.ID " +
                 "WHERE ws.EmployeesID = ? AND w.ID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);

        // Lấy ID của ngày hôm nay từ bảng WeekDays
        Calendar calendar = Calendar.getInstance();
        int weekDayID = calendar.get(Calendar.DAY_OF_WEEK); // Java trả về 1 (Chủ nhật) -> 7 (Thứ 7)
        pstmt.setInt(2, weekDayID);

        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            shifts.add(new Shift(
                    rs.getInt("ID"),
                    rs.getString("ShiftName"),
                    rs.getTime("StartTime"),
                    rs.getTime("EndTime")
            ));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return shifts;
}
// Trong DAOWeeklySchedule.java
public Vector<Employee> getEmployeesInCurrentShift() {
    Vector<Employee> employees = new Vector<>();
    String sql = "DECLARE @CurrentTime TIME = CONVERT(TIME, GETDATE()) "
               + "DECLARE @CurrentDate DATE = CONVERT(DATE, GETDATE()) "
               + "DECLARE @CurrentWeekDay VARCHAR(255) = DATENAME(WEEKDAY, GETDATE()) "
               + "SELECT e.* FROM Employees e "
               + "JOIN WeeklySchedule ws ON e.ID = ws.EmployeesID "
               + "JOIN Shifts s ON ws.ShiftsID = s.ID "
               + "JOIN WeekDays wd ON ws.WeekDaysID = wd.ID "
               + "WHERE wd.WeekDay = @CurrentWeekDay "
               + "AND ((s.StartTime < s.EndTime AND @CurrentTime >= s.StartTime AND @CurrentTime < s.EndTime) "
               + "OR (s.StartTime > s.EndTime AND (@CurrentTime >= s.StartTime OR @CurrentTime < s.EndTime))) "
               + "AND e.IsAvailable = 1";

    try (Statement stmt = conn.createStatement(); 
         ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            employees.add(new Employee(
                rs.getInt("ID"),
                rs.getString("EmployeeName"),
                rs.getString("Avatar"),
                rs.getDate("DoB"),
                rs.getBoolean("Gender"),
                rs.getInt("Salary"),
                rs.getString("CCCD"),
                rs.getBoolean("IsAvailable"),
                null // Account có thể load sau nếu cần
            ));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return employees;
}
public Vector<Shift> getCurrentShifts() {
    Vector<Shift> shifts = new Vector<>();
    String sql = "DECLARE @CurrentTime TIME = CONVERT(TIME, GETDATE()) "
               + "SELECT * FROM Shifts WHERE "
               + "(StartTime < EndTime AND @CurrentTime >= StartTime AND @CurrentTime < EndTime) "
               + "OR (StartTime > EndTime AND (@CurrentTime >= StartTime OR @CurrentTime < EndTime))";

    try (Statement stmt = conn.createStatement(); 
         ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            shifts.add(new Shift(
                rs.getInt("ID"),
                rs.getString("ShiftName"),
                rs.getTime("StartTime"),
                rs.getTime("EndTime")
            ));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOWeeklySchedule.class.getName()).log(Level.SEVERE, null, ex);
    }
    return shifts;
}
}
