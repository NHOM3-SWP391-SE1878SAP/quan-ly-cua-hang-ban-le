package model;

import entity.Category;
import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOCategory extends DBConnect {

    // Retrieve all categories from the database
    public Vector<Category> getAllCategories() {
        Vector<Category> categories = new Vector<>();
        String sql = "SELECT * FROM Categories";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(rs.getInt("ID"), rs.getString("CategoryName"), rs.getString("Description"), rs.getString("Image")));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return categories;
    }

    // Retrieve a specific category by its ID
    public Category getCategoryByID(int categoryID) {
        Category category = null;
        String sql = "SELECT * FROM Categories WHERE ID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, categoryID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    category = new Category(rs.getInt("ID"), rs.getString("CategoryName"), rs.getString("Description"), rs.getString("Image"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return category;
    }

    // Check if a category with the same CategoryName already exists
    public boolean isCategoryNameExists(String categoryName) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE CategoryName = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, categoryName);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Insert a new category into the database
    public void insertCategory(Category category) {
        String sql = "INSERT INTO Categories (categoryName, description, image) VALUES (?, ?, ?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, category.getCategoryName());
            pre.setString(2, category.getDescription());
            pre.setString(3, category.getImage());
            pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Update an existing category in the database
    public void updateCategory(Category category) {
        String sql = "UPDATE Categories SET categoryName = ?, description = ?, image = ? WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, category.getCategoryName());
            pre.setString(2, category.getDescription());
            pre.setString(3, category.getImage());
            pre.setInt(4, category.getCategoryID());
            pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

// Check if the CategoryName already exists for a different category (during update)
    public boolean isCategoryNameExistsForUpdate(String categoryName, int categoryID) {
        String sql = "SELECT COUNT(*) FROM Categories WHERE CategoryName = ? AND ID != ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, categoryName);
            pre.setInt(2, categoryID); // Exclude current category from the check
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;  // Another category with the same name exists
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Delete a category from the database
    public boolean deleteCategory(int categoryID) {
        String sql = "DELETE FROM Categories WHERE ID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, categoryID);
            int rowsAffected = pre.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }



}