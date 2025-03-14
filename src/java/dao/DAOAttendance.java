package dao;

import entity.Attendance;
import entity.Employee;
import entity.Shift;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOAttendance extends DBConnect {

    // Thêm điểm danh cho nhân viên
    public boolean addAttendance(int employeeID, int shiftID, Date workDate, boolean isPresent) {
        String sql = "INSERT INTO Attendance (WorkDate, IsPresent, EmployeesID, ShiftsID) VALUES (?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, new java.sql.Date(workDate.getTime()));
            pstmt.setBoolean(2, isPresent);
            pstmt.setInt(3, employeeID);
            pstmt.setInt(4, shiftID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOAttendance.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    // Lấy lịch sử điểm danh của một nhân viên
    public Vector<Attendance> getAttendanceHistory(int employeeID) {
        Vector<Attendance> attendanceList = new Vector<>();
        String sql = "SELECT a.*, e.EmployeeName, s.ShiftName, s.StartTime, s.EndTime " +
                     "FROM Attendance a " +
                     "JOIN Employees e ON a.EmployeesID = e.ID " +
                     "JOIN Shifts s ON a.ShiftsID = s.ID " +
                     "WHERE a.EmployeesID = ? " +
                     "ORDER BY a.WorkDate DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, employeeID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Employee employee = new Employee(rs.getInt("EmployeesID"), rs.getString("EmployeeName"), 
                                                 null, null, true, 0, null, true, null);
                Shift shift = new Shift(rs.getInt("ShiftsID"), rs.getString("ShiftName"), 
                                        rs.getTime("StartTime"), rs.getTime("EndTime"));

                attendanceList.add(new Attendance(rs.getInt("ID"), rs.getDate("WorkDate"), 
                                                  rs.getBoolean("IsPresent"), employee, shift));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAttendance.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attendanceList;
    }

    // Admin xem lịch sử điểm danh của tất cả nhân viên
    public Vector<Attendance> getAllAttendanceHistory() {
        Vector<Attendance> attendanceList = new Vector<>();
        String sql = "SELECT a.*, e.EmployeeName, s.ShiftName, s.StartTime, s.EndTime " +
                     "FROM Attendance a " +
                     "JOIN Employees e ON a.EmployeesID = e.ID " +
                     "JOIN Shifts s ON a.ShiftsID = s.ID " +
                     "ORDER BY a.WorkDate DESC";

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Employee employee = new Employee(rs.getInt("EmployeesID"), rs.getString("EmployeeName"), 
                                                 null, null, true, 0, null, true, null);
                Shift shift = new Shift(rs.getInt("ShiftsID"), rs.getString("ShiftName"), 
                                        rs.getTime("StartTime"), rs.getTime("EndTime"));

                attendanceList.add(new Attendance(rs.getInt("ID"), rs.getDate("WorkDate"), 
                                                  rs.getBoolean("IsPresent"), employee, shift));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOAttendance.class.getName()).log(Level.SEVERE, null, ex);
        }
        return attendanceList;
    }


//    public static void main(String[] args) {
//        DAOAttendance daoAttendance = new DAOAttendance();
//        
//        // Dữ liệu kiểm thử
//        int employeeID = 1; // Thay bằng ID nhân viên hợp lệ trong database
//        int shiftID = 1; // Thay bằng ID ca làm hợp lệ trong database
//        Date workDate = Date.valueOf("2025-03-10"); // Ngày làm việc kiểm thử
//        boolean isPresent = true; // Trạng thái điểm danh
//        
//        // Gọi phương thức addAttendance để thêm điểm danh
//        boolean result = daoAttendance.addAttendance(employeeID, shiftID, workDate, isPresent);
//        
//        // Kiểm tra kết quả
//        if (result) {
//            System.out.println("Thêm điểm danh thành công!");
//        } else {
//            System.out.println("Thêm điểm danh thất bại!");
//        }
//    }
    
public boolean isEmployeeScheduled(int employeeID, int shiftID, Date workDate) {
    String sql = "SELECT COUNT(*) FROM Attendance WHERE EmployeesID = ? AND ShiftsID = ? AND WorkDate = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);
        pstmt.setInt(2, shiftID);
        pstmt.setDate(3, workDate); // Set the work date for the attendance check

        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // If the count is greater than 0, the employee has already marked attendance for this shift on the given date
            return rs.getInt(1) > 0;
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOAttendance.class.getName()).log(Level.SEVERE, null, ex);
    }
    return false; // If no attendance record is found, return false
}

public Vector<Attendance> getAttendanceHistoryFiltered(int employeeID, Date workDate) {
    Vector<Attendance> attendanceList = new Vector<>();
    String sql = "SELECT a.*, e.EmployeeName, s.ShiftName, s.StartTime, s.EndTime " +
                 "FROM Attendance a " +
                 "JOIN Employees e ON a.EmployeesID = e.ID " +
                 "JOIN Shifts s ON a.ShiftsID = s.ID " +
                 "WHERE 1 = 1"; // Filtre dynamique

    // Ajout du filtre sur l'employeeID si fourni
    if (employeeID > 0) {
        sql += " AND a.EmployeesID = ?";
    }

    // Ajout du filtre sur la date de travail si fournie
    if (workDate != null) {
        sql += " AND a.WorkDate = ?";
    }

    sql += " ORDER BY a.WorkDate DESC"; // Trier par date de travail

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        int index = 1;
        
        // Si employeeID est fourni, ajoutez-le au prepared statement
        if (employeeID > 0) {
            pstmt.setInt(index++, employeeID);
        }

        // Si workDate est fourni, ajoutez-le au prepared statement
        if (workDate != null) {
            pstmt.setDate(index, workDate);
        }

        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            Employee employee = new Employee(rs.getInt("EmployeesID"), rs.getString("EmployeeName"),
                                             null, null, true, 0, null, true, null);
            Shift shift = new Shift(rs.getInt("ShiftsID"), rs.getString("ShiftName"),
                                    rs.getTime("StartTime"), rs.getTime("EndTime"));

            attendanceList.add(new Attendance(rs.getInt("ID"), rs.getDate("WorkDate"),
                                              rs.getBoolean("IsPresent"), employee, shift));
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOAttendance.class.getName()).log(Level.SEVERE, null, ex);
    }
    return attendanceList;
}

public static void main(String[] args) {
        // Créer une instance de DAOAttendance
        DAOAttendance daoAttendance = new DAOAttendance();
        
        // Tester la méthode getAllAttendanceHistory
        Vector<Attendance> attendanceHistory = daoAttendance.getAllAttendanceHistory();

        // Afficher les résultats
        if (attendanceHistory != null && !attendanceHistory.isEmpty()) {
            System.out.println("Historique điểm danh của tất cả nhân viên:");
            for (Attendance attendance : attendanceHistory) {
                // Affichage des informations de la présence
                System.out.println("ID: " + attendance.getId());
                System.out.println("Ngày làm việc: " + attendance.getWorkDate());
                System.out.println("Nhân viên: " + attendance.getEmployeesID().getEmployeeName());
                System.out.println("Ca làm: " + attendance.getShiftsID().getShiftName());
                System.out.println("Trạng thái: " + (attendance.isPresent() ? "Có mặt" : "Vắng mặt"));
                System.out.println("====================================");
            }
        } else {
            System.out.println("Không có lịch sử điểm danh!");
        }
    }
}
