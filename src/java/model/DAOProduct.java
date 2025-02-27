package model;

import entity.Product;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Vector;

/**
 * Data Access Object for Product
 */
public class DAOProduct extends DBConnect {

    /**
     * Lấy tất cả sản phẩm từ database
     * @param sql Câu lệnh SQL để lấy danh sách sản phẩm
     * @return Vector chứa danh sách sản phẩm
     */
    public Vector<Product> getAllProducts(String sql) {
        Vector<Product> products = new Vector<>();
        
        // Kiểm tra kết nối database trước khi truy vấn
        if (conn == null) {
            System.err.println("Lỗi: Chưa kết nối với database!");
            return products;
        }

        try (Statement state = conn.createStatement(
                ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
             ResultSet rs = state.executeQuery(sql)) {

            while (rs.next()) {
                int id = rs.getInt("ID");
                String productName = rs.getString("ProductName");
                String productCode = rs.getString("ProductCode");
                int price = rs.getInt("Price");
                int stockQuantity = rs.getInt("StockQuantity");
                boolean isAvailable = rs.getBoolean("IsAvailable");
                String imageURL = rs.getString("imageURL");  // Bổ sung lấy ảnh
                int categoryId = rs.getInt("CategoryID");

                Product product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
                products.add(product);
            }

            System.out.println("Số sản phẩm lấy được: " + products.size()); // Debug
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return products;
    }

    /**
     * Lấy thông tin sản phẩm theo ID
     * @param productId ID của sản phẩm cần lấy
     * @return Đối tượng Product hoặc null nếu không tìm thấy
     */
    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE ID = ?";

        // Kiểm tra kết nối database trước khi truy vấn
        if (conn == null) {
            System.err.println("Lỗi: Chưa kết nối với database!");
            return null;
        }

        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, productId);  // Set tham số cho PreparedStatement
            
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("ID");
                    String productName = rs.getString("ProductName");
                    String productCode = rs.getString("ProductCode");
                    int price = rs.getInt("Price");
                    int stockQuantity = rs.getInt("StockQuantity");
                    boolean isAvailable = rs.getBoolean("IsAvailable");
                    String imageURL = rs.getString("imageURL");  // Bổ sung lấy ảnh
                    int categoryId = rs.getInt("CategoryID");

                    product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return product;
    }
}
