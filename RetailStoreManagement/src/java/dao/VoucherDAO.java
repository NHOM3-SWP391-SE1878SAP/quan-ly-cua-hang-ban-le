package dao;

import database.DatabaseConnection;
import model.Voucher;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class VoucherDAO {
    private DatabaseConnection dbConnection = new DatabaseConnection(); // Sử dụng kết nối đúng cách

    public void addVoucher(Voucher voucher) {
        String sql = "INSERT INTO Vouchers (Code, MinOrder, DiscountRate, MaxValue, StartDate, EndDate) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String uniqueCode = generateUniqueVoucherCode(); // Sinh mã code không trùng lặp
            stmt.setString(1, uniqueCode);
            stmt.setDouble(2, voucher.getMinOrder());
            stmt.setFloat(3, voucher.getDiscountRate());
            stmt.setDouble(4, voucher.getMaxValue());
            stmt.setTimestamp(5, Timestamp.valueOf(voucher.getStartDate()));
            stmt.setTimestamp(6, Timestamp.valueOf(voucher.getEndDate()));
            stmt.executeUpdate();
            System.out.println("✅ Voucher đã được thêm với mã: " + uniqueCode);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers";
        try (Connection conn = dbConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                vouchers.add(new Voucher(
                        rs.getInt("ID"),
                        rs.getString("Code"),
                        rs.getDouble("MinOrder"),
                        rs.getFloat("DiscountRate"),
                        rs.getDouble("MaxValue"),
                        rs.getTimestamp("StartDate").toLocalDateTime(),
                        rs.getTimestamp("EndDate").toLocalDateTime()
                ));
            }
            System.out.println("✅ Lấy " + vouchers.size() + " voucher từ database.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vouchers;
    }

    public void deleteVoucher(int id) {
        String sql = "DELETE FROM Vouchers WHERE ID = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
            System.out.println("✅ Voucher với ID " + id + " đã bị xóa.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Kiểm tra xem mã Voucher đã tồn tại chưa
    public boolean checkIfCodeExists(String code) {
        String sql = "SELECT COUNT(*) FROM Vouchers WHERE Code = ?";
        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    // Tạo mã Voucher tự động và đảm bảo không trùng lặp
    public String generateUniqueVoucherCode() {
        String code;
        Random random = new Random();
        do {
            code = "VOUCHER-" + (random.nextInt(90000) + 10000); // Sinh mã từ VOUCHER-10000 đến VOUCHER-99999
        } while (checkIfCodeExists(code));
        return code;
    }
}
