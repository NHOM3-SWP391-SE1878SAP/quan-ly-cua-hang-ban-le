package model;

import entity.Account;
import entity.Employee;
import entity.Role;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOEmployee extends DBConnect {

    

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

        // Set RoleID = 2 for the account
        Role role = new Role(2, "Employee");  // Assuming role with ID 2 is called "Employee"
        emp.getAccount().setRole(role);  // Set the role to the Account object

        // Thêm tài khoản trước
        int accountID = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(sqlAccount, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, emp.getAccount().getUserName());
            pstmt.setString(2, emp.getAccount().getPassword());
            pstmt.setString(3, emp.getAccount().getEmail());
            pstmt.setString(4, emp.getAccount().getPhone());
            pstmt.setString(5, emp.getAccount().getAddress());
            pstmt.setInt(6, emp.getAccount().getRole().getRoleID());  // Insert RoleID (2)
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
            pstmt.setBoolean(4, emp.isGender());  // 'emp.isGender()' returns boolean
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
    String deleteEmployeeSQL = "DELETE FROM Employees WHERE ID = ?";
    String getAccountIDSQL = "SELECT AccountsID FROM Employees WHERE ID = ?";
    String deleteAccountSQL = "DELETE FROM Accounts WHERE ID = ?";

    try {
        // Start a transaction
        conn.setAutoCommit(false);

        // Step 1: Get the associated Account ID for the Employee
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
            return false; // If no associated account is found, rollback the transaction
        }

        // Step 2: Delete the Employee
        try (PreparedStatement pstmt = conn.prepareStatement(deleteEmployeeSQL)) {
            pstmt.setInt(1, employeeID);
            int rowsAffectedEmployee = pstmt.executeUpdate();
            if (rowsAffectedEmployee <= 0) {
                conn.rollback();
                return false; // Rollback if the Employee deletion fails
            }
        }

        // Step 3: Delete the associated Account
        try (PreparedStatement pstmt = conn.prepareStatement(deleteAccountSQL)) {
            pstmt.setInt(1, accountID);
            int rowsAffectedAccount = pstmt.executeUpdate();
            if (rowsAffectedAccount <= 0) {
                conn.rollback();
                return false; // Rollback if the Account deletion fails
            }
        }

        // Step 4: Commit the transaction
        conn.commit();
        return true;
    } catch (SQLException ex) {
        try {
            conn.rollback(); // Rollback in case of any exception
        } catch (SQLException e) {
            Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, e);
        }
        Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
        return false;
    } finally {
        try {
            conn.setAutoCommit(true);  // Reset auto-commit to true after the transaction
        } catch (SQLException ex) {
            Logger.getLogger(DAOEmployee.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}



}




