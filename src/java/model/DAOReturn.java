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
import java.sql.Connection;

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
        
        if (getConnection() == null) {
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
        if (getConnection() == null) {
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
        if (getConnection() == null) {
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
        if (getConnection() == null) {
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
        if (getConnection() == null) {
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

    public List<Return> getReturnsForReport(Date fromDate, Date toDate, String orderIdSearch, String customerSearch, String employeeSearch) {
        List<Return> returns = new ArrayList<>();
        
        // Kiểm tra kết nối
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return returns;
        }

        String sql = "SELECT r.* FROM Returns r " +
                     "LEFT JOIN Orders o ON r.OrdersID = o.ID " +
                     "LEFT JOIN Customer c ON o.CustomerID = c.ID " +
                     "LEFT JOIN Employees e ON r.EmployeesID = e.ID " +
                     "WHERE 1=1 ";

        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm theo ngày
        if (fromDate != null) {
            sql += "AND r.ReturnDate >= ? ";
            params.add(fromDate);
        }
        if (toDate != null) {
            sql += "AND r.ReturnDate <= ? ";
            params.add(toDate);
        }

        // Thêm điều kiện tìm kiếm theo ID đơn hàng
        if (orderIdSearch != null && !orderIdSearch.isEmpty()) {
            sql += "AND r.OrdersID = ? ";
            params.add(Integer.parseInt(orderIdSearch));
        }

        // Thêm điều kiện tìm kiếm theo tên khách hàng
        if (customerSearch != null && !customerSearch.isEmpty()) {
            sql += "AND c.CustomerName LIKE ? ";
            params.add("%" + customerSearch + "%");
        }

        // Thêm điều kiện tìm kiếm theo tên nhân viên
        if (employeeSearch != null && !employeeSearch.isEmpty()) {
            sql += "AND e.EmployeeName LIKE ? ";
            params.add("%" + employeeSearch + "%");
        }

        sql += "ORDER BY r.ReturnDate DESC";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            // Set các tham số cho câu query
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Date) {
                    ps.setDate(i + 1, new java.sql.Date(((Date) param).getTime()));
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else {
                    ps.setString(i + 1, param.toString());
                }
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Return returnItem = new Return();
                returnItem.setReturnID(rs.getInt("ID"));
                returnItem.setReturnDate(rs.getDate("ReturnDate"));
                returnItem.setOrderId(rs.getInt("OrdersID"));
                returnItem.setEmployeeId(rs.getInt("EmployeesID"));
                returnItem.setRefundAmount(rs.getFloat("RefundAmount"));
                returns.add(returnItem);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting returns for report", ex);
        }

        return returns;
    }

} 