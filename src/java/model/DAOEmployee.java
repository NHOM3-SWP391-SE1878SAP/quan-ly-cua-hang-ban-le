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
                    rs.getInt("Phone"),
                    rs.getString("Address"),
                    null // Không cần gán Role
            );

            // Tạo đối tượng Employee và gán Account vào Employee
            Employee emp = new Employee(
                    rs.getInt("ID"),
                    rs.getString("EmployeeName"),
                    rs.getString("Avatar"),
                    rs.getDate("DoB"),
                    rs.getString("Gender"),
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
    String sqlAccount = "INSERT INTO Accounts (UserName, Password, Email, Phone, Address) VALUES (?, ?, ?, ?, ?)";
    String sqlEmployee = "INSERT INTO Employees (EmployeeName, Avatar, DoB, Gender, Salary, CCCD, IsAvailable, AccountsID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try {
        conn.setAutoCommit(false);

        // Thêm tài khoản trước
        int accountID = -1;
        try (PreparedStatement pstmt = conn.prepareStatement(sqlAccount, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, emp.getAccount().getUserName());
            pstmt.setString(2, emp.getAccount().getPassword());
            pstmt.setString(3, emp.getAccount().getEmail());
            pstmt.setInt(4, emp.getAccount().getPhone());
            pstmt.setString(5, emp.getAccount().getAddress());
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
            pstmt.setString(4, emp.getGender());
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

public boolean updateEmployee(int employeeID, String name, String avatar, Date dob, String gender, int salary, String cccd, boolean isAvailable, String username, String email, int phone, String address) {
    String sqlUpdateEmployee = "UPDATE Employees SET EmployeeName=?, Avatar=?, DoB=?, Gender=?, Salary=?, CCCD=?, IsAvailable=? WHERE ID=?";
    String sqlUpdateAccount = "UPDATE Accounts SET UserName=?, Email=?, Phone=?, Address=? WHERE ID=(SELECT AccountsID FROM Employees WHERE ID=?)";

    try {
        conn.setAutoCommit(false);

        try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdateEmployee)) {
            pstmt.setString(1, name);
            pstmt.setString(2, avatar);
            pstmt.setDate(3, new java.sql.Date(dob.getTime()));
            pstmt.setString(4, gender);
            pstmt.setInt(5, salary);
            pstmt.setString(6, cccd);
            pstmt.setBoolean(7, isAvailable);
            pstmt.setInt(8, employeeID);
            pstmt.executeUpdate();
        }

        try (PreparedStatement pstmt = conn.prepareStatement(sqlUpdateAccount)) {
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setInt(3, phone);
            pstmt.setString(4, address);
            pstmt.setInt(5, employeeID);
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




