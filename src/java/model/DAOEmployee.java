package model;

import entity.Account;
import entity.Employee;
import entity.EmployeeSalesReport;
import entity.Role;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.mindrot.jbcrypt.BCrypt;

public class DAOEmployee extends DBConnect {

    
    private String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }
public Vector<Employee> getAllEmployees() {
    Vector<Employee> employees = new Vector<>();
    String sql = "SELECT e.*, a.ID AS AccountID, a.UserName, a.Password, a.Email, a.Phone, a.Address " +
                 "FROM Employees e " +
                 "LEFT JOIN Accounts a ON e.AccountsID = a.ID"; 

    try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
        while (rs.next()) {
            // Tạo đối tượng Account nhưng không có Role
            Account account = new Account(
                    rs.getInt("AccountID"),
                    rs.getString("UserName"),
                    rs.getString("Password"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    null // Không cần gán Role
            );

            // Tạo đối tượng Employee và gán Account vào Employee
            Employee emp = new Employee(
                    rs.getInt("ID"),
                    rs.getString("EmployeeName"),
                    rs.getString("Avatar"),
                    rs.getDate("DoB"),
                    rs.getBoolean("Gender"),
                    rs.getInt("Salary"),
                    rs.getString("CCCD"),
                    rs.getBoolean("IsAvailable"),
                    account  // Gán account vào employee
            );
            employees.add(emp);
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
    }
    return employees;
}

public boolean addEmployee(Employee emp) {
        String sqlAccount = "INSERT INTO Accounts (UserName, Password, Email, Phone, Address, RoleID) VALUES (?, ?, ?, ?, ?, ?)";
        String sqlEmployee = "INSERT INTO Employees (EmployeeName, Avatar, DoB, Gender, Salary, CCCD, IsAvailable, AccountsID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn.setAutoCommit(false);

            // Set RoleID = 2 cho tài khoản
            Role role = new Role(2, "Employee");
            emp.getAccount().setRole(role);

            // Thêm tài khoản với mật khẩu đã mã hóa
            int accountID = -1;
            try (PreparedStatement pstmt = conn.prepareStatement(sqlAccount, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, emp.getAccount().getUserName());
                pstmt.setString(2, hashPassword(emp.getAccount().getPassword())); // Mật khẩu đã mã hóa
                pstmt.setString(3, emp.getAccount().getEmail());
                pstmt.setString(4, emp.getAccount().getPhone());
                pstmt.setString(5, emp.getAccount().getAddress());
                pstmt.setInt(6, emp.getAccount().getRole().getRoleID());
                
                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    ResultSet rs = pstmt.getGeneratedKeys();
                    if (rs.next()) {
                        accountID = rs.getInt(1);
                    }
                }
            }

            if (accountID == -1) {
                conn.rollback();
                return false;
            }

            // Thêm nhân viên
            try (PreparedStatement pstmt = conn.prepareStatement(sqlEmployee)) {
                pstmt.setString(1, emp.getEmployeeName());
                pstmt.setString(2, emp.getAvatar());
                pstmt.setDate(3, new java.sql.Date(emp.getDob().getTime()));
                pstmt.setBoolean(4, emp.isGender());
                pstmt.setInt(5, emp.getSalary());
                pstmt.setString(6, emp.getCccd());
                pstmt.setBoolean(7, emp.isIsAvailable());
                pstmt.setInt(8, accountID);
                
                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            }

        } catch (SQLException ex) {
            try {
                conn.rollback();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            ex.printStackTrace();
            return false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

public boolean updateEmployee(Employee emp) {
    String sqlUpdateEmployee = "UPDATE Employees SET EmployeeName=?, Avatar=?, DoB=?, Gender=?, Salary=?, CCCD=?, IsAvailable=? WHERE ID=?";
    String sqlUpdateAccount = "UPDATE Accounts SET UserName=?, Email=?, Phone=?, Address=? WHERE ID=(SELECT AccountsID FROM Employees WHERE ID=?)";

    try {
        conn.setAutoCommit(false);

        // Cập nhật thông tin nhân viên
        try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdateEmployee)) {
            pstmt.setString(1, emp.getEmployeeName());
            pstmt.setString(2, emp.getAvatar());
            pstmt.setDate(3, new java.sql.Date(emp.getDob().getTime()));
            pstmt.setBoolean(4, emp.isGender());
            pstmt.setInt(5, emp.getSalary());
            pstmt.setString(6, emp.getCccd());
            pstmt.setBoolean(7, emp.isIsAvailable());
            pstmt.setInt(8, emp.getEmployeeID());
            pstmt.executeUpdate();
        }

        // Cập nhật tài khoản liên quan
        try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdateAccount)) {
            pstmt.setString(1, emp.getAccount().getUserName());
            pstmt.setString(2, emp.getAccount().getEmail());
            pstmt.setString(3, emp.getAccount().getPhone());
            pstmt.setString(4, emp.getAccount().getAddress());
            pstmt.setInt(5, emp.getEmployeeID());
            pstmt.executeUpdate();
        }

        conn.commit();
        return true;
    } catch (SQLException ex) {
        try {
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        ex.printStackTrace();
        return false;
    } finally {
        try {
            conn.setAutoCommit(true);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
}

public Employee getEmployeeByID(int employeeID) {
    String sql = "SELECT e.*, a.ID AS AccountID, a.UserName, a.Password, a.Email, a.Phone, a.Address " +
                 "FROM Employees e " +
                 "LEFT JOIN Accounts a ON e.AccountsID = a.ID WHERE e.ID = ?";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, employeeID);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            Account account = new Account(
                    rs.getInt("AccountID"),
                    rs.getString("UserName"),
                    rs.getString("Password"),
                    rs.getString("Email"),
                    rs.getString("Phone"),
                    rs.getString("Address"),
                    null // Không cần Role
            );

            return new Employee(
                    rs.getInt("ID"),
                    rs.getString("EmployeeName"),
                    rs.getString("Avatar"),
                    rs.getDate("DoB"),
                    rs.getBoolean("Gender"),
                    rs.getInt("Salary"),
                    rs.getString("CCCD"),
                    rs.getBoolean("IsAvailable"),
                    account
            );
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return null;
}


public boolean deleteEmployee(int employeeID) {
    // Các câu lệnh SQL để xử lý ràng buộc khóa ngoại
    String deletePayrollSQL = "DELETE FROM Employees_Payroll WHERE EmployeesID = ?";
    String deleteWeeklyScheduleSQL = "DELETE FROM WeeklySchedule WHERE EmployeesID = ?";
    String deleteAttendanceSQL = "DELETE FROM Attendance WHERE EmployeesID = ?";
    String deleteReturnsSQL = "DELETE FROM Returns WHERE EmployeesID = ?";
    String updateOrdersSQL = "UPDATE Orders SET EmployeesID = NULL WHERE EmployeesID = ?";
    String deleteEmployeeSQL = "DELETE FROM Employees WHERE ID = ?";
    String getAccountIDSQL = "SELECT AccountsID FROM Employees WHERE ID = ?";
    String deleteAccountSQL = "DELETE FROM Accounts WHERE ID = ?";

    try {
        conn.setAutoCommit(false); // Bắt đầu transaction

        // Xóa dữ liệu liên quan từ các bảng phụ thuộc
        try (PreparedStatement pstmt = conn.prepareStatement(deletePayrollSQL)) {
            pstmt.setInt(1, employeeID);
            pstmt.executeUpdate();
        }

        try (PreparedStatement pstmt = conn.prepareStatement(deleteWeeklyScheduleSQL)) {
            pstmt.setInt(1, employeeID);
            pstmt.executeUpdate();
        }

        try (PreparedStatement pstmt = conn.prepareStatement(deleteAttendanceSQL)) {
            pstmt.setInt(1, employeeID);
            pstmt.executeUpdate();
        }

        try (PreparedStatement pstmt = conn.prepareStatement(deleteReturnsSQL)) {
            pstmt.setInt(1, employeeID);
            pstmt.executeUpdate();
        }

        // Cập nhật Orders để xóa tham chiếu đến nhân viên
        try (PreparedStatement pstmt = conn.prepareStatement(updateOrdersSQL)) {
            pstmt.setInt(1, employeeID);
            pstmt.executeUpdate();
        }

        // Lấy AccountID của nhân viên
        int accountID = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(getAccountIDSQL)) {
            pstmt.setInt(1, employeeID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                accountID = rs.getInt("AccountsID");
            }
        }

        if (accountID == -1) {
            conn.rollback();
            return false;
        }

        // Xóa nhân viên
        try (PreparedStatement pstmt = conn.prepareStatement(deleteEmployeeSQL)) {
            pstmt.setInt(1, employeeID);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected <= 0) {
                conn.rollback();
                return false;
            }
        }

        // Xóa tài khoản
        try (PreparedStatement pstmt = conn.prepareStatement(deleteAccountSQL)) {
            pstmt.setInt(1, accountID);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected <= 0) {
                conn.rollback();
                return false;
            }
        }

        conn.commit(); // Commit transaction nếu mọi thứ thành công
        return true;

    } catch (SQLException ex) {
        try {
            conn.rollback(); // Rollback nếu có lỗi
        } catch (SQLException e) {
            Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, e);
        }
        Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    } finally {
        try {
            conn.setAutoCommit(true); // Khôi phục auto-commit
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
public boolean isEmailExists(String email, int excludeAccountID) {
    String sql = "SELECT COUNT(*) FROM Accounts WHERE Email = ? AND ID != ?";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, email);
        pstmt.setInt(2, excludeAccountID);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return false;
}

public boolean isPhoneExists(String phone, int excludeAccountID) {
    String sql = "SELECT COUNT(*) FROM Accounts WHERE Phone = ? AND ID != ?";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, phone);
        pstmt.setInt(2, excludeAccountID);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return false;
}

