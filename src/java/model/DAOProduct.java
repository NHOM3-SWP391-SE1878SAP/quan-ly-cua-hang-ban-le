package model;

import entity.Category;
import entity.GoodReceiptDetail;
import entity.Product;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOProduct extends DBConnect {

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
        String sql = "UPDATE Products SET productName = ?, productCode = ?, Price = ?, stockQuantity = ?, isAvailable = ?, imageURL = ?, categoryID = ? "
                + "WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);

            pre.setString(1, product.getProductName());
            pre.setString(2, product.getProductCode());
            pre.setInt(3, product.getPrice());
            pre.setInt(4, product.getStockQuantity());
            pre.setBoolean(5, product.getStockQuantity() > 0);
            pre.setString(6, product.getImageURL());
            pre.setInt(7, product.getCategory().getCategoryID());
            pre.setInt(8, product.getId());
            pre.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public boolean stopSellProduct(int productId) {
        String sql = "UPDATE Products SET IsAvailable = 0 WHERE ID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, productId);
            int rowsUpdated = pre.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Error stopping product sale", ex);
            return false;
        }
    }

    public boolean resumeSellProduct(int productId) {
        String sql = "UPDATE Products SET IsAvailable = 1 WHERE ID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, productId);
            int rowsUpdated = pre.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Error resuming product sale", ex);
            return false;
        }
    }

    public boolean updateProductStatus(int productId, boolean isAvailable) {
        String sql = "UPDATE Products SET IsAvailable = ? WHERE ID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isAvailable);
            ps.setInt(2, productId);
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void addProduct(Product product) {
        String sql = "INSERT INTO Products (productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            pre.setString(1, product.getProductName());
            pre.setString(2, product.getProductCode());
            pre.setInt(3, product.getPrice());
            pre.setInt(4, product.getStockQuantity());
            pre.setBoolean(5, product.isIsAvailable()); // Đặt isAvailable
            pre.setString(6, product.getImageURL());
            pre.setInt(7, product.getCategory().getCategoryID()); // Lấy categoryID từ đối tượng Category

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
                ResultSet.CONCUR_UPDATABLE); ResultSet rs = state.executeQuery(sql)) {

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

    public Vector<Product> getProductsWithUnitCost() {
        Vector<Product> products = new Vector<>();
        String sql = "SELECT p.id, p.ProductCode, p.ProductName, grd.UnitCost, p.Price "
                + "FROM Products p "
                + "JOIN GoodReceiptDetails grd ON p.ID = grd.ProductsID";

        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("ID");
                String productCode = rs.getString("ProductCode");
                String productName = rs.getString("ProductName");
                int unitCost = rs.getInt("UnitCost"); // Giá vốn
                int price = rs.getInt("Price"); // Giá bán

                // Tạo đối tượng Product chỉ với các thông tin cần thiết
                Product product = new Product();
                product.setId(id);
                product.setProductCode(productCode);
                product.setProductName(productName);
                product.setPrice(price);

                GoodReceiptDetail grd = new GoodReceiptDetail();
                grd.setUnitCost(unitCost);
                product.setGoodReceiptDetail(grd);

                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return products;
    }

    public Vector<Product> getProductsStockTakes() {
        Vector<Product> products = new Vector<>();
        // Câu lệnh SQL mới với JOIN bảng Categories để lấy thêm tên danh mục
        String sql = "SELECT p.id, p.ProductCode, p.ProductName, p.StockQuantity, p.IsAvailable, p.Price, p.ImageURL, c.CategoryName "
                + "FROM Products p "
                + "LEFT JOIN GoodReceiptDetails grd ON p.ID = grd.ProductsID "
                + "LEFT JOIN Categories c ON p.CategoryID = c.ID "
                + "WHERE grd.ProductsID IS NULL"; // Chỉ lấy những sản phẩm chưa có thông tin phiếu nhập kho

        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("ID");
                String productCode = rs.getString("ProductCode");
                String productName = rs.getString("ProductName");
                int price = rs.getInt("Price");
                int stockQuantity = rs.getInt("StockQuantity");
                boolean isAvailable = rs.getBoolean("IsAvailable");
                String imageURL = rs.getString("ImageURL");
                String categoryName = rs.getString("CategoryName");  // Lấy tên danh mục

                // Tạo đối tượng Product chỉ với các thông tin cần thiết
                Product product = new Product();
                product.setId(id);
                product.setProductCode(productCode);
                product.setProductName(productName);
                product.setPrice(price);
                product.setStockQuantity(stockQuantity);
                product.setIsAvailable(isAvailable);
                product.setImageURL(imageURL);

                // Tạo đối tượng Category và gán vào sản phẩm
                Category category = new Category();
                category.setCategoryName(categoryName); // Gán tên danh mục vào sản phẩm
                product.setCategory(category);

                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return products;
    }

    public boolean updateProductsPriceBatch(List<Product> products) {
        String sql = "UPDATE Products SET price = ? WHERE ID = ?";
        try {
            PreparedStatement pre = conn.prepareStatement(sql);
            for (Product product : products) {
                pre.setInt(1, product.getPrice());
                pre.setInt(2, product.getId());
                pre.addBatch();
            }

            int[] rowsAffected = pre.executeBatch();

            System.out.println("Số sản phẩm được cập nhật: " + Arrays.stream(rowsAffected).sum());

            return Arrays.stream(rowsAffected).sum() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Lỗi cập nhật giá hàng loạt!", ex);
            return false;
        }
    }

    public Product getProductById(int productId) {
        Product product = null;
        String sql = "SELECT * FROM Products WHERE ID = ?";

        if (conn == null) {
            System.err.println("Lỗi: Chưa kết nối với database!");
            return null;
        }

        try (PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, productId);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("ID");
                    String productName = rs.getString("ProductName");
                    String productCode = rs.getString("ProductCode");
                    int price = rs.getInt("Price");
                    int stockQuantity = rs.getInt("StockQuantity");
                    boolean isAvailable = rs.getBoolean("IsAvailable");
                    String imageURL = rs.getString("imageURL");
                    int categoryId = rs.getInt("CategoryID");

                    product = new Product(id, productName, productCode, price, stockQuantity, isAvailable, imageURL, categoryId);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return product;
    }

    public Vector<Product> getFilteredProducts(Integer categoryId, String stockStatus) {
        Vector<Product> products = new Vector<>();
        String sql = "SELECT p.*, c.CategoryName FROM Products p "
                + "LEFT JOIN Categories c ON p.CategoryID = c.ID WHERE 1=1";

        // Thêm điều kiện lọc theo categoryId nếu có
        if (categoryId != null) {
            sql += " AND p.CategoryID = ?";
        }

        // Thêm điều kiện lọc theo stockStatus nếu có
        if ("outofstock".equals(stockStatus)) {
            sql += " AND p.StockQuantity = 0";
        } else if ("inStock".equals(stockStatus)) {
            sql += " AND p.StockQuantity > 0";
        }

        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            int paramIndex = 1;

            // Gán categoryId vào câu lệnh SQL nếu có
            if (categoryId != null) {
                pre.setInt(paramIndex++, categoryId);
            }

            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                // Tạo đối tượng Category
                Category category = new Category(rs.getInt("CategoryID"), rs.getString("CategoryName"), "", "");

                // Tạo đối tượng Product
                Product product = new Product(
                        rs.getInt("ID"),
                        rs.getString("ProductName"),
                        rs.getString("ProductCode"),
                        rs.getInt("Price"),
                        rs.getInt("StockQuantity"),
                        rs.getBoolean("IsAvailable"),
                        rs.getString("ImageURL"),
                        category // Gán Category vào Product
                );

                products.add(product);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return products;
    }

    public Vector<Category> getAllCategories() {
        Vector<Category> categories = new Vector<>();
        String sql = "SELECT * FROM Categories";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                categories.add(new Category(rs.getInt("ID"), rs.getString("CategoryName"), "", ""));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return categories;
    }

    public boolean isProductCodeExist(String productCode) {
        String sql = "SELECT COUNT(*) FROM Products WHERE ProductCode = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, productCode);  // Set mã sản phẩm cần kiểm tra
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);  // Lấy kết quả đếm số dòng trùng mã sản phẩm
                return count > 0;  // Nếu count > 0 thì có sản phẩm trùng mã
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;  // Không có sản phẩm trùng mã
    }

    public boolean isProductCodeExist(String productCode, int productId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE ProductCode = ? AND ID != ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, productCode);  // Set mã sản phẩm cần kiểm tra
            pre.setInt(2, productId);  // Loại trừ sản phẩm hiện tại
            ResultSet rs = pre.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);  // Lấy kết quả đếm số dòng trùng mã sản phẩm
                return count > 0;  // Nếu count > 0 thì có sản phẩm trùng mã
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;  // Không có sản phẩm trùng mã
    }

    public Vector<Product> getProductByCategory(int categoryID) {
        Vector<Product> products = new Vector<>();
        String sql = "SELECT p.ID, p.ProductName, p.ProductCode, p.Price, p.StockQuantity, "
                + "p.IsAvailable, p.ImageURL, c.ID as CategoryID, c.CategoryName, c.Description, c.Image "
                + "FROM Products p "
                + "JOIN Categories c ON p.CategoryID = c.ID "
                + "WHERE p.CategoryID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category(
                            rs.getInt("CategoryID"),
                            rs.getString("CategoryName"),
                            rs.getString("Description"),
                            rs.getString("Image")
                    );
                    Product product = new Product(
                            rs.getInt("ID"),
                            rs.getString("ProductName"),
                            rs.getString("ProductCode"),
                            rs.getInt("Price"),
                            rs.getInt("StockQuantity"),
                            rs.getBoolean("IsAvailable"),
                            rs.getString("ImageURL"),
                            category
                    );
                    products.add(product);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.SEVERE, "Lỗi truy vấn SQL", ex);
            throw new RuntimeException("Lỗi truy vấn cơ sở dữ liệu", ex);
        }
        if (products.isEmpty()) {
            Logger.getLogger(DAOProduct.class.getName()).log(Level.INFO, "Không có sản phẩm nào trong danh mục ID: " + categoryID);
        }
        return products;
    }
}
