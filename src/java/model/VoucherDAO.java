package model;

import entity.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class VoucherDAO {

    private Connection conn;

    public VoucherDAO(Connection conn) {
        this.conn = conn;
    }

    // ✅ Get total number of vouchers
    public int getTotalVoucherCount() {
        String query = "SELECT COUNT(*) FROM vouchers";
        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ✅ Pagination: Get vouchers by page
    public List<Voucher> getVouchersByPage(int page, int recordsPerPage) {
        List<Voucher> vouchers = new ArrayList<>();
        int start = (page - 1) * recordsPerPage;

        String query = "SELECT * FROM vouchers ORDER BY ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, start);
            stmt.setInt(2, recordsPerPage);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                vouchers.add(new Voucher(
                        rs.getInt("ID"),
                        rs.getString("Code"),
                        rs.getInt("MinOrder"),
                        rs.getInt("DiscountRate"),
                        rs.getInt("MaxValue"),
                        rs.getInt("Usage_limit"),
                        rs.getInt("Usage_count"),
                        rs.getBoolean("Status"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 📌 Get all vouchers
    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT * FROM vouchers ORDER BY ID DESC";
        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                vouchers.add(new Voucher(
                        rs.getInt("ID"),
                        rs.getString("Code"),
                        rs.getInt("MinOrder"),
                        rs.getInt("DiscountRate"),
                        rs.getInt("MaxValue"),
                        rs.getInt("Usage_limit"),
                        rs.getInt("Usage_count"),
                        rs.getBoolean("Status"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 🔍 Search vouchers by code
    public List<Voucher> searchVouchers(String keyword) {
        List<Voucher> vouchers = new ArrayList<>();
        String query = "SELECT * FROM vouchers WHERE Code LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                vouchers.add(new Voucher(
                        rs.getInt("ID"),
                        rs.getString("Code"),
                        rs.getInt("MinOrder"),
                        rs.getInt("DiscountRate"),
                        rs.getInt("MaxValue"),
                        rs.getInt("Usage_limit"),
                        rs.getInt("Usage_count"),
                        rs.getBoolean("Status"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 📌 Add a new voucher
    public void addVoucher(Voucher v) {
        String query = "INSERT INTO vouchers (Code, MinOrder, DiscountRate, MaxValue, Usage_limit, Usage_count, Status, StartDate, EndDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, generateUniqueCode());
            stmt.setInt(2, v.getMinOrder());
            stmt.setInt(3, v.getDiscountRate());
            stmt.setInt(4, v.getMaxValue());
            stmt.setInt(5, v.getUsage_limit());
            stmt.setInt(6, v.getUsage_count());
            stmt.setBoolean(7, v.getStatus());
            stmt.setDate(8, new java.sql.Date(v.getStartDate().getTime()));
            stmt.setDate(9, new java.sql.Date(v.getEndDate().getTime()));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🟡 Update voucher
    public void updateVoucher(Voucher v) {
        String query = "UPDATE vouchers SET Code = ?, MinOrder = ?, DiscountRate = ?, MaxValue = ?, Usage_limit = ?, Usage_count = ?, Status = ?, StartDate = ?, EndDate = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, v.getCode());
            stmt.setInt(2, v.getMinOrder());
            stmt.setInt(3, v.getDiscountRate());
            stmt.setInt(4, v.getMaxValue());
            stmt.setInt(5, v.getUsage_limit());
            stmt.setInt(6, v.getUsage_count());
            stmt.setBoolean(7, v.getStatus());
            stmt.setDate(8, new java.sql.Date(v.getStartDate().getTime()));
            stmt.setDate(9, new java.sql.Date(v.getEndDate().getTime()));
            stmt.setInt(10, v.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔄 Delete voucher
    public void deleteVoucher(int id) {
        String query = "DELETE FROM vouchers WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔢 Generate a unique voucher code
    public String generateUniqueCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random = new Random();
        String code;
        do {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 10; i++) {
                sb.append(chars.charAt(random.nextInt(chars.length())));
            }
            code = sb.toString();
        } while (isCodeExists(code));
        return code;
    }

    // 🛑 Check if the code already exists
    public boolean isCodeExists(String code) {
        String query = "SELECT COUNT(*) FROM vouchers WHERE Code = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isCodeExistsForOtherVoucher(String code, int voucherId) {
    String query = "SELECT COUNT(*) FROM vouchers WHERE Code = ? AND ID != ?";
    try (PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, code);
        stmt.setInt(2, voucherId);
        ResultSet rs = stmt.executeQuery();
        return rs.next() && rs.getInt(1) > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
}
