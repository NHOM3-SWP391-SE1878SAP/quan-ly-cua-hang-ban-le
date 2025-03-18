package model;

import entity.Customer;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Customer
 */
public class DAOCustomer extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOCustomer.class.getName());
    
    /**
     * Constructor
     */
    public DAOCustomer() {
        super();
    }

    /**
     * Extract Customer object from ResultSet
     * @param rs ResultSet containing customer data
     * @return Customer object
     * @throws SQLException if a database access error occurs
     */
    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("ID");
        String customerName = rs.getString("CustomerName");
        String phone = rs.getString("Phone");
        String address = rs.getString("Address");
        int points = rs.getInt("Points");
        
        return new Customer(id, customerName, phone, address, points);
    }

    /**
     * Get all customers from database
     * @return List containing all customers
     */
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return customers;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Customer";
        
        try {
            pst = conn.prepareStatement(sql);
            
            rs = pst.executeQuery();

            while (rs.next()) {
                Customer customer = extractCustomerFromResultSet(rs);
                customers.add(customer);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving customer list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return customers;
    }

    /**
     * Get customer information by ID
     * @param customerId ID of the customer to retrieve
     * @return Customer object or null if not found
     */
    public Customer getCustomerById(Integer customerId) {
        Customer customer = null;
        String sql = "SELECT * FROM Customer WHERE ID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setObject(1, customerId);  // Set parameter for PreparedStatement
            
            rs = pst.executeQuery();
            if (rs.next()) {
                customer = extractCustomerFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving customer with ID: " + customerId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return customer;
    }
    
    /**
     * Add new customer to database
     * @param customer Customer object to add
     * @return true if successful, false if failed
     */
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO Customer (CustomerName, Phone, Address, Points) VALUES (?, ?, ?, ?)";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            
            pst.setString(1, customer.getCustomerName());
            pst.setString(2, customer.getPhone());
            pst.setString(3, customer.getAddress());
            pst.setInt(4, customer.getPoints());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new customer", ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }
    
    /**
     * Update customer information
     * @param customer Customer object to update
     * @return true if successful, false if failed
     */
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE Customer SET CustomerName = ?, Phone = ?, Address = ?, Points = ? WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            
            pst.setString(1, customer.getCustomerName());
            pst.setString(2, customer.getPhone());
            pst.setString(3, customer.getAddress());
            pst.setInt(4, customer.getPoints());
            pst.setInt(5, customer.getId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating customer with ID: " + customer.getId(), ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }
    
    /**
     * Delete customer from database
     * @param customerId ID of the customer to delete
     * @return true if successful, false if failed
     */
    public boolean deleteCustomer(int customerId) {
        String sql = "DELETE FROM Customer WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, customerId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting customer with ID: " + customerId, ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }
    
    /**
     * Search customers by name
     * @param name Name to search for
     * @return List of customers matching the search criteria
     */
    public List<Customer> searchCustomersByName(String name) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT TOP 10 * FROM Customer WHERE CustomerName LIKE ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setString(1, "%" + name + "%");
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setId(rs.getInt("ID")); // Sử dụng tên cột trong DB
                    customer.setCustomerName(rs.getString("CustomerName"));
                    customer.setPhone(rs.getString("Phone"));
                    customer.setAddress(rs.getString("Address"));
                    customer.setPoints(rs.getInt("Points"));
                    customers.add(customer);
                    
                    // Debug log
                    // System.out.println("Found customer: " + customer.getCustomerName());
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching customers by name: " + name, ex);
        }
        
        return customers;
    }
    
    /**
     * Search customers by phone number
     * @param phone Phone number to search for
     * @return List of customers matching the search criteria
     */
    public List<Customer> searchCustomersByPhone(int phone) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customer WHERE Phone = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return customers;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, phone);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                Customer customer = extractCustomerFromResultSet(rs);
                customers.add(customer);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error searching customers by phone: " + phone, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return customers;
    }
    public String getCustomerName(int customerID) {
    // Truy vấn để lấy tên khách hàng từ cơ sở dữ liệu
    String sql = "SELECT CustomerName FROM Customer WHERE ID = ?";
    String customerName = null;

    // Đảm bảo kết nối đã được mở
    if (getConnection() == null) {
        LOGGER.severe("Error: Cannot connect to database!");
        return "Khách hàng không xác định"; // Trả về tên mặc định nếu không có kết nối
    }

    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Thực hiện truy vấn
        pst = conn.prepareStatement(sql);
        pst.setInt(1, customerID); // Gắn giá trị customerID vào câu truy vấn
        
        rs = pst.executeQuery();
        
        // Nếu tìm thấy khách hàng, lấy tên
        if (rs.next()) {
            customerName = rs.getString("CustomerName");
        }
    } catch (SQLException ex) {
        LOGGER.log(Level.SEVERE, "Error retrieving customer name for ID: " + customerID, ex);
    } finally {
        // Đóng ResultSet và PreparedStatement
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
        }
    }

    // Nếu không tìm thấy tên khách hàng, trả về tên mặc định
    return customerName != null ? customerName : "Khách hàng #" + customerID;
}


    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOCustomer daoCustomer = new DAOCustomer();
        List<Customer> customers = daoCustomer.getAllCustomers();
        for (Customer customer : customers) {
            System.out.println(customer);
        }
    }
} 