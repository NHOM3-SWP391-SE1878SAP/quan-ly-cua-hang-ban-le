package model;

import entity.Payment;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Payment
 */
public class DAOPayment extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOPayment.class.getName());
    
    /**
     * Constructor
     */
    public DAOPayment() {
        super();
    }
    
    /**
     * Extract Payment object from ResultSet
     * @param rs ResultSet containing payment data
     * @return Payment object
     * @throws SQLException if a database access error occurs
     */
    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("ID");
        String paymentMethods = rs.getString("PaymentMethods");
        
        return new Payment(id, null, paymentMethods);
    }
    
    /**
     * Get all payment methods from database
     * @return List containing all payment methods
     */
    public List<Payment> getAllPaymentMethods() {
        List<Payment> payments = new ArrayList<>();
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return payments;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Payments";
        
        try {
            pst = conn.prepareStatement(sql);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                Payment payment = extractPaymentFromResultSet(rs);
                payments.add(payment);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving payment methods list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return payments;
    }
    
    /**
     * Get payment method by ID
     * @param paymentId ID of the payment method to retrieve
     * @return Payment object or null if not found
     */
    public Payment getPaymentById(int paymentId) {
        Payment payment = null;
        String sql = "SELECT * FROM Payments WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, paymentId);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                payment = extractPaymentFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving payment method with ID: " + paymentId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return payment;
    }
    
    /**
     * Get payment method by name
     * @param methodName Payment method name to search for
     * @return Payment object or null if not found
     */
    public Payment getPaymentByMethodName(String methodName) {
        Payment payment = null;
        String sql = "SELECT * FROM Payments WHERE PaymentMethods = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, methodName);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                payment = extractPaymentFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving payment method with name: " + methodName, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return payment;
    }
    
    /**
     * Add new payment method to database
     * @param payment Payment object to add
     * @return true if successful, false if failed
     */
    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO Payments (PaymentMethods) VALUES (?)";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, payment.getPaymentMethods());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new payment method: " + payment.getPaymentMethods(), ex);
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
     * Update payment method information
     * @param payment Payment object with updated information
     * @return true if successful, false if failed
     */
    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE Payments SET PaymentMethods = ? WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, payment.getPaymentMethods());
            pst.setInt(2, payment.getPaymentID());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating payment method with ID: " + payment.getPaymentID(), ex);
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
     * Delete payment method from database
     * @param paymentId ID of the payment method to delete
     * @return true if successful, false if failed
     */
    public boolean deletePayment(int paymentId) {
        String sql = "DELETE FROM Payments WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, paymentId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting payment method with ID: " + paymentId, ex);
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
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOPayment daoPayment = new DAOPayment();
        
        // Test getting all payment methods
        List<Payment> payments = daoPayment.getAllPaymentMethods();
        System.out.println("All payment methods:");
        for (Payment p : payments) {
            System.out.println(p.getPaymentID() + ": " + p.getPaymentMethods());
        }
        
        // Test getting payment by ID
        Payment payment = daoPayment.getPaymentById(1);
        if (payment != null) {
            System.out.println("\nPayment method with ID 1: " + payment.getPaymentMethods());
        }
    }
}
