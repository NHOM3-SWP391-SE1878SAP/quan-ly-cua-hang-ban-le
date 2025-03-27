package model;

import entity.Role;
import java.sql.*;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAORole extends DBConnect {

    public int insertRole(Role role) {
        int n = 0;
        String sql = "INSERT INTO Role (RoleName) VALUES (?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, role.getRoleName());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAORole.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public int updateRole(Role role) {
        int n = 0;
        String sql = "UPDATE Role SET RoleName = ? WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, role.getRoleName());
            pre.setInt(2, role.getRoleID());
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAORole.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public int deleteRole(int roleID) {
        int n = 0;
        String sql = "DELETE FROM Role WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, roleID);
            n = pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAORole.class.getName()).log(Level.SEVERE, null, ex);
        }
        return n;
    }

    public Vector<Role> getAllRoles() {
        Vector<Role> roles = new Vector<>();
        String sql = "SELECT * FROM Role";
        try {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Role role = new Role(rs.getInt("ID"), rs.getString("RoleName"));
                roles.add(role);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAORole.class.getName()).log(Level.SEVERE, null, ex);
        }
        return roles;
    }
    
     public Role getRoleById(int roleId) {
        String sql = "SELECT id, RoleName FROM Role WHERE id = ?;";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, roleId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                role.setRoleID(rs.getInt("id"));
                role.setRoleName(rs.getString("RoleName"));
                return role;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi trong getRoleById: " + e.getMessage());
        }

        return null; // Trả về null nếu không tìm thấy role
    }
}
