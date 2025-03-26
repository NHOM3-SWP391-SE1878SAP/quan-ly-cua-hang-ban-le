package dao;

import database.DatabaseConnection;
import entity.GoodReceipt;
import entity.Supplier;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class GoodReceiptDAO extends DBConnect{
    private final Connection conn;
    private final DAOSupplier supplierDAO;

    public GoodReceiptDAO() {
        conn = new DatabaseConnection().getConnection();
        supplierDAO = new DAOSupplier();
    }
 

    // Lấy danh sách tất cả phiếu nhập hàng
    public List<GoodReceipt> getAllGoodReceipts() {
        List<GoodReceipt> list = new ArrayList<>();
        String sql = "SELECT * FROM GoodsReceipt ORDER BY ReceivedDate DESC";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                GoodReceipt receipt = new GoodReceipt();
                receipt.setGoodReceiptID(rs.getInt("ID"));
                receipt.setReceivedDate(rs.getDate("ReceivedDate"));
                receipt.setTotalCost(rs.getInt("TotalCost"));
                
                // Lấy thông tin nhà cung cấp
                int supplierId = rs.getInt("SuppliersID");
                Supplier supplier = supplierDAO.getSupplierById(supplierId);
                receipt.setSupplier(supplier);
                
                list.add(receipt);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all good receipts: " + e.getMessage());
        }
        
        return list;
    }
    
    // Lấy danh sách phiếu nhập hàng theo bộ lọc
    public List<GoodReceipt> getGoodReceiptsByFilter(String timeFilter, int supplierId, String search, int page, int pageSize) {
        List<GoodReceipt> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM GoodsReceipt WHERE 1=1");
        
        // Thêm điều kiện lọc theo thời gian
        if (timeFilter != null && !timeFilter.equals("allTime")) {
            if (timeFilter.equals("thisMonth")) {
                sql.append(" AND MONTH(ReceivedDate) = MONTH(GETDATE()) AND YEAR(ReceivedDate) = YEAR(GETDATE())");
            } else if (timeFilter.equals("thisQuarter")) {
                sql.append(" AND DATEPART(QUARTER, ReceivedDate) = DATEPART(QUARTER, GETDATE()) AND YEAR(ReceivedDate) = YEAR(GETDATE())");
            } else if (timeFilter.equals("thisYear")) {
                sql.append(" AND YEAR(ReceivedDate) = YEAR(GETDATE())");
            }
        }
        
        // Thêm điều kiện lọc theo nhà cung cấp
        if (supplierId > 0) {
            sql.append(" AND SuppliersID = ?");
        }
        
        // Thêm điều kiện tìm kiếm
          if (search != null && !search.isEmpty()) {
            sql.append(" AND (ID LIKE ? OR SuppliersID IN (SELECT ID FROM Suppliers WHERE [SupplierName] LIKE ?))");
        }
        
        // Thêm phân trang
        int offset = (page - 1) * pageSize;
        sql.append(" ORDER BY ReceivedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Thiết lập tham số cho bộ lọc thời gian
            if (timeFilter != null && !timeFilter.equals("allTime")) {
                if (timeFilter.equals("thisMonth")) {
                    sql.append(" AND MONTH(ReceivedDate) = MONTH(GETDATE()) AND YEAR(ReceivedDate) = YEAR(GETDATE())");
                } else if (timeFilter.equals("thisQuarter")) {
                    sql.append(" AND DATEPART(QUARTER, ReceivedDate) = DATEPART(QUARTER, GETDATE()) AND YEAR(ReceivedDate) = YEAR(GETDATE())");
                } else if (timeFilter.equals("thisYear")) {
                    sql.append(" AND YEAR(ReceivedDate) = YEAR(GETDATE())");
                }
            }
            
            // Thiết lập tham số cho bộ lọc nhà cung cấp
            if (supplierId > 0) {
                ps.setInt(paramIndex++, supplierId);
            }
            
            // Thiết lập tham số cho tìm kiếm
            if (search != null && !search.isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
                ps.setString(paramIndex++, "%" + search + "%");
            }
            
            // Thiết lập tham số cho phân trang
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                GoodReceipt receipt = new GoodReceipt();
                receipt.setGoodReceiptID(rs.getInt("ID"));
                receipt.setReceivedDate(rs.getDate("ReceivedDate"));
                receipt.setTotalCost(rs.getInt("TotalCost"));
                
                // Lấy thông tin nhà cung cấp
                int supplierIdFromDB = rs.getInt("SuppliersID");
                Supplier supplier = supplierDAO.getSupplierById(supplierIdFromDB);
                receipt.setSupplier(supplier);
                
                list.add(receipt);
            }
        } catch (SQLException e) {
            System.out.println("Error getting filtered good receipts: " + e.getMessage());
        }
        
        return list;
    }
    
    // Đếm tổng số phiếu nhập hàng theo bộ lọc
    public int countGoodReceiptsByFilter(String timeFilter, int supplierId, String search) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM GoodsReceipt WHERE 1=1");
        
        // Thêm điều kiện lọc theo thời gian
        if (timeFilter != null && !timeFilter.equals("allTime")) {
            Date currentDate = new Date();
            Calendar cal = Calendar.getInstance();
            cal.setTime(currentDate);
            
            switch (timeFilter) {
                case "thisMonth" -> {
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfMonth = cal.getTime();
                    sql.append(" AND ReceivedDate >= ?");
                }
                case "thisQuarter" -> {
                    int currentMonth = cal.get(Calendar.MONTH);
                    int quarterStartMonth = currentMonth - (currentMonth % 3);
                    cal.set(Calendar.MONTH, quarterStartMonth);
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfQuarter = cal.getTime();
                    sql.append(" AND ReceivedDate >= ?");
                }
                case "thisYear" -> {
                    cal.set(Calendar.MONTH, Calendar.JANUARY);
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfYear = cal.getTime();
                    sql.append(" AND ReceivedDate >= ?");
                }
                default -> {
                }
            }
        }
        
        // Thêm điều kiện lọc theo nhà cung cấp
        if (supplierId > 0) {
            sql.append(" AND SuppliersID = ?");
        }
        
        // Thêm điều kiện tìm kiếm theo mã phiếu nhập
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND ID LIKE ?");
        }
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            // Thiết lập tham số cho bộ lọc thời gian
            if (timeFilter != null && !timeFilter.equals("allTime")) {
                Date currentDate = new Date();
                Calendar cal = Calendar.getInstance();
                cal.setTime(currentDate);
                
                if (timeFilter.equals("thisMonth")) {
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfMonth = cal.getTime();
                    ps.setDate(paramIndex++, new java.sql.Date(firstDayOfMonth.getTime()));
                } else if (timeFilter.equals("thisQuarter")) {
                    int currentMonth = cal.get(Calendar.MONTH);
                    int quarterStartMonth = currentMonth - (currentMonth % 3);
                    cal.set(Calendar.MONTH, quarterStartMonth);
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfQuarter = cal.getTime();
                    ps.setDate(paramIndex++, new java.sql.Date(firstDayOfQuarter.getTime()));
                } else if (timeFilter.equals("thisYear")) {
                    cal.set(Calendar.MONTH, Calendar.JANUARY);
                    cal.set(Calendar.DAY_OF_MONTH, 1);
                    Date firstDayOfYear = cal.getTime();
                    ps.setDate(paramIndex++, new java.sql.Date(firstDayOfYear.getTime()));
                }
            }
            
            // Thiết lập tham số cho bộ lọc nhà cung cấp
            if (supplierId > 0) {
                ps.setInt(paramIndex++, supplierId);
            }
            
            // Thiết lập tham số cho tìm kiếm
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + search + "%");
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting filtered good receipts: " + e.getMessage());
        }
        
        return count;
    }
    
    // Lấy thông tin phiếu nhập hàng theo ID
    public GoodReceipt getGoodReceiptById(int id) {
        GoodReceipt receipt = null;
        String sql = "SELECT * FROM GoodsReceipt WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                receipt = new GoodReceipt();
                receipt.setGoodReceiptID(rs.getInt("ID"));
                receipt.setReceivedDate(rs.getDate("ReceivedDate"));
                receipt.setTotalCost(rs.getInt("TotalCost"));
                
                // Lấy thông tin nhà cung cấp
                int supplierId = rs.getInt("SuppliersID");
                Supplier supplier = supplierDAO.getSupplierById(supplierId);
                receipt.setSupplier(supplier);
            }
        } catch (SQLException e) {
            System.out.println("Error getting good receipt by ID: " + e.getMessage());
        }
        
        return receipt;
    }
    
    // Thêm phiếu nhập hàng mới
    public int addGoodReceipt(GoodReceipt receipt) {
        int generatedId = -1;
        String sql = "INSERT INTO GoodsReceipt (ReceivedDate, TotalCost, SuppliersID) VALUES (?, ?, ?)";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setDate(1, new java.sql.Date(receipt.getReceivedDate().getTime()));
            ps.setInt(2, receipt.getTotalCost());
            ps.setInt(3, receipt.getSupplier().getId());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error adding good receipt: " + e.getMessage());
        }
        
        return generatedId;
    }
    
    // Cập nhật phiếu nhập hàng
    public boolean updateGoodReceipt(GoodReceipt receipt) {
        String sql = "UPDATE GoodsReceipt SET ReceivedDate = ?, TotalCost = ?, SuppliersID = ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setDate(1, new java.sql.Date(receipt.getReceivedDate().getTime()));
            ps.setInt(2, receipt.getTotalCost());
            ps.setInt(3, receipt.getSupplier().getId());
            ps.setInt(4, receipt.getGoodReceiptID());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating good receipt: " + e.getMessage());
            return false;
        }
    }
    
    // Xóa phiếu nhập hàng
    public boolean deleteGoodReceipt(int id) {
        String sql = "DELETE FROM GoodsReceipt WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting good receipt: " + e.getMessage());
            return false;
        }
    }
    
    // Đánh dấu phiếu nhập hàng yêu thích (cần thêm cột Favorite vào bảng GoodsReceipt)
    public boolean toggleFavorite(int id) {
        // Kiểm tra trạng thái hiện tại
        boolean currentStatus = isFavorite(id);
        
        // Đảo ngược trạng thái
        String sql = "UPDATE GoodsReceipt SET Favorite = ? WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBoolean(1, !currentStatus);
            ps.setInt(2, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error toggling favorite status: " + e.getMessage());
            return false;
        }
    }
    
    // Kiểm tra phiếu nhập hàng có được đánh dấu yêu thích không
    public boolean isFavorite(int id) {
        boolean favorite = false;
        String sql = "SELECT Favorite FROM GoodsReceipt WHERE ID = ?";
        
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                favorite = rs.getBoolean("Favorite");
            }
        } catch (SQLException e) {
            System.out.println("Error checking favorite status: " + e.getMessage());
        }
        
        return favorite;
    }
} 