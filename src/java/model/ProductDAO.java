package model;

import database.DatabaseConnection;
import entity.Product1;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private final Connection conn;

    public ProductDAO() {
        DatabaseConnection db = new DatabaseConnection();
        conn = db.getConnection();
    }

    // Lấy danh sách tất cả sản phẩm
    public List<Product1> getAllProducts() {
        List<Product1> list = new ArrayList<>();
        String sql = "SELECT * FROM Products";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product1 product = new Product1();
                product.setProductID(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setUnitPrice(rs.getInt("Price"));
                product.setStockQuantity(rs.getInt("StockQuantity"));
                product.setAvailable(rs.getBoolean("IsAvailable"));
                product.setCategoryID(rs.getInt("CategoryID"));
                
                list.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all products: " + e.getMessage());
        }
        
        return list;
    }
    
    // Lấy danh sách sản phẩm có sẵn
    public List<Product1> getAvailableProducts() {
        List<Product1> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE IsAvailable = 1";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product1 product = new Product1();
                product.setProductID(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setUnitPrice(rs.getInt("Price"));
                product.setStockQuantity(rs.getInt("StockQuantity"));
                product.setAvailable(rs.getBoolean("IsAvailable"));
                product.setCategoryID(rs.getInt("CategoryID"));
                
                list.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error getting available products: " + e.getMessage());
        }
        
        return list;
    }
    
    // Lấy thông tin sản phẩm theo ID
    public Product1 getProductById(int id) {
        Product1 product = null;
        String sql = "SELECT * FROM Products WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                product = new Product1();
                product.setProductID(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setUnitPrice(rs.getInt("Price"));
                product.setStockQuantity(rs.getInt("StockQuantity"));
                product.setAvailable(rs.getBoolean("IsAvailable"));
                product.setCategoryID(rs.getInt("CategoryID"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting product by ID: " + e.getMessage());
        }
        
        return product;
    }
    
    // Thêm sản phẩm mới
    public boolean addProduct(Product1 product) {
        String sql = "INSERT INTO Products (ProductName, ProductCode, Price, StockQuantity, IsAvailable, CategoryID) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getProductCode());
            ps.setInt(3, product.getUnitPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setBoolean(5, product.isAvailable());
            ps.setInt(6, product.getCategoryID());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error adding product: " + e.getMessage());
            return false;
        }
    }
    
    // Cập nhật thông tin sản phẩm
    public boolean updateProduct(Product1 product) {
        String sql = "UPDATE Products SET ProductName = ?, ProductCode = ?, Price = ?, StockQuantity = ?, IsAvailable = ?, CategoryID = ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getProductCode());
            ps.setInt(3, product.getUnitPrice());
            ps.setInt(4, product.getStockQuantity());
            ps.setBoolean(5, product.isAvailable());
            ps.setInt(6, product.getCategoryID());
            ps.setInt(7, product.getProductID());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating product: " + e.getMessage());
            return false;
        }
    }
    
    // Cập nhật số lượng tồn kho của sản phẩm
    public boolean updateProductStock(int productId, int newQuantity) {
        String sql = "UPDATE Products SET StockQuantity = ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, newQuantity);
            ps.setInt(2, productId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating product stock: " + e.getMessage());
            return false;
        }
    }
    
    // Xóa sản phẩm
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM Products WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }
    
    // Tìm kiếm sản phẩm theo tên
    public List<Product1> searchProductsByName(String name) {
        List<Product1> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE ProductName LIKE ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Product1 product = new Product1();
                product.setProductID(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setUnitPrice(rs.getInt("Price"));
                product.setStockQuantity(rs.getInt("StockQuantity"));
                product.setAvailable(rs.getBoolean("IsAvailable"));
                product.setCategoryID(rs.getInt("CategoryID"));
                
                list.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error searching products by name: " + e.getMessage());
        }
        
        return list;
    }
    
    // Tìm kiếm sản phẩm theo mã
    public Product1 getProductByCode(String code) {
        Product1 product = null;
        String sql = "SELECT * FROM Products WHERE ProductCode = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                product = new Product1();
                product.setProductID(rs.getInt("ID"));
                product.setProductName(rs.getString("ProductName"));
                product.setProductCode(rs.getString("ProductCode"));
                product.setUnitPrice(rs.getInt("Price"));
                product.setStockQuantity(rs.getInt("StockQuantity"));
                product.setAvailable(rs.getBoolean("IsAvailable"));
                product.setCategoryID(rs.getInt("CategoryID"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting product by code: " + e.getMessage());
        }
        
        return product;
    }
} 