package dao;

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

    // ✅ Phân trang: Lấy danh sách vouchers theo trang
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
                        rs.getDate("StartDate").toLocalDate(),
                        rs.getDate("EndDate").toLocalDate()
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 📌 Lấy danh sách tất cả voucher
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
                        rs.getDate("StartDate").toLocalDate(),
                        rs.getDate("EndDate").toLocalDate()
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 🔍 Tìm kiếm voucher theo Code
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
                        rs.getDate("StartDate").toLocalDate(),
                        rs.getDate("EndDate").toLocalDate()
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    // 📌 Thêm mới voucher với mã tự động
    public void addVoucher(Voucher v) {
        String query = "INSERT INTO vouchers (Code, MinOrder, DiscountRate, MaxValue, StartDate, EndDate) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, generateUniqueCode());
            stmt.setInt(2, v.getMinOrder());
            stmt.setInt(3, v.getDiscountRate());
            stmt.setInt(4, v.getMaxValue());
            stmt.setDate(5, java.sql.Date.valueOf(v.getStartDate()));
            stmt.setDate(6, java.sql.Date.valueOf(v.getEndDate()));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🟡 Cập nhật thông tin voucher
    public void updateVoucher(Voucher v) {
        String query = "UPDATE vouchers SET Code = ?, MinOrder = ?, DiscountRate = ?, MaxValue = ?, StartDate = ?, EndDate = ? WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, v.getCode());
            stmt.setInt(2, v.getMinOrder());
            stmt.setInt(3, v.getDiscountRate());
            stmt.setInt(4, v.getMaxValue());
            stmt.setDate(5, java.sql.Date.valueOf(v.getStartDate()));
            stmt.setDate(6, java.sql.Date.valueOf(v.getEndDate()));
            stmt.setInt(7, v.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔄 Xóa voucher
    public void deleteVoucher(int id) {
        String query = "DELETE FROM vouchers WHERE ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔢 Tạo mã voucher ngẫu nhiên
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

    // 🛑 Kiểm tra mã có tồn tại chưa
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
}
