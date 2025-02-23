package dao;

import database.DatabaseConnection;
import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private DatabaseConnection dbConnection = new DatabaseConnection(); // Tạo kết nối

    public void addCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (CustomerName, Phone, Address, Points) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getCustomerName());
            stmt.setString(2, customer.getPhone());

            // Xử lý Address null
            if (customer.getAddress() == null || customer.getAddress().trim().isEmpty()) {
                stmt.setNull(3, java.sql.Types.NVARCHAR);
            } else {
                stmt.setString(3, customer.getAddress());
            }

            // Xử lý Points null
            if (customer.getPoints() == null) {
                stmt.setNull(4, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(4, customer.getPoints());
            }

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                System.out.println("📌 Lấy khách hàng: " + rs.getString("CustomerName"));
                customers.add(new Customer(
                        rs.getInt("ID"),
                        rs.getString("CustomerName"),
                        rs.getString("Phone"),
                        rs.getString("Address"),
                        rs.getObject("Points") != null ? rs.getInt("Points") : null
                ));
            }

            System.out.println("✅ Tổng số khách hàng lấy được: " + customers.size());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public void deleteCustomer(int id) {
        String sql = "DELETE FROM Customer WHERE ID = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
