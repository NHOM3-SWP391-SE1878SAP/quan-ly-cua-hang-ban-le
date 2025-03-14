package dao;

import database.DatabaseConnection;
import entity.GoodReceipt;
import entity.GoodReceiptDetail;
import entity.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class GoodReceiptDetailDAO {
    private Connection conn;
    private ProductDAO productDAO;
    private GoodReceiptDAO goodReceiptDAO;

    public GoodReceiptDetailDAO() {
        DatabaseConnection db = new DatabaseConnection();
        conn = db.getConnection();
        productDAO = new ProductDAO();
        goodReceiptDAO = new GoodReceiptDAO();
    }

    // Lấy danh sách chi tiết phiếu nhập hàng theo ID phiếu nhập
    public List<GoodReceiptDetail> getGoodReceiptDetailsByReceiptId(int receiptId) {
        List<GoodReceiptDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM GoodReceiptDetails WHERE GoodsReceiptID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, receiptId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                GoodReceiptDetail detail = new GoodReceiptDetail();
                detail.setGoodReceiptDetailID(rs.getInt("ID"));
                detail.setBatchNumber(rs.getString("BatchNumber"));
                detail.setQuantityReceived(rs.getInt("QuantityReceived"));
                detail.setUnitCost(rs.getInt("UnitCost"));
                detail.setExpirationDate(rs.getDate("ExpirationDate"));
                
                // Lấy thông tin phiếu nhập
                GoodReceipt receipt = goodReceiptDAO.getGoodReceiptById(receiptId);
                detail.setGoodReceipt(receipt);
                
                // Lấy thông tin sản phẩm
                int productId = rs.getInt("ProductsID");
                Product product = productDAO.getProductById(productId);
                detail.setProduct(product);
                
                list.add(detail);
            }
        } catch (SQLException e) {
            System.out.println("Error getting good receipt details: " + e.getMessage());
        }
        
        return list;
    }
    
    // Lấy chi tiết phiếu nhập hàng theo ID
    public GoodReceiptDetail getGoodReceiptDetailById(int id) {
        GoodReceiptDetail detail = null;
        String sql = "SELECT * FROM GoodReceiptDetails WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                detail = new GoodReceiptDetail();
                detail.setGoodReceiptDetailID(rs.getInt("ID"));
                detail.setBatchNumber(rs.getString("BatchNumber"));
                detail.setQuantityReceived(rs.getInt("QuantityReceived"));
                detail.setUnitCost(rs.getInt("UnitCost"));
                detail.setExpirationDate(rs.getDate("ExpirationDate"));
                
                // Lấy thông tin phiếu nhập
                int receiptId = rs.getInt("GoodsReceiptID");
                GoodReceipt receipt = goodReceiptDAO.getGoodReceiptById(receiptId);
                detail.setGoodReceipt(receipt);
                
                // Lấy thông tin sản phẩm
                int productId = rs.getInt("ProductsID");
                Product product = productDAO.getProductById(productId);
                detail.setProduct(product);
            }
        } catch (SQLException e) {
            System.out.println("Error getting good receipt detail by ID: " + e.getMessage());
        }
        
        return detail;
    }
    
    // Thêm chi tiết phiếu nhập hàng mới
    public int addGoodReceiptDetail(GoodReceiptDetail detail) {
        int generatedId = -1;
        String sql = "INSERT INTO GoodReceiptDetails (BatchNumber, QuantityReceived, UnitCost, ExpirationDate, GoodsReceiptID, ProductsID) VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, detail.getBatchNumber());
            ps.setInt(2, detail.getQuantityReceived());
            ps.setInt(3, detail.getUnitCost());
            ps.setDate(4, new java.sql.Date(detail.getExpirationDate().getTime()));
            ps.setInt(5, detail.getGoodReceipt().getGoodReceiptID());
            ps.setInt(6, detail.getProduct().getProductID());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
                
                // Cập nhật số lượng tồn kho của sản phẩm
                updateProductStock(detail.getProduct().getProductID(), detail.getQuantityReceived());
            }
        } catch (SQLException e) {
            System.out.println("Error adding good receipt detail: " + e.getMessage());
        }
        
        return generatedId;
    }
    
    // Cập nhật chi tiết phiếu nhập hàng
    public boolean updateGoodReceiptDetail(GoodReceiptDetail detail) {
        // Lấy số lượng cũ trước khi cập nhật
        int oldQuantity = getOldQuantity(detail.getGoodReceiptDetailID());
        
        String sql = "UPDATE GoodReceiptDetails SET BatchNumber = ?, QuantityReceived = ?, UnitCost = ?, ExpirationDate = ?, GoodsReceiptID = ?, ProductsID = ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, detail.getBatchNumber());
            ps.setInt(2, detail.getQuantityReceived());
            ps.setInt(3, detail.getUnitCost());
            ps.setDate(4, new java.sql.Date(detail.getExpirationDate().getTime()));
            ps.setInt(5, detail.getGoodReceipt().getGoodReceiptID());
            ps.setInt(6, detail.getProduct().getProductID());
            ps.setInt(7, detail.getGoodReceiptDetailID());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                // Cập nhật số lượng tồn kho của sản phẩm (chỉ cập nhật phần chênh lệch)
                int quantityDiff = detail.getQuantityReceived() - oldQuantity;
                if (quantityDiff != 0) {
                    updateProductStock(detail.getProduct().getProductID(), quantityDiff);
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.out.println("Error updating good receipt detail: " + e.getMessage());
            return false;
        }
    }
    
    // Lấy số lượng cũ của chi tiết phiếu nhập hàng
    private int getOldQuantity(int detailId) {
        int oldQuantity = 0;
        String sql = "SELECT QuantityReceived FROM GoodReceiptDetails WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, detailId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                oldQuantity = rs.getInt("QuantityReceived");
            }
        } catch (SQLException e) {
            System.out.println("Error getting old quantity: " + e.getMessage());
        }
        
        return oldQuantity;
    }
    
    // Xóa chi tiết phiếu nhập hàng
    public boolean deleteGoodReceiptDetail(int id) {
        // Lấy thông tin chi tiết phiếu nhập hàng trước khi xóa
        GoodReceiptDetail detail = getGoodReceiptDetailById(id);
        if (detail == null) {
            return false;
        }
        
        String sql = "DELETE FROM GoodReceiptDetails WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                // Cập nhật số lượng tồn kho của sản phẩm (giảm đi số lượng đã nhập)
                updateProductStock(detail.getProduct().getProductID(), -detail.getQuantityReceived());
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.out.println("Error deleting good receipt detail: " + e.getMessage());
            return false;
        }
    }
    
    // Xóa tất cả chi tiết phiếu nhập hàng theo ID phiếu nhập
    public boolean deleteGoodReceiptDetailsByReceiptId(int receiptId) {
        // Lấy danh sách chi tiết phiếu nhập hàng trước khi xóa
        List<GoodReceiptDetail> details = getGoodReceiptDetailsByReceiptId(receiptId);
        
        String sql = "DELETE FROM GoodReceiptDetails WHERE GoodsReceiptID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, receiptId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                // Cập nhật số lượng tồn kho của các sản phẩm
                for (GoodReceiptDetail detail : details) {
                    updateProductStock(detail.getProduct().getProductID(), -detail.getQuantityReceived());
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.out.println("Error deleting good receipt details by receipt ID: " + e.getMessage());
            return false;
        }
    }
    
    // Cập nhật số lượng tồn kho của sản phẩm
    private void updateProductStock(int productId, int quantityChange) {
        String sql = "UPDATE Products SET StockQuantity = StockQuantity + ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantityChange);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updating product stock: " + e.getMessage());
        }
    }
    
    // Tính tổng giá trị của phiếu nhập hàng
    public int calculateTotalCost(int receiptId) {
        int totalCost = 0;
        String sql = "SELECT SUM(QuantityReceived * UnitCost) AS TotalCost FROM GoodReceiptDetails WHERE GoodsReceiptID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, receiptId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                totalCost = rs.getInt("TotalCost");
            }
        } catch (SQLException e) {
            System.out.println("Error calculating total cost: " + e.getMessage());
        }
        
        return totalCost;
    }
} 