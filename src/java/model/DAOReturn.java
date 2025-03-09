package model;

import entity.Return;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Return
 */
public class DAOReturn extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOReturn.class.getName());
    
    /**
     * Constructor
     */
    public DAOReturn() {
        super();
    }

    /**
     * Get all returns from database
     * @return List containing all returns
     */
    public List<Return> getAllReturns() {
        List<Return> returns = new ArrayList<>();
        
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return returns;
        }

        String sql = "SELECT * FROM Returns";
        
        try (PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Return returnObj = extractReturnFromResultSet(rs);
                returns.add(returnObj);
            }

            LOGGER.info("Number of returns retrieved: " + returns.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving return list", ex);
        }

        return returns;
    }

    /**
     * Get return by ID
     * @param returnId ID of the return to retrieve
     * @return Return object or null if not found
     */
    public Return getReturnById(int returnId) {
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        String sql = "SELECT * FROM Returns WHERE ID = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, returnId);
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return extractReturnFromResultSet(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving return with ID: " + returnId, ex);
        }

        return null;
    }

    /**
     * Insert new return and get generated ID
     */
    public int insertReturn(Return returnObj) {
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return -1;
        }

        String sql = "INSERT INTO Returns (OrdersID, EmployeesID, ReturnDate, Quantity, Reason, RefundAmount) "
                  + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            // Thứ tự các tham số theo đúng cấu trúc bảng
            pst.setInt(1, returnObj.getOrderId());
            pst.setInt(2, returnObj.getEmployeeId());
            pst.setDate(3, new java.sql.Date(returnObj.getReturnDate().getTime()));
            pst.setInt(4, returnObj.getQuantity());
            pst.setString(5, returnObj.getReason());
            pst.setFloat(6, returnObj.getRefundAmount());
            
            int affectedRows = pst.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error inserting new return", ex);
        }
        
        return -1;
    }

    /**
     * Update return information
     */
    public boolean updateReturn(Return returnObj) {
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        String sql = "UPDATE Returns SET OrdersID = ?, EmployeesID = ?, ReturnDate = ?, "
                  + "Quantity = ?, Reason = ?, RefundAmount = ? WHERE ID = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            // Thứ tự các tham số theo đúng cấu trúc bảng
            pst.setInt(1, returnObj.getOrderId());
            pst.setInt(2, returnObj.getEmployeeId());
            pst.setDate(3, new java.sql.Date(returnObj.getReturnDate().getTime()));
            pst.setInt(4, returnObj.getQuantity());
            pst.setString(5, returnObj.getReason());
            pst.setFloat(6, returnObj.getRefundAmount());
            pst.setInt(7, returnObj.getReturnID());
            
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating return with ID: " + returnObj.getReturnID(), ex);
            return false;
        }
    }

    /**
     * Delete return from database
     * @param returnId ID of the return to delete
     * @return true if successful, false if failed
     */
    public boolean deleteReturn(int returnId) {
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        String sql = "DELETE FROM Returns WHERE ID = ?";
        
        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, returnId);
            return pst.executeUpdate() > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting return with ID: " + returnId, ex);
            return false;
        }
    }

    /**
     * Helper method to extract Return object from ResultSet
     */
    private Return extractReturnFromResultSet(ResultSet rs) throws SQLException {
        Return returnObj = new Return();
        returnObj.setReturnID(rs.getInt("ID"));
        returnObj.setOrderId(rs.getInt("OrdersID"));
        returnObj.setEmployeeId(rs.getInt("EmployeesID"));
        returnObj.setReturnDate(rs.getDate("ReturnDate"));
        returnObj.setQuantity(rs.getInt("Quantity"));
        returnObj.setReason(rs.getString("Reason"));
        returnObj.setRefundAmount(rs.getFloat("RefundAmount"));
        return returnObj;
    }

    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOReturn daoReturn = new DAOReturn();
        List<Return> returns = daoReturn.getAllReturns();
        for (Return returnObj : returns) {
            System.out.println(returnObj);
        }
    }
} 