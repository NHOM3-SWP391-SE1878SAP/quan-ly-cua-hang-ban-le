package model;

import entity.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Voucher
 */
public class DAOVoucher extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOVoucher.class.getName());
    
    /**
     * Constructor
     */
    public DAOVoucher() {
        super();
    }
    
    /**
     * Extract Voucher object from ResultSet
     * @param rs ResultSet containing voucher data
     * @return Voucher object
     * @throws SQLException if a database access error occurs
     */
    private Voucher extractVoucherFromResultSet(ResultSet rs) throws SQLException {
        return Voucher.builder()
                .id(rs.getInt("ID"))
                .code(rs.getString("Code"))
                .minOrder(rs.getInt("MinOrder"))
                .discountRate(rs.getInt("DiscountRate"))
                .maxValue(rs.getInt("MaxValue"))
                .usage_limit(rs.getInt("Usage_limit"))
                .usage_count(rs.getInt("Usage_count"))
                .status(rs.getBoolean("Status"))
                .startDate(rs.getDate("StartDate"))
                .endDate(rs.getDate("EndDate"))
                .build();
    }
    
    /**
     * Get all vouchers from database
     * @return List containing all vouchers
     */
    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return vouchers;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Vouchers";
        
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                Voucher voucher = extractVoucherFromResultSet(rs);
                vouchers.add(voucher);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving voucher list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return vouchers;
    }
    
    /**
     * Get voucher by ID
     * @param voucherId ID of the voucher to retrieve
     * @return Voucher object or null if not found
     */
    public Voucher getVoucherById(int voucherId) {
        Voucher voucher = null;
        String sql = "SELECT * FROM Vouchers WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, voucherId);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                voucher = extractVoucherFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving voucher with ID: " + voucherId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return voucher;
    }
    
    /**
     * Get voucher by code
     * @param code Code of the voucher to retrieve
     * @return Voucher object or null if not found
     */
    public Voucher getVoucherByCode(String code) {
        Voucher voucher = null;
        String sql = "SELECT * FROM Vouchers WHERE Code = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, code);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                voucher = extractVoucherFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving voucher with code: " + code, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return voucher;
    }
    
    /**
     * Add new voucher to database
     * @param voucher Voucher object to add
     * @return true if successful, false if failed
     */
    public boolean addVoucher(Voucher voucher) {
        String sql = "INSERT INTO Vouchers (Code, MinOrder, DiscountRate, MaxValue, Usage_limit, Usage_count, Status, StartDate, EndDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, voucher.getCode());
            pst.setInt(2, voucher.getMinOrder());
            pst.setInt(3, voucher.getDiscountRate());
            pst.setInt(4, voucher.getMaxValue());
            pst.setInt(5, voucher.getUsage_limit());
            pst.setInt(6, voucher.getUsage_count());
            pst.setBoolean(7, voucher.getStatus());
            pst.setDate(8, new java.sql.Date(voucher.getStartDate().getTime()));
            pst.setDate(9, new java.sql.Date(voucher.getEndDate().getTime()));
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new voucher: " + voucher.getCode(), ex);
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
     * Update voucher information
     * @param voucher Voucher object with updated information
     * @return true if successful, false if failed
     */
    public boolean updateVoucher(Voucher voucher) {
        String sql = "UPDATE Vouchers SET Code = ?, MinOrder = ?, DiscountRate = ?, MaxValue = ?, " +
                     "Usage_limit = ?, Usage_count = ?, Status = ?, StartDate = ?, EndDate = ? WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, voucher.getCode());
            pst.setInt(2, voucher.getMinOrder());
            pst.setInt(3, voucher.getDiscountRate());
            pst.setInt(4, voucher.getMaxValue());
            pst.setInt(5, voucher.getUsage_limit());
            pst.setInt(6, voucher.getUsage_count());
            pst.setBoolean(7, voucher.getStatus());
            pst.setDate(8, new java.sql.Date(voucher.getStartDate().getTime()));
            pst.setDate(9, new java.sql.Date(voucher.getEndDate().getTime()));
            pst.setInt(10, voucher.getId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating voucher with ID: " + voucher.getId(), ex);
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
     * Delete voucher from database
     * @param voucherId ID of the voucher to delete
     * @return true if successful, false if failed
     */
    public boolean deleteVoucher(int voucherId) {
        String sql = "DELETE FROM Vouchers WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, voucherId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting voucher with ID: " + voucherId, ex);
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
     * Get valid vouchers for a given order amount and current date
     * @param orderAmount The total order amount
     * @return List of valid vouchers
     */
    public List<Voucher> getValidVouchers(int orderAmount) {
        List<Voucher> vouchers = new ArrayList<>();
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return vouchers;
        }
        
        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Vouchers WHERE MinOrder <= ? AND StartDate <= GETDATE() AND EndDate >= GETDATE() " +
                     "AND Status = 1 AND (Usage_limit > Usage_count OR Usage_limit = 0)";
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderAmount);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                Voucher voucher = extractVoucherFromResultSet(rs);
                vouchers.add(voucher);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving valid vouchers for order amount: " + orderAmount, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }
        
        return vouchers;
    }
    
    /**
     * Calculate discount amount for a given voucher and order amount
     * @param voucher The voucher to apply
     * @param orderAmount The total order amount
     * @return The discount amount
     */
    public int calculateDiscount(Voucher voucher, int orderAmount) {
        if (voucher == null || orderAmount < voucher.getMinOrder() || !voucher.getStatus() || 
            (voucher.getUsage_limit() > 0 && voucher.getUsage_count() >= voucher.getUsage_limit())) {
            return 0;
        }
        
        int discountAmount = (orderAmount * voucher.getDiscountRate()) / 100;
        
        // Apply max value limit if needed
        if (voucher.getMaxValue() > 0 && discountAmount > voucher.getMaxValue()) {
            discountAmount = voucher.getMaxValue();
        }
        
        return discountAmount;
    }
    
    /**
     * Increment usage count for a voucher
     * @param voucherId ID of the voucher to update
     * @return true if successful, false if failed
     */
    public boolean incrementUsageCount(int voucherId) {
        String sql = "UPDATE Vouchers SET Usage_count = Usage_count + 1 WHERE ID = ?";
        
        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, voucherId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error incrementing usage count for voucher ID: " + voucherId, ex);
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
     * Check if a voucher is valid for use
     * @param code Voucher code
     * @param orderAmount Order amount
     * @return Voucher object if valid, null if invalid
     */
    public Voucher validateVoucher(String code, int orderAmount) {
        Voucher voucher = getVoucherByCode(code);
        
        if (voucher == null) {
            return null; // Voucher not found
        }
        
        // Check if voucher is active and valid
        java.util.Date currentDate = new java.util.Date();
        boolean isValid = voucher.getStatus() && 
                          voucher.getStartDate().before(currentDate) && 
                          voucher.getEndDate().after(currentDate) &&
                          voucher.getMinOrder() <= orderAmount &&
                          (voucher.getUsage_limit() == 0 || voucher.getUsage_count() < voucher.getUsage_limit());
        
        return isValid ? voucher : null;
    }
    
    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOVoucher daoVoucher = new DAOVoucher();
        List<Voucher> vouchers = daoVoucher.getAllVouchers();
        
        for (Voucher v : vouchers) {
            System.out.println(v);
        }
    }
} 