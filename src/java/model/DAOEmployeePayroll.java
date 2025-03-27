package model;

import entity.EmployeePayroll;
import entity.Employee;
import entity.Payroll;
import java.sql.*;
import java.time.LocalDate;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOEmployeePayroll extends DBConnect {

    // Automatically create Payroll for the month if it doesn't exist
    public boolean createPayrollForMonth(int month, int year) {
        String checkSql = "SELECT COUNT(*) FROM Payroll WHERE Month = ? AND Year = ?";
        String insertSql = "INSERT INTO Payroll (Month, Year, StartDate, EndDate) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setInt(1, month);
            checkStmt.setInt(2, year);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Payroll for this month already exists
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Generate the first and last day of the month
        LocalDate startDate = LocalDate.of(year, month, 1);
        LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            insertStmt.setInt(1, month);
            insertStmt.setInt(2, year);
            insertStmt.setDate(3, java.sql.Date.valueOf(startDate));
            insertStmt.setDate(4, java.sql.Date.valueOf(endDate));
            return insertStmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    // Get Payroll ID for a specific month and year
    public int getPayrollID(int month, int year) {
        String sql = "SELECT ID FROM Payroll WHERE Month = ? AND Year = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("ID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

   public void generateEmployeePayroll(int month, int year) {
    int payrollID = getPayrollID(month, year);
    if (payrollID == -1) {
        System.out.println("Payroll not found. Creating payroll first...");
        if (!createPayrollForMonth(month, year)) {
            System.out.println("Failed to create payroll.");
            return;
        }
        payrollID = getPayrollID(month, year);
    }

    // Clear existing payroll data for this month in Employees_Payroll
    String deleteSql = "DELETE FROM Employees_Payroll WHERE PayrollID = ?";
    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
        deleteStmt.setInt(1, payrollID);
        deleteStmt.executeUpdate();
        System.out.println("Old payroll data deleted successfully.");
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
        System.out.println("Error deleting old payroll data.");
    }

    // Retrieve start and end dates of the payroll period for the month
    LocalDate startDate = LocalDate.of(year, month, 1);
    LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

    // Insert new payroll data based on attendance, excluding PayDate
    String sql = "INSERT INTO Employees_Payroll (EmployeesID, PayrollID, WorkDays) " +
                 "SELECT e.ID, ?, COUNT(a.ID) " +
                 "FROM Employees e " +
                 "LEFT JOIN Attendance a ON e.ID = a.EmployeesID AND a.IsPresent = 1 " +
                 "WHERE a.WorkDate BETWEEN ? AND ? " +
                 "AND NOT EXISTS (SELECT 1 FROM Employees_Payroll ep WHERE ep.PayrollID = ? AND ep.EmployeesID = e.ID AND ep.PayDate IS NOT NULL) " + // Skip employees who have already been paid
                 "GROUP BY e.ID";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, payrollID);
        pstmt.setDate(2, java.sql.Date.valueOf(startDate));  // Set start date
        pstmt.setDate(3, java.sql.Date.valueOf(endDate));    // Set end date
        pstmt.setInt(4, payrollID);  // Use payrollID for the subquery
        pstmt.executeUpdate();
        System.out.println("Payroll data inserted successfully without PayDate.");
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
    }
}




public boolean updatePayDate(int payrollID, int employeeID) {
    String sql = "UPDATE Employees_Payroll SET PayDate = ? WHERE PayrollID = ? AND EmployeesID = ?";
    
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setDate(1, java.sql.Date.valueOf(LocalDate.now())); // Set current date
        pstmt.setInt(2, payrollID);
        pstmt.setInt(3, employeeID);
        int rowsUpdated = pstmt.executeUpdate();
        
        if (rowsUpdated > 0) {
            System.out.println("PayDate updated successfully for Employee ID: " + employeeID);
            return true;
        } else {
            System.out.println("No rows updated. Check PayrollID and EmployeeID.");
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
    }
    return false;
}



    // Retrieve payroll with calculated salary
    public Vector<EmployeePayroll> getPayrollWithAttendance(int month, int year) {
        Vector<EmployeePayroll> payrollList = new Vector<>();
       String sql = "SELECT e.ID AS EmployeeID, e.EmployeeName, e.Salary, ep.WorkDays, ep.OffDays, ep.PayDate, " + // Thêm OffDays
                 "p.ID AS PayrollID, p.StartDate, p.EndDate " +
                 "FROM Employees e " +
                 "JOIN Employees_Payroll ep ON e.ID = ep.EmployeesID " +
                 "JOIN Payroll p ON ep.PayrollID = p.ID " +
                 "WHERE p.Month = ? AND p.Year = ? " +
                 "ORDER BY e.ID";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Employee employee = new Employee(
                    rs.getInt("EmployeeID"),
                    rs.getString("EmployeeName"),
                    null, null, true,
                    rs.getInt("Salary"),
                    null, true, null
                );

                Payroll payroll = new Payroll(
                    rs.getInt("PayrollID"),
                    month,
                    year,
                    rs.getDate("StartDate"),
                    rs.getDate("EndDate")
                );

                int workDays = rs.getInt("WorkDays");
    int offDays = rs.getInt("OffDays"); // Lấy giá trị OffDays
    Date payDate = rs.getDate("PayDate");

 EmployeePayroll employeePayroll = new EmployeePayroll(0, employee, payroll, workDays, offDays, payDate);
 payrollList.add(employeePayroll);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
        }
        return payrollList;
    }
