package model;

import entity.ReturnDetails;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for ReturnDetails
 */
public class DAOReturnDetails extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOReturnDetails.class.getName());
    
    /**
     * Constructor
     */
    public DAOReturnDetails() {
        super();
    }
    
    /**
     * Get all return details from database
     * @return List of ReturnDetails objects
     */
    public List<ReturnDetails> getAllReturnDetails() {
        List<ReturnDetails> returnDetailsList = new ArrayList<>();
        String sql = "SELECT * FROM ReturnDetails";

        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return returnDetailsList;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                ReturnDetails returnDetails = extractReturnDetailsFromResultSet(rs);
                returnDetailsList.add(returnDetails);
            }
            
            LOGGER.info("Number of return details retrieved: " + returnDetailsList.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving return details list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return returnDetailsList;
    }
    
    /**
     * Get return details by ID
     * @param id ID of the return details
     * @return ReturnDetails object or null if not found
     */
    public ReturnDetails getReturnDetailsById(int id) {
        ReturnDetails returnDetails = null;
        String sql = "SELECT * FROM ReturnDetails WHERE ID = ?";

        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            
            rs = pst.executeQuery();
            if (rs.next()) {
                returnDetails = extractReturnDetailsFromResultSet(rs);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving return details with ID: " + id, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return returnDetails;
    }
    
    /**
     * Get return details by return ID
     * @param returnId ID of the return
     * @return List of ReturnDetails objects
     */
    public List<ReturnDetails> getReturnDetailsByReturnId(int returnId) {
        List<ReturnDetails> returnDetailsList = new ArrayList<>();
        String sql = "SELECT * FROM ReturnDetails WHERE return_id = ?";

        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return returnDetailsList;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, returnId);
            
            rs = pst.executeQuery();
            while (rs.next()) {
                ReturnDetails returnDetails = extractReturnDetailsFromResultSet(rs);
                returnDetailsList.add(returnDetails);
            }
            
            LOGGER.info("Number of return details retrieved for return ID " + returnId + ": " + returnDetailsList.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving return details for return ID: " + returnId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return returnDetailsList;
    }
    
    /**
     * Add new return details to database
     * @param returnDetails ReturnDetails object to add
     * @return true if successful, false if failed
     */
    public boolean addReturnDetails(ReturnDetails returnDetails) {
        String sql = "INSERT INTO ReturnDetails (return_id, order_details_id, quantity) VALUES (?, ?, ?)";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, returnDetails.getReturnId());
            pst.setInt(2, returnDetails.getOrderDetailsId());
            pst.setInt(3, returnDetails.getQuantity());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new return details", ex);
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
     * Update return details information
     * @param returnDetails ReturnDetails object to update
     * @return true if successful, false if failed
     */
    public boolean updateReturnDetails(ReturnDetails returnDetails) {
        String sql = "UPDATE ReturnDetails SET return_id = ?, order_details_id = ?, quantity = ? WHERE ID = ?";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, returnDetails.getReturnId());
            pst.setInt(2, returnDetails.getOrderDetailsId());
            pst.setInt(3, returnDetails.getQuantity());
            pst.setInt(4, returnDetails.getId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating return details with ID: " + returnDetails.getId(), ex);
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
     * Delete return details from database
     * @param id ID of the return details to delete
     * @return true if successful, false if failed
     */
    public boolean deleteReturnDetails(int id) {
        String sql = "DELETE FROM ReturnDetails WHERE ID = ?";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting return details with ID: " + id, ex);
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
     * Delete all return details for a specific return
     * @param returnId ID of the return
     * @return true if successful, false if failed
     */
    public boolean deleteReturnDetailsByReturnId(int returnId) {
        String sql = "DELETE FROM ReturnDetails WHERE return_id = ?";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, returnId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting return details for return ID: " + returnId, ex);
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
     * Insert multiple return details records
     * @param returnDetailsList List of ReturnDetails objects to insert
     * @return true if all insertions are successful, false if any fails
     */
    public boolean insertReturnDetails(List<ReturnDetails> returnDetailsList) {
        String sql = "INSERT INTO ReturnDetails (return_id, order_details_id, quantity) VALUES (?, ?, ?)";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        boolean success = true;
        
        try {
            // Disable auto-commit for transaction
            conn.setAutoCommit(false);
            pst = conn.prepareStatement(sql);
            
            for (ReturnDetails details : returnDetailsList) {
                pst.setInt(1, details.getReturnId());
                pst.setInt(2, details.getOrderDetailsId());
                pst.setInt(3, details.getQuantity());
                pst.addBatch();
            }
            
            int[] results = pst.executeBatch();
            
            // Check if all insertions were successful
            for (int result : results) {
                if (result <= 0) {
                    success = false;
                    break;
                }
            }
            
            if (success) {
                conn.commit();
                LOGGER.info("Successfully inserted " + returnDetailsList.size() + " return details records");
            } else {
                conn.rollback();
                LOGGER.warning("Failed to insert some return details records, transaction rolled back");
            }
            
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting return details batch", ex);
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                LOGGER.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
            success = false;
        } finally {
            try {
                if (pst != null) pst.close();
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement or resetting auto-commit", ex);
            }
        }
        
        return success;
    }

    /**
     * Helper method to extract ReturnDetails object from ResultSet
     */
    private ReturnDetails extractReturnDetailsFromResultSet(ResultSet rs) throws SQLException {
        int id = rs.getInt("ID");
        int returnId = rs.getInt("return_id");
        int orderDetailsId = rs.getInt("order_details_id");
        int quantity = rs.getInt("quantity");
        
        return new ReturnDetails(id, returnId, orderDetailsId, quantity);
    }

    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOReturnDetails daoReturnDetails = new DAOReturnDetails();
        List<ReturnDetails> returnDetailsList = daoReturnDetails.getAllReturnDetails();
        for (ReturnDetails returnDetails : returnDetailsList) {
            System.out.println(returnDetails);
        }
    }
} 