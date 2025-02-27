package model;

import entity.Account;
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
                int phone = rs.getInt("Phone");
                String address = rs.getString("Address");
                int roleID = rs.getInt("RoleID"); // Lấy RoleID
                
                Role role = getRoleById(roleID); // Lấy Role từ ID
                
                account = new Account(id, userName, password, email, phone, address, role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return account;
    }

    // Lấy thông tin vai trò theo RoleID
    private Role getRoleById(int roleID) {
        Role role = null;
        String sql = "SELECT * FROM Roles WHERE ID = ?";
        
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
}
