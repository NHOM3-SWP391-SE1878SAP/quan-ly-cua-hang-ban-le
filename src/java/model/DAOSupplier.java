package model;

import entity.Supplier;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOSupplier extends DBConnect {
    
    // Add new supplier
    public int addSupplier(Supplier supplier) {
        String sql = "INSERT INTO Suppliers (SupplierName, Phone, Address, Email) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, supplier.getSupplierName());
            st.setString(2, supplier.getPhone());
            st.setString(3, supplier.getAddress());
            st.setString(4, supplier.getEmail());        
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("addSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Update supplier
    public int updateSupplier(Supplier supplier) {
        String sql = "UPDATE Suppliers SET SupplierName=?, Phone=?, Address=?, Email=? WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, supplier.getSupplierName());
            st.setString(2, supplier.getPhone());
            st.setString(3, supplier.getAddress());
            st.setString(4, supplier.getEmail());
            st.setInt(5, supplier.getId());
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("updateSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Delete supplier
    public int deleteSupplier(int id) {
        String sql = "DELETE FROM Suppliers WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate();
        } catch (SQLException e) {
            System.out.println("deleteSupplier: " + e.getMessage());
        }
        return 0;
    }
    
    // Get all suppliers
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("getAllSuppliers: " + e.getMessage());
        }
        return list;
    }
    
    // Get supplier by ID
    public Supplier getSupplierById(int id) {
        String sql = "SELECT * FROM Suppliers WHERE ID=?";
        try {
            PreparedStatement st = conn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                return s;
            }
        } catch (SQLException e) {
            System.out.println("getSupplierById: " + e.getMessage());
        }
        return null;
    }
    
    // Search suppliers with filters
    public List<Supplier> searchSuppliers(String code, String name, String phone, String group) {
        List<Supplier> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Suppliers WHERE 1=1");
        ArrayList<Object> params = new ArrayList<>();
        
        if (code != null && !code.trim().isEmpty()) {
            sql.append(" AND SupplierCode LIKE ?");
            params.add("%" + code + "%");
        }
        if (name != null && !name.trim().isEmpty()) {
            sql.append(" AND SupplierName LIKE ?");
            params.add("%" + name + "%");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql.append(" AND Phone LIKE ?");
            params.add("%" + phone + "%");
        }
        if (group != null && !group.trim().isEmpty()) {
            sql.append(" AND SupplierGroup = ?");
            params.add(group);
        }
        
        try {
            PreparedStatement st = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = st.executeQuery();
            while(rs.next()) {
                Supplier s = new Supplier();
                s.setId(rs.getInt("ID"));
                s.setSupplierName(rs.getString("SupplierName"));
                s.setPhone(rs.getString("Phone"));
                s.setAddress(rs.getString("Address"));
                s.setEmail(rs.getString("Email"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("searchSuppliers: " + e.getMessage());
        }
        return list;
    }
}