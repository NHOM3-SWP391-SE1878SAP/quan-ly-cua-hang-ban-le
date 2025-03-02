package dao;

import model.Customer;
import database.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private Connection conn;

    
    public CustomerDAO(Connection conn) {
        this.conn = conn;
    }
    
    public CustomerDAO() {
        this.conn = new DatabaseConnection().getConnection();
    }

    // ✅ Lấy tổng số khách hàng để phục vụ phân trang
    public int getTotalCustomerCount() {
        String query = "SELECT COUNT(*) FROM customers";
        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Lấy danh sách khách hàng theo phân trang
    public List<Customer> getCustomersByPage(int page, int recordsPerPage) {
        List<Customer> customers = new ArrayList<>();
        int start = (page - 1) * recordsPerPage;

        String query = "SELECT * FROM customers ORDER BY ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, start);
            stmt.setInt(2, recordsPerPage);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : 0
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // ✅ Lấy danh sách tất cả khách hàng
     public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer ORDER BY ID DESC";

        try {
            if (conn == null) {
                System.err.println("❌ Lỗi: Kết nối database bị null!");
                return customers;
            }

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : 0
                ));
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi truy vấn getAllCustomers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    // ✅ Tìm kiếm khách hàng theo tên hoặc số điện thoại
    public List<Customer> searchCustomers(String keyword) {
        List<Customer> customers = new ArrayList<>();
        String query = "SELECT * FROM customers WHERE CustomerName LIKE ? OR Phone LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : 0
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // ✅ Thêm khách hàng mới
    public void addCustomer(Customer customer) {
        String query = "INSERT INTO customers (CustomerName, Phone, Address, Points) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAddress());
            stmt.setObject(4, customer.getPoints(), Types.INTEGER);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Cập nhật thông tin khách hàng
    public void updateCustomer(Customer customer) {
        String query = "UPDATE customers SET CustomerName = ?, Phone = ?, Address = ?, Points = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getPhone());
            stmt.setString(3, customer.getAddress());
            stmt.setObject(4, customer.getPoints(), Types.INTEGER);
            stmt.setInt(5, customer.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Xóa khách hàng
    public void deleteCustomer(int id) {
        String query = "DELETE FROM customers WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
