package dao;

import database.DatabaseConnection;
import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private DatabaseConnection dbConnection = new DatabaseConnection();

    // ✅ Lấy toàn bộ danh sách khách hàng
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer ORDER BY ID DESC"; // Sắp xếp theo ID mới nhất
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // ✅ Tìm khách hàng theo ID
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customer WHERE ID=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Tìm kiếm khách hàng theo tên hoặc số điện thoại
    public List<Customer> searchCustomers(String keyword) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE CustomerName LIKE ? OR Phone LIKE ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // ✅ Thêm khách hàng mới
    public void addCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (CustomerName, Phone, Address, Points) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAddress());
            stmt.setObject(4, customer.getPoints());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật thông tin khách hàng
    public void updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET CustomerName=?, Phone=?, Address=?, Points=? WHERE ID=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAddress());
            stmt.setObject(4, customer.getPoints());
            stmt.setInt(5, customer.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Xóa khách hàng theo ID
    public void deleteCustomer(int id) {
        String sql = "DELETE FROM Customer WHERE ID=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
