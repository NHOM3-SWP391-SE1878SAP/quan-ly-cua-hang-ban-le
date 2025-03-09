package model;

import entity.Order;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Order
 */
public class DAOOrder extends DBConnect {

    private static final Logger LOGGER = Logger.getLogger(DAOOrder.class.getName());

    /**
     * Constructor
     */
    public DAOOrder() {
        super();
    }

    /**
     * Get all orders from database
     *
     * @return List containing all orders
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return orders;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM Orders";

        try {
            pst = conn.prepareStatement(sql);

            rs = pst.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("ID");
                Date orderDate = rs.getDate("OrderDate");
                Integer totalAmount = rs.getInt("TotalAmount");
                Integer customerId = rs.getInt("CustomerID");
                Integer employeeId = rs.getInt("EmployeesID");
                Integer paymentId = rs.getInt("PaymentsID");
                Integer voucherId = rs.getInt("VouchersID");

                Order order = new Order(id, orderDate, totalAmount, customerId, employeeId, paymentId, voucherId);
                orders.add(order);
            }

            LOGGER.info("Number of orders retrieved: " + orders.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order list", ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return orders;
    }
    
    public List<Order> getAllOrder() {
    List<Order> orderList = new ArrayList<>();
    String sql = "SELECT o.ID, o.OrderDate, o.EmployeesID, e.EmployeeName, o.CustomerID, c.CustomerName, o.TotalAmount " +
                 "FROM Orders o " +
                 "LEFT JOIN Employees e ON o.EmployeesID = e.ID " +
                 "LEFT JOIN Customer c ON o.CustomerID = c.ID";

    try (PreparedStatement pst = conn.prepareStatement(sql);
         ResultSet rs = pst.executeQuery()) {

        while (rs.next()) {
            Order order = new Order();
            order.setOrderID(rs.getInt("ID"));
            order.setOrderDate(rs.getDate("OrderDate"));
            order.setEmployeeID(rs.getInt("EmployeesID"));
            order.setEmployeeName(rs.getString("EmployeeName")); // Lấy tên nhân viên từ DB
            order.setCustomerID(rs.getInt("CustomerID"));
            order.setCustomerName(rs.getString("CustomerName")); // Lấy tên khách hàng từ DB
            order.setTotalAmount(rs.getInt("TotalAmount"));
            orderList.add(order);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return orderList;
}


    /**
     * Get order information by ID
     *
     * @param orderId ID of the order to retrieve
     * @return Order object or null if not found
     */
    public Order getOrderById(Integer orderId) {
        Order order = null;
        String sql = "SELECT * FROM Orders WHERE ID = ?";

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);  // Set parameter for PreparedStatement

            rs = pst.executeQuery();
            if (rs.next()) {
                Integer id = rs.getInt("ID");
                Date orderDate = rs.getDate("OrderDate");
                Integer totalAmount = rs.getInt("TotalAmount");
                Integer customerId = rs.getInt("CustomerID");
                Integer employeeId = rs.getInt("EmployeesID");
                Integer paymentId = rs.getInt("PaymentsID");
                Integer voucherId = rs.getInt("VouchersID");

                order = new Order(id, orderDate, totalAmount, customerId, employeeId, paymentId, voucherId);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order with ID: " + orderId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return order;
    }
    
    public Order getOrderByIds(int orderId) {
    String sql = "SELECT o.ID, o.OrderDate, o.EmployeesID, e.EmployeeName, o.CustomerID, c.CustomerName, o.TotalAmount " +
                 "FROM Orders o " +
                 "LEFT JOIN Employees e ON o.EmployeesID = e.ID " +
                 "LEFT JOIN Customer c ON o.CustomerID = c.ID " +
                 "WHERE o.ID = ?";

    try (PreparedStatement pst = conn.prepareStatement(sql)) {
        pst.setInt(1, orderId);
        try (ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("ID"));
                order.setOrderDate(rs.getDate("OrderDate"));
                order.setEmployeeID(rs.getInt("EmployeesID"));
                order.setEmployeeName(rs.getString("EmployeeName"));
                order.setCustomerID(rs.getInt("CustomerID"));
                order.setCustomerName(rs.getString("CustomerName"));
                order.setTotalAmount(rs.getInt("TotalAmount"));
                return order;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return null;
}


    /**
     * Add new order to database
     *
     * @param order Order object to add
     * @return true if successful, false if failed
     */
    public boolean addOrder(Order order) {
        String sql = "INSERT INTO Orders (OrderDate, TotalAmount, CustomerID, EmployeesID, PaymentsID, VouchersID) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);

            // Convert java.util.Date to java.sql.Date
            java.sql.Date sqlDate = new java.sql.Date(order.getOrderDate().getTime());

            pst.setDate(1, sqlDate);
            pst.setInt(2, order.getTotalAmount());
            pst.setInt(3, order.getCustomerID());
            pst.setInt(4, order.getEmployeeID());
            pst.setInt(5, order.getPaymentID());
            pst.setInt(6, order.getVoucherID());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new order", ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }

    /**
     * Update order information
     *
     * @param order Order object to update
     * @return true if successful, false if failed
     */
    public boolean updateOrder(Order order) {
        String sql = "UPDATE Orders SET OrderDate = ?, TotalAmount = ?, CustomerID = ?, "
                + "EmployeesID = ?, PaymentsID = ?, VouchersID = ? WHERE ID = ?";

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);

            // Convert java.util.Date to java.sql.Date
            java.sql.Date sqlDate = new java.sql.Date(order.getOrderDate().getTime());

            pst.setDate(1, sqlDate);
            pst.setInt(2, order.getTotalAmount());
            pst.setInt(3, order.getCustomerID());
            pst.setInt(4, order.getEmployeeID());
            pst.setInt(5, order.getPaymentID());
            pst.setInt(6, order.getVoucherID());
            pst.setInt(7, order.getOrderID());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating order with ID: " + order.getOrderID(), ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }

    /**
     * Delete order from database
     *
     * @param orderId ID of the order to delete
     * @return true if successful, false if failed
     */
    public boolean deleteOrder(Integer orderId) {
        String sql = "DELETE FROM Orders WHERE ID = ?";

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting order with ID: " + orderId, ex);
            return false;
        } finally {
            // Close PreparedStatement
            try {
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", ex);
            }
        }
    }

    /**
     * Get orders by customer ID
     *
     * @param customerId ID of the customer
     * @return List containing orders for the customer
     */
    public List<Order> getOrdersByCustomerId(Integer customerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE CustomerID = ?";

        // Ensure connection is open
        if (conn == null) {  // Directly check conn instead of calling getConnection()
            LOGGER.severe("Error: Cannot connect to database!");
            return orders;
        }
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, customerId);

            rs = pst.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("ID");
                Date orderDate = rs.getDate("OrderDate");
                Integer totalAmount = rs.getInt("TotalAmount");
                Integer employeeId = rs.getInt("EmployeesID");
                Integer paymentId = rs.getInt("PaymentsID");
                Integer voucherId = rs.getInt("VouchersID");

                Order order = new Order(id, orderDate, totalAmount, customerId, employeeId, paymentId, voucherId);
                orders.add(order);
            }

            LOGGER.info("Number of orders retrieved for customer ID " + customerId + ": " + orders.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving orders for customer ID: " + customerId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pst != null) {
                    pst.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return orders;
    }

    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOOrder daoOrder = new DAOOrder();
        List<Order> orders = daoOrder.getAllOrders();
        for (Order order : orders) {
            System.out.println(order);
        }
    }
}
