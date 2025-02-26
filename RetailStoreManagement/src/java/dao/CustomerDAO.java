package dao;

import database.DatabaseConnection;
import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    private DatabaseConnection dbConnection = new DatabaseConnection();

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer ORDER BY ID DESC";
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (conn == null) {
                System.err.println("Database connection is null!");
                return customers;
            }
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
            System.err.println("Error fetching customers: " + e.getMessage());
            e.printStackTrace();
        }
        return customers;
    }

    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM Customer WHERE ID=?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (conn == null) {
                System.err.println("Database connection is null!");
                return null;
            }
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
            System.err.println("Error fetching customer by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Customer> searchCustomers(String keyword) {
    List<Customer> customers = new ArrayList<>();
    String sql = "SELECT * FROM Customer WHERE CustomerName LIKE ? OR Phone LIKE ?";
    try (Connection conn = dbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        if (conn == null) {
            System.err.println("Database connection is null!");
            return customers;
        }
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
        System.err.println("Error searching customers: " + e.getMessage());
        e.printStackTrace();
    }
    return customers;
}


   public boolean addCustomer(Customer customer) {
    String sql = "INSERT INTO Customer (CustomerName, Phone, Address, Points) VALUES (?, ?, ?, ?)";
    try (Connection conn = dbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        if (conn == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        stmt.setString(1, customer.getCustomerName());
        stmt.setString(2, customer.getPhone());
        stmt.setString(3, customer.getAddress());
        stmt.setObject(4, customer.getPoints(), Types.INTEGER);

        int rowsAffected = stmt.executeUpdate(); // Thực hiện thêm khách hàng
        if (rowsAffected > 0) {
            System.out.println("✅ Customer added: " + customer.getCustomerName());
            return true;  // Thành công
        } else {
            System.err.println("⚠️ Failed to add customer: No rows affected");
            return false; // Thất bại
        }
    } catch (SQLException e) {
        System.err.println("Error adding customer: " + e.getMessage());
        e.printStackTrace();
        return false; // Trả về false nếu có lỗi
    }
}


    public void updateCustomer(Customer customer) {
    System.out.println("🟡 DAO: Executing update for ID: " + customer.getId());

    String sql = "UPDATE Customer SET CustomerName=?, Phone=?, Address=?, Points=? WHERE ID=?";
    try (Connection conn = dbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        if (conn == null) {
            System.err.println("🔴 Database connection is null!");
            return;
        }

        stmt.setString(1, customer.getCustomerName());
        stmt.setString(2, customer.getPhone());
        stmt.setString(3, customer.getAddress());
        stmt.setObject(4, customer.getPoints(), Types.INTEGER);
        stmt.setInt(5, customer.getId());
        
        System.out.println("🟢 DAO: Executing SQL: " + stmt);
        int rowsAffected = stmt.executeUpdate();
        System.out.println("🟣 Rows affected: " + rowsAffected);

        if (rowsAffected == 0) {
            System.err.println("❌ No customer updated. Check if the ID exists.");
        } else {
            System.out.println("✅ Customer updated successfully.");
        }
    } catch (SQLException e) {
        System.err.println("🔴 Error updating customer: " + e.getMessage());
        e.printStackTrace();
    }
}



    public boolean deleteCustomer(int id) {
    String sql = "DELETE FROM Customer WHERE ID=?";
    try (Connection conn = dbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        if (conn == null) {
            System.err.println("Database connection is null!");
            return false;
        }
        stmt.setInt(1, id);

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            System.out.println("✅ Customer deleted: " + id);
            return true;
        } else {
            System.err.println("⚠️ Failed to delete customer: No rows affected for ID " + id);
            return false;
        }
    } catch (SQLException e) {
        System.err.println("Error deleting customer: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

}