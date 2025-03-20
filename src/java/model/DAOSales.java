package model;

import entity.Customer;
import entity.Employee;
import entity.Order1;
import entity.OrderDetail1;
import entity.Payment;
import entity.Product;
import entity.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAOSales extends DBConnect{
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    // Lấy tất cả đơn hàng trong ngày
    public List<Order1> getOrdersByDate(Date date) {
        List<Order1> orders = new ArrayList<>();
        String sql = "SELECT o.ID AS orderID, o.OrderDate, o.TotalAmount, " +
                     "c.ID AS customerID, c.CustomerName, c.Phone, " +
                     "e.ID AS employeeID, e.EmployeeName, " +
                     "p.ID AS paymentID, p.PaymentMethods, " +
                     "v.ID AS voucherID, v.Code AS voucherCode, v.DiscountRate AS discountAmount " +
                     "FROM [Orders] o " +
                     "LEFT JOIN Customer c ON o.CustomerID = c.ID " +
                     "LEFT JOIN Employees e ON o.EmployeesID = e.ID " +
                     "LEFT JOIN Payments p ON o.PaymentsID = p.ID " +
                     "LEFT JOIN Vouchers v ON o.VouchersID = v.ID " +
                     "WHERE CONVERT(date, o.OrderDate) = CONVERT(date, ?)";
        try {
            ps = conn.prepareStatement(sql);
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            ps.setDate(1, sqlDate);
            rs = ps.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer(
                    rs.getInt("customerID"),
                    rs.getString("CustomerName"),
                    rs.getString("Phone")
                );
                
                Employee employee = new Employee(
                    rs.getInt("employeeID"),
                    rs.getString("EmployeeName")
                );
                
                Payment payment = new Payment(
                    rs.getInt("paymentID"),
                    rs.getString("PaymentMethods")
                );
                
                Voucher voucher = null;
                if (rs.getInt("voucherID") != 0) {
                    voucher = new Voucher(
                        rs.getInt("voucherID"),
                        rs.getString("voucherCode"),
                        rs.getInt("discountAmount")
                    );
                }
                
                Order1 order = new Order1(
                    rs.getInt("orderID"),
                    rs.getTimestamp("OrderDate"),
                    rs.getInt("TotalAmount"),
                    customer,
                    employee,
                    payment,
                    voucher
                );
                
                orders.add(order);
            }
        } catch (SQLException e) {
            System.out.println("getOrdersByDate: " + e.getMessage());
        }
        return orders;
    }

    // Lấy chi tiết đơn hàng theo ID đơn hàng
    public List<OrderDetail1> getOrderDetailsByOrderID(int orderID) {
        List<OrderDetail1> details = new ArrayList<>();
        String sql = "SELECT od.ID AS orderDetailID, od.Quantity, od.Price, " +
                     "p.ID, p.ProductName, p.ProductCode, p.Price AS productPrice " +
                     "FROM OrderDetails od " +
                     "JOIN Products p ON od.ProductsID = p.ID " +
                     "WHERE od.OrdersID = ?";
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderID);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setPrice(rs.getInt("productPrice"));
                
                Order1 order = new Order1();
                order.setOrderID(orderID);
                
                OrderDetail1 detail = new OrderDetail1(
                    rs.getInt("orderDetailID"),
                    rs.getInt("Quantity"),
                    rs.getInt("Price"),
                    order,
                    product
                );
                
                details.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("getOrderDetailsByOrderID: " + e.getMessage());
        }
        return details;
    }

    // Lấy tổng doanh thu theo ngày
    public int getTotalRevenueByDate(Date date) {
        int total = 0;
        String sql = "SELECT SUM(TotalAmount) AS totalRevenue " +
                     "FROM [Orders] " +
                     "WHERE CONVERT(date, OrderDate) = CONVERT(date, ?)";
        try {
            ps = conn.prepareStatement(sql);
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            ps.setDate(1, sqlDate);
            rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("totalRevenue");
            }
        } catch (SQLException e) {
            System.out.println("getTotalRevenueByDate: " + e.getMessage());
        }
        return total;
    }

    // Lấy số lượng đơn hàng theo ngày
    public int getOrderCountByDate(Date date) {
        int count = 0;
        String sql = "SELECT COUNT(*) AS orderCount " +
                     "FROM [Orders] " +
                     "WHERE CONVERT(date, OrderDate) = CONVERT(date, ?)";
        try {
            ps = conn.prepareStatement(sql);
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            ps.setDate(1, sqlDate);
            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("orderCount");
            }
        } catch (SQLException e) {
            System.out.println("getOrderCountByDate: " + e.getMessage());
        }
        return count;
    }

    // Lấy top sản phẩm bán chạy theo ngày
    public List<Map<String, Object>> getTopSellingProductsByDate(Date date, int limit) {
        List<Map<String, Object>> products = new ArrayList<>();
        String sql = "SELECT p.ID, p.ProductName, p.ProductCode, SUM(od.Quantity) AS totalQuantity, SUM(od.Price * od.Quantity) AS totalRevenue " +
                     "FROM OrderDetails od " +
                     "JOIN [Orders] o ON od.OrdersID = o.ID " +
                     "JOIN Products p ON od.ProductsID = p.ID " +
                     "WHERE CONVERT(date, o.OrderDate) = CONVERT(date, ?) " +
                     "GROUP BY p.ID, p.ProductName, p.ProductCode " +
                     "ORDER BY totalQuantity DESC";
        if (limit > 0) {
            sql += " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        }
        try {
            ps = conn.prepareStatement(sql);
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            ps.setDate(1, sqlDate);
            if (limit > 0) {
                ps.setInt(2, limit);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("ID"));
                product.put("productName", rs.getString("ProductName"));
                product.put("productCode", rs.getString("ProductCode"));
                product.put("totalQuantity", rs.getInt("totalQuantity"));
                product.put("totalRevenue", rs.getInt("totalRevenue"));
                products.add(product);
            }
        } catch (SQLException e) {
            System.out.println("getTopSellingProductsByDate: " + e.getMessage());
        }
        return products;
    }

    // Lấy doanh thu theo từng giờ trong ngày
    public Map<Integer, Integer> getRevenueByHourOfDay(Date date) {
        Map<Integer, Integer> hourlyRevenue = new HashMap<>();
        // Khởi tạo tất cả các giờ từ 0-23 với giá trị 0
        for (int i = 0; i < 24; i++) {
            hourlyRevenue.put(i, 0);
        }
        
        String sql = "SELECT DATEPART(HOUR, OrderDate) AS hour, SUM(TotalAmount) AS revenue " +
                     "FROM [Orders] " +
                     "WHERE CONVERT(date, OrderDate) = CONVERT(date, ?) " +
                     "GROUP BY DATEPART(HOUR, OrderDate)";
        try {
            ps = conn.prepareStatement(sql);
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            ps.setDate(1, sqlDate);
            rs = ps.executeQuery();
            while (rs.next()) {
                int hour = rs.getInt("hour");
                int revenue = rs.getInt("revenue");
                hourlyRevenue.put(hour, revenue);
            }
        } catch (SQLException e) {
            System.out.println("getRevenueByHourOfDay: " + e.getMessage());
        }
        return hourlyRevenue;
    }
}
