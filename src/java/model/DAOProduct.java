package model;

import entity.Category;
import entity.Product;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOProduct extends DBConnect {

    // Nguyen
    public Vector<Product> getAllProducts() {
        Vector<Product> vector = new Vector<>();
        String sql = "SELECT * FROM Products";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {       
                int id = rs.getInt("ID");
                String productName = rs.getString("productName");
                String productCode = rs.getString("productCode");
                int price = rs.getInt("price");
                int stockQuantity = rs.getInt("stockQuantity");
                boolean isAvailable = rs.getBoolean("isAvailable");
                String imageURL = rs.getString("imageURL");
                int categoryId = rs.getInt("categoryID");

                Product p = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
                vector.add(p);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }

    public Vector<Product> getAllProducts1() {
        Vector<Product> vector = new Vector<>();

        // SQL query to join Products and Categories table
        String sql = "SELECT p.*, c.categoryName, c.description, c.image "
                + "FROM Products p "
                + "INNER JOIN Categories c ON p.categoryID = c.ID";

        try {
            // Prepare the statement to execute the query
            PreparedStatement pre = conn.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();

            // Loop through the result set and fetch the data
            while (rs.next()) {
                // Get data for product
                int id = rs.getInt("ID");
                String productName = rs.getString("productName");
                String productCode = rs.getString("productCode");
                int price = rs.getInt("price");
                int stockQuantity = rs.getInt("stockQuantity");
                boolean isAvailable = rs.getBoolean("isAvailable");
                String imageURL = rs.getString("imageURL");

                // Get data for category
                int categoryId = rs.getInt("categoryID");
                String categoryName = rs.getString("categoryName");
                String categoryDescription = rs.getString("description");
                String categoryImage = rs.getString("image");

                // Create Category object
                Category category = new Category(categoryId, categoryName, categoryDescription, categoryImage);

                // Create Product object with Category information
                Product product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, category);

                // Add product to vector
                vector.add(product);
            }
        } catch (SQLException ex) {
            // Handle any SQL errors
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Return the list of products
        return vector;
    }
    
    // Method to update an existing product
    public void updateProduct(Product product) {
        String sql = "UPDATE Products SET productName = ?, productCode = ?, price = ?, stockQuantity = ?, isAvailable = ?, imageURL = ?, categoryID = ? "
                   + "WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, product.getProductName());
            pre.setString(2, product.getProductCode());
            pre.setInt(3, product.getPrice());
            pre.setInt(4, product.getStockQuantity());
            pre.setBoolean(5, product.isIsAvailable());
            pre.setString(6, product.getImageURL());
            pre.setInt(7, product.getCategory().getCategoryID());
            pre.setInt(8, product.getId());
            pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    // Method to add a new product
    public void addProduct(Product product) {
        String sql = "INSERT INTO Products (productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryID) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, product.getProductName());
            pre.setString(2, product.getProductCode());
            pre.setInt(3, product.getPrice());
            pre.setInt(4, product.getStockQuantity());
            pre.setBoolean(5, product.isIsAvailable());
            pre.setString(6, product.getImageURL());
            pre.setInt(7, product.getCategory().getCategoryID());
            pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Method to fetch a product by ID
    public Product getProductByIdNg(int productId) {
        Product product = null;
        String sql = "SELECT p.*, c.categoryName, c.description, c.image "
                   + "FROM Products p "
                   + "INNER JOIN Categories c ON p.categoryID = c.ID "
                   + "WHERE p.ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, productId);
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                // Fetch product and category details
                String productName = rs.getString("productName");
                String productCode = rs.getString("productCode");
                int price = rs.getInt("price");
                int stockQuantity = rs.getInt("stockQuantity");
                boolean isAvailable = rs.getBoolean("isAvailable");
                String imageURL = rs.getString("imageURL");

                int categoryId = rs.getInt("categoryID");
                String categoryName = rs.getString("categoryName");
                String categoryDescription = rs.getString("description");
                String categoryImage = rs.getString("image");

                Category category = new Category(categoryId, categoryName, categoryDescription, categoryImage);
                product = new Product(productId, productName, productCode, price, stockQuantity, isAvailable, imageURL, category);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return product;
    }

    

    // Method to delete a product by ID
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setInt(1, productId);
            int result = pre.executeUpdate();
            return result > 0; // If the delete operation is successful, it will return true
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }
    
    // Sang
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
