package model;

import entity.Order;
import entity.Order1;
import entity.OrderDetail;
import entity.OrderDetail1;
import entity.Product;
import entity.ReportOrderProduct;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for OrderDetail
 */
public class DAOOrderDetails extends DBConnect {

    private static final Logger LOGGER = Logger.getLogger(DAOOrderDetails.class.getName());

    /**
     * Constructor
     */
    public DAOOrderDetails() {
        super();
    }

    /**
     * Get all order details from database
     *
     * @return List containing all order details
     */
    public List<OrderDetail> getAllOrderDetails() {
        List<OrderDetail> orderDetails = new ArrayList<>();

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return orderDetails;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        String sql = "SELECT * FROM OrderDetails";

        try {
            pst = conn.prepareStatement(sql);

            rs = pst.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("ID");
                Integer quantity = rs.getInt("Quantity");
                Integer price = rs.getInt("Price");
                Integer orderId = rs.getInt("OrdersID");
                Integer productId = rs.getInt("ProductsID");

                OrderDetail orderDetail = OrderDetail.builder()
                        .orderDetailID(id)
                        .quantity(quantity)
                        .price(price)
                        .orderID(orderId)
                        .productID(productId)
                        .build();

                orderDetails.add(orderDetail);
            }

            LOGGER.info("Number of order details retrieved: " + orderDetails.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order detail list", ex);
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

        return orderDetails;
    }

    /**
     * Get order detail information by ID
     *
     * @param orderDetailId ID of the order detail to retrieve
     * @return OrderDetail object or null if not found
     */
    public OrderDetail getOrderDetailById(Integer orderDetailId) {
        OrderDetail orderDetail = null;
        String sql = "SELECT * FROM OrderDetails WHERE ID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderDetailId);  // Set parameter for PreparedStatement

            rs = pst.executeQuery();
            if (rs.next()) {
                Integer id = rs.getInt("ID");
                Integer quantity = rs.getInt("Quantity");
                Integer price = rs.getInt("Price");
                Integer orderId = rs.getInt("OrdersID");
                Integer productId = rs.getInt("ProductsID");

                orderDetail = OrderDetail.builder()
                        .orderDetailID(id)
                        .quantity(quantity)
                        .price(price)
                        .orderID(orderId)
                        .productID(productId)
                        .build();
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order detail with ID: " + orderDetailId, ex);
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

        return orderDetail;
    }

    /**
     * Add new order detail to database
     *
     * @param orderDetail OrderDetail object to add
     * @return true if successful, false if failed
     */
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO OrderDetails (Quantity, Price, OrdersID, ProductsID) "
                + "VALUES (?, ?, ?, ?)";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);

            pst.setInt(1, orderDetail.getQuantity());
            pst.setInt(2, orderDetail.getPrice());
            pst.setInt(3, orderDetail.getOrderID());
            pst.setInt(4, orderDetail.getProductID());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new order detail", ex);
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
     * Update order detail information
     *
     * @param orderDetail OrderDetail object to update
     * @return true if successful, false if failed
     */
    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "UPDATE OrderDetails SET Quantity = ?, Price = ?, OrdersID = ?, "
                + "ProductsID = ? WHERE ID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);

            pst.setInt(1, orderDetail.getQuantity());
            pst.setInt(2, orderDetail.getPrice());
            pst.setInt(3, orderDetail.getOrderID());
            pst.setInt(4, orderDetail.getProductID());
            pst.setInt(5, orderDetail.getOrderDetailID());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating order detail with ID: " + orderDetail.getOrderDetailID(), ex);
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
     * Delete order detail from database
     *
     * @param orderDetailId ID of the order detail to delete
     * @return true if successful, false if failed
     */
    public boolean deleteOrderDetail(Integer orderDetailId) {
        String sql = "DELETE FROM OrderDetails WHERE ID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }

        PreparedStatement pst = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderDetailId);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting order detail with ID: " + orderDetailId, ex);
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
     * Get order details by order ID
     *
     * @param orderId ID of the order
     * @return List containing order details for the order
     */
    public List<OrderDetail> getOrderDetailsByOrderId(Integer orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE OrdersID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return orderDetails;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);

            rs = pst.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("ID");
                Integer quantity = rs.getInt("Quantity");
                Integer price = rs.getInt("Price");
                Integer productId = rs.getInt("ProductsID");

                OrderDetail orderDetail = OrderDetail.builder()
                        .orderDetailID(id)
                        .quantity(quantity)
                        .price(price)
                        .orderID(orderId)
                        .productID(productId)
                        .build();

                orderDetails.add(orderDetail);
            }

            LOGGER.info("Number of order details retrieved for order ID " + orderId + ": " + orderDetails.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order details for order ID: " + orderId, ex);
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

        return orderDetails;
    }

