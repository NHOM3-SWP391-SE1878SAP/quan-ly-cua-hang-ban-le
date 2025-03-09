package model;

import entity.Product;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Product
 */
public class DAOProduct extends DBConnect {
    
    private static final Logger LOGGER = Logger.getLogger(DAOProduct.class.getName());

    /**
     * Get all products from database
     * @param sql SQL query to retrieve product list
     * @return Vector containing list of products
     */
    public Vector<Product> getAllProducts(String sql) {
        Vector<Product> products = new Vector<>();
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return products;
        }

        ResultSet rs = null;
        Statement state = null;
        
        try {
            state = conn.createStatement(
                    ResultSet.TYPE_SCROLL_SENSITIVE,
                    ResultSet.CONCUR_UPDATABLE);
            rs = state.executeQuery(sql);

            while (rs.next()) {
                int id = rs.getInt("ID");
                String productName = rs.getString("ProductName");
                String productCode = rs.getString("ProductCode");
                int price = rs.getInt("Price");
                int stockQuantity = rs.getInt("StockQuantity");
                boolean isAvailable = rs.getBoolean("IsAvailable");
                String imageURL = rs.getString("ImageURL");
                int categoryId = rs.getInt("CategoryID");

                Product product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
                products.add(product);
            }

            LOGGER.info("Number of products retrieved: " + products.size());
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving product list", ex);
        } finally {
            // Close ResultSet and Statement
            try {
                if (rs != null) rs.close();
                if (state != null) state.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or Statement", ex);
            }
        }

        return products;
    }

    /**
     * Get product information by ID
     * @param productId ID of the product to retrieve
     * @return Product object or null if not found
     */
    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE ID = ?";

        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return null;
        }

        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, productId);  // Set parameter for PreparedStatement
            
            rs = pst.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("ID");
                String productName = rs.getString("ProductName");
                String productCode = rs.getString("ProductCode");
                int price = rs.getInt("Price");
                int stockQuantity = rs.getInt("StockQuantity");
                boolean isAvailable = rs.getBoolean("IsAvailable");
                String imageURL = rs.getString("ImageURL");
                int categoryId = rs.getInt("CategoryID");

                product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error retrieving product with ID: " + productId, ex);
        } finally {
            // Close ResultSet and PreparedStatement
            try {
                if (rs != null) rs.close();
                if (pst != null) pst.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing ResultSet or PreparedStatement", ex);
            }
        }

        return product;
    }
    
    /**
     * Add new product to database
     * @param product Product object to add
     * @return true if successful, false if failed
     */
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, ImageURL, CategoryID) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, product.getProductName());
            pst.setString(2, product.getProductCode());
            pst.setInt(3, product.getPrice());
            pst.setInt(4, product.getStockQuantity());
            pst.setBoolean(5, product.isIsAvailable());
            pst.setString(6, product.getImageURL());
            pst.setInt(7, product.getCategoryId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error adding new product", ex);
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
     * Update product information
     * @param product Product object to update
     * @return true if successful, false if failed
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE Products SET ProductName = ?, ProductCode = ?, Price = ?, "
                   + "StockQuantity = ?, IsAvailable = ?, ImageURL = ?, CategoryID = ? "
                   + "WHERE ID = ?";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setString(1, product.getProductName());
            pst.setString(2, product.getProductCode());
            pst.setInt(3, product.getPrice());
            pst.setInt(4, product.getStockQuantity());
            pst.setBoolean(5, product.isIsAvailable());
            pst.setString(6, product.getImageURL());
            pst.setInt(7, product.getCategoryId());
            pst.setInt(8, product.getId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating product with ID: " + product.getId(), ex);
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
     * Delete product from database
     * @param productId ID of the product to delete
     * @return true if successful, false if failed
     */
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM Products WHERE ID = ?";
        
        // Ensure connection is open
        if (conn == null) {
            LOGGER.severe("Error: Cannot connect to database!");
            return false;
        }
        
        PreparedStatement pst = null;
        
        try {
            pst = conn.prepareStatement(sql);
            pst.setInt(1, productId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error deleting product with ID: " + productId, ex);
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
//    public static void main(String[] args) {
//        DAOProduct daoProduct = new DAOProduct();
//        try {
//            Vector<Product> products = daoProduct.getAllProducts("SELECT * FROM Products");
//            for (Product product : products) {
//                System.out.println(product);
//            }
//        } finally {
//            // Ensure connection is closed after use
//            daoProduct.closeConnection();
//        }
//    }
}