public Vector<EmployeeSalesReport> getEmployeeSalesReport(java.util.Date fromDate, java.util.Date toDate) {
    Vector<EmployeeSalesReport> report = new Vector<>();
    String sql = "SELECT e.ID, e.EmployeeName, "
            + "CONVERT(date, o.OrderDate) AS ReportDate, "
            + "COUNT(o.ID) AS OrderCount, "
            + "SUM(o.TotalAmount) AS TotalSales "
            + "FROM Employees e "
            + "LEFT JOIN Orders o ON e.ID = o.EmployeesID "
            + "WHERE o.OrderDate BETWEEN ? AND ? "
            + "GROUP BY e.ID, e.EmployeeName, CONVERT(date, o.OrderDate) "
            + "ORDER BY e.EmployeeName, CONVERT(date, o.OrderDate)";
    
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setDate(1, new java.sql.Date(fromDate.getTime()));
        pstmt.setDate(2, new java.sql.Date(toDate.getTime()));
        
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            EmployeeSalesReport item = new EmployeeSalesReport(
                rs.getInt("ID"),
                rs.getString("EmployeeName"),
                rs.getString("ReportDate"),
                rs.getInt("OrderCount"),
                rs.getInt("TotalSales")
            );
            report.add(item);
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
    }
    return report;
}

}