    /**
     * Get order details by product ID
     *
     * @param productId ID of the product
     * @return List containing order details for the product
     */
    public List<OrderDetail> getOrderDetailsByProductId(Integer productId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT * FROM OrderDetails WHERE ProductsID = ?";

        // Ensure connection is open
        if (getConnection() == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return orderDetails;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, productId);

            rs = pst.executeQuery();

            while (rs.next()) {
                Integer id = rs.getInt("ID");
                Integer quantity = rs.getInt("Quantity");
                Integer price = rs.getInt("Price");
                Integer orderId = rs.getInt("OrdersID");

                OrderDetail orderDetail = OrderDetail.builder()
                        .orderDetailID(id)
                        .quantity(quantity)
                        .price(price)
                        .orderID(orderId)
                        .productID(productId)
                        .build();

                orderDetails.add(orderDetail);
            }

            LOGGER.info("Number of order details retrieved for product ID " + productId + ": " + orderDetails.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving order details for product ID: " + productId, ex);
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

        return orderDetails;
    }

    public Vector<OrderDetail1> getTop5ProductsByRevenue1(Date startDate, Date endDate) {
        Vector<OrderDetail1> report = new Vector<>(); // Danh sách lưu sản phẩm
        String sql = "SELECT Top 5 CONVERT(date, o.OrderDate) AS ReportDate, od.ProductsID,\n"
                + "   SUM(od.Quantity) AS SoldQuantity, SUM(od.Quantity * od.Price) AS TotalRevenue\n"
                + "   FROM OrderDetails od\n"
                + "   JOIN Orders o ON od.OrdersID = o.ID\n"
                + "   WHERE o.OrderDate BETWEEN ? AND ?\n"
                + "   GROUP BY o.OrderDate, CONVERT(date, o.OrderDate), od.ProductsID\n"
                + "   ORDER BY TotalRevenue DESC";

        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            // Set tham số ngày
            pre.setDate(1, new java.sql.Date(startDate.getTime()));  // Ngày bắt đầu
            pre.setDate(2, new java.sql.Date(endDate.getTime()));    // Ngày kết thúc

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("ProductsID");
                    int soldQuantity = rs.getInt("SoldQuantity");
                    int totalRevenue = rs.getInt("TotalRevenue");
                    Date orderDate = rs.getDate("ReportDate");

                    // Tạo OrderDetail1 và gán giá trị
                    OrderDetail1 orderDetail = new OrderDetail1();
                    orderDetail.setQuantity(soldQuantity);
                    orderDetail.setPrice(totalRevenue);

                    // Tạo đối tượng Order1 và gán OrderDate
                    Order1 order = new Order1();
                    order.setOrderDate(orderDate);
                    orderDetail.setOrder(order);

                    // Tạo đối tượng Product và gán ProductID
                    Product product = new Product();
                    product.setId(productId); // Nếu cần thêm các thông tin khác, bạn có thể thực hiện thêm truy vấn lấy chi tiết sản phẩm
                    orderDetail.setProduct(product);

                    // Thêm OrderDetail vào danh sách
                    report.add(orderDetail);
                }
            } catch (SQLException ex) {
                Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Error retrieving order details", ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Error preparing the SQL statement", ex);
        }

        return report;
    }

    public Vector<ReportOrderProduct> getTop5ProductsByRevenue(java.util.Date fromDate, java.util.Date toDate) {
    Vector<ReportOrderProduct> report = new Vector<>();
    String sql = "SELECT TOP 5 FORMAT(o.OrderDate, 'yyyy-MM') AS ReportDate, od.ProductsID, p.ProductName, "
                + "SUM(od.Quantity) AS SoldQuantity, SUM(od.Quantity * od.Price) AS TotalRevenue "
                + "FROM OrderDetails od "
                + "JOIN Orders o ON od.OrdersID = o.ID "
                + "JOIN Products p ON od.ProductsID = p.ID "
                + "WHERE o.OrderDate BETWEEN ? AND ? "
                + "GROUP BY od.ProductsID, p.ProductName, FORMAT(o.OrderDate, 'yyyy-MM') "
                + "ORDER BY TotalRevenue DESC";

    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setDate(1, new java.sql.Date(fromDate.getTime()));
        pstmt.setDate(2, new java.sql.Date(toDate.getTime()));

        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            ReportOrderProduct item = new ReportOrderProduct(
                    rs.getInt("ProductsID"),
                    rs.getString("ReportDate"),
                    rs.getInt("TotalRevenue"),
                    rs.getInt("SoldQuantity"),
                    rs.getString("ProductName")
            );
            report.add(item);
        }
    } catch (SQLException ex) {
        Logger.getLogger(DAOOrderDetails.class.getName()).log(Level.SEVERE, null, ex);
    }
    return report;
}


    /**
     * Main method to test the DAO
     */
    public static void main(String[] args) {
        DAOOrderDetails daoOrderDetails = new DAOOrderDetails();
        List<OrderDetail> orderDetails = daoOrderDetails.getAllOrderDetails();
        for (OrderDetail orderDetail : orderDetails) {
            System.out.println(orderDetail);
        }
    }

    public void createOrderDetail(OrderDetail detail) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'createOrderDetail'");
    }

    public Vector<Product> getProductsStockTakes() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
