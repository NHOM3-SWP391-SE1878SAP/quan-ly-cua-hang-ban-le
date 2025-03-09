package model;

import entity.Account;
import entity.Employee;
import entity.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;

public class DAOAccount extends DBConnect {

    // Kiểm tra thông tin đăng nhập
    public Account checkLogin(String userName, String password) {
    Account account = null;
    String sql = "SELECT * FROM Accounts WHERE UserName = ? AND Password = ?";
    
    try {
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, userName);
        stmt.setString(2, password);
        
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            int id = rs.getInt("ID");
            String email = rs.getString("Email");
            String phone = rs.getString("Phone");
            String address = rs.getString("Adress");
            int roleID = rs.getInt("RoleID");

            Role role = getRoleById(roleID);
            if (role == null) {
                System.out.println("Lỗi: Không tìm thấy Role với ID " + roleID);
                return null;
            }

            // Tạo đối tượng Account
            account = new Account(id, userName, password, email, phone, address, role);

            // Nếu tài khoản là Employee, lấy thông tin Employee
            if (role.getRoleName().equalsIgnoreCase("Employee")) {
                Employee employee = getEmployeeByAccountID(id);
                if (employee != null) {
                    employee.setAccount(account);  // Gán tài khoản vào Employee
                    account = employee.getAccount(); // Trả về account đã có Employee
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return account;
}

    // Lấy thông tin vai trò theo RoleID
    private Role getRoleById(int roleID) {
        Role role = null;
        String sql = "SELECT * FROM Role WHERE ID = ?";
        
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, roleID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                role = new Role(roleID, rs.getString("RoleName")); // Lấy RoleName từ database
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return role;
    }
    
    
// Phương thức lấy thông tin Employee từ AccountID
public Employee getEmployeeByAccountID(int accountID) {
    Employee employee = null;
    String sql = "SELECT * FROM Employees WHERE AccountsID = ?";
    
    try {
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, accountID);
        
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            employee = new Employee(
                    rs.getInt("ID"),
                    rs.getString("EmployeeName"),
                    rs.getString("Avatar"),
                    rs.getDate("DoB"),
                    rs.getBoolean("Gender"),
                    rs.getInt("Salary"),
                    rs.getString("CCCD"),
                    rs.getBoolean("IsAvailable"),
                    new Account(accountID, "", "", "", "", "", null) // Chỉ cần Account ID
            );
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    
    return employee;
}



    public static void main(String[] args) {
    DAOAccount dao = new DAOAccount();
    
    String testUserName = "thang";
    String testPassword = "4";
    
    Account account = dao.checkLogin(testUserName, testPassword);
    
    if (account != null) {
        System.out.println("Đăng nhập thành công!");
        System.out.println("ID: " + account.getId());
        System.out.println("UserName: " + account.getUserName());
        System.out.println("Email: " + account.getEmail());
        System.out.println("Phone: " + account.getPhone());
        System.out.println("Address: " + account.getAddress());
        System.out.println("Role: " + account.getRole().getRoleName());

        // Nếu tài khoản thuộc Role Employee, hiển thị thông tin Employee
        if (account.getRole().getRoleName().equals("Employee")) {
            Employee emp = dao.getEmployeeByAccountID(account.getId());
            if (emp != null) {
                System.out.println("Employee Name: " + emp.getEmployeeName());
                System.out.println("Salary: " + emp.getSalary());
                System.out.println("CCCD: " + emp.getCccd());
            }
        }
    } else {
        System.out.println("Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin!");
    }
}

}