public String getPayrollStatus(int payrollID, int employeeID) {
    String sql = "SELECT PayDate FROM Employees_Payroll WHERE PayrollID = ? AND EmployeesID = ?";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, payrollID);
        pstmt.setInt(2, employeeID);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getDate("PayDate") == null ? "Chưa thanh toán" : "Đã thanh toán";
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
    }
    return "Chưa thanh toán";
}
public void generateEmployeePayroll1(int month, int year) {
    int payrollID = getPayrollID(month, year);
    if (payrollID == -1) {
        System.out.println("Payroll not found. Creating payroll first...");
        if (!createPayrollForMonth(month, year)) {
            System.out.println("Failed to create payroll.");
            return;
        }
        payrollID = getPayrollID(month, year);
    }

    // Chỉ xóa những bản ghi chưa được thanh toán (PayDate = null)
    String deleteSql = "DELETE FROM Employees_Payroll WHERE PayrollID = ? AND PayDate IS NULL";
    try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
        deleteStmt.setInt(1, payrollID);
        deleteStmt.executeUpdate();
        System.out.println("Old unpaid payroll data deleted successfully.");
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
        System.out.println("Error deleting old unpaid payroll data.");
    }

    LocalDate startDate = LocalDate.of(year, month, 1);
    LocalDate endDate = startDate.withDayOfMonth(startDate.lengthOfMonth());

    // Thêm điều kiện để chỉ chèn những nhân viên chưa có PayDate
    // Cập nhật SQL để đếm cả WorkDays và OffDays
    String sql = "INSERT INTO Employees_Payroll (EmployeesID, PayrollID, WorkDays, OffDays) " +
                 "SELECT e.ID, ?, " +
                 "COUNT(CASE WHEN a.IsPresent = 1 THEN 1 END), " + 
                 "COUNT(CASE WHEN a.IsPresent = 0 THEN 1 END) " +
                 "FROM Employees e " +
                 "LEFT JOIN Attendance a ON e.ID = a.EmployeesID AND a.WorkDate BETWEEN ? AND ? " +
                 "WHERE NOT EXISTS (SELECT 1 FROM Employees_Payroll ep WHERE ep.PayrollID = ? AND ep.EmployeesID = e.ID) " +
                 "GROUP BY e.ID";


    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, payrollID);
        pstmt.setDate(2, java.sql.Date.valueOf(startDate));
        pstmt.setDate(3, java.sql.Date.valueOf(endDate));
        pstmt.setInt(4, payrollID);
        pstmt.executeUpdate();
        System.out.println("New payroll data inserted successfully.");
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployeePayroll.class.getName()).log(Level.SEVERE, null, ex);
    }
}
    // Test main function
    public static void main(String[] args) {
        DAOEmployeePayroll daoPayroll = new DAOEmployeePayroll();

        int month = 3;  // March
        int year = 2025;

        // Step 1: Generate Payroll (if missing)
        daoPayroll.createPayrollForMonth(month, year);

        // Step 2: Generate Employee Payroll Based on Attendance
        daoPayroll.generateEmployeePayroll1(month, year);
int payrollID = 1; // Example Payroll ID (this should exist in your database)
int employeeID = 1; // Example Employee ID (this should exist in your database)

boolean success = daoPayroll.updatePayDate(payrollID, employeeID);

if (success) {
    System.out.println("Payment completed for Employee ID " + employeeID);
} else {
    System.out.println("Payment update failed for Employee ID " + employeeID);
}

        // Step 3: Fetch and Display Payroll
        Vector<EmployeePayroll> payrollList = daoPayroll.getPayrollWithAttendance(month, year);
        System.out.println("\n📌 Bảng Lương tháng " + month + "/" + year);
        System.out.printf("%-10s %-20s %-10s %-10s %-10s %-10s\n", 
                          "ID", "Tên Nhân Viên", "Ngày Công", "Lương Cơ Bản", "Tổng Lương", "Ngày Thanh Toán");
        System.out.println("------------------------------------------------------------------");

        if (payrollList.isEmpty()) {
            System.out.println("Không có dữ liệu!");
        } else {
            for (EmployeePayroll payroll : payrollList) {
                System.out.printf("%-10d %-20s %-10d %-10d %-10d %-10s\n",
                    payroll.getEmployee().getEmployeeID(),
                    payroll.getEmployee().getEmployeeName(),
                    payroll.getWorkDays(),
                    payroll.getEmployee().getSalary(),
                    payroll.getEmployee().getSalary() * payroll.getWorkDays(),
                    payroll.getPayDate()
                );
            }
        }
    }
}
