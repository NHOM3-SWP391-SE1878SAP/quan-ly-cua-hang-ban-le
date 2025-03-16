package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import database.DatabaseConnection;
import entity.SalesReport;

public class SalesReportDAO {
    private Connection conn;

    // Constructor nhận kết nối từ DatabaseConnection
    public SalesReportDAO() {
        this.conn = new DatabaseConnection().getConnection();
    }

    public List<SalesReport> getSalesData(String filter) {
        List<SalesReport> salesList = new ArrayList<>();
        String sql = "SELECT OrderDate, SUM(TotalAmount) AS Revenue FROM Orders WHERE 1=1 ";

        // Thêm điều kiện lọc theo thời gian
        switch (filter) {
            case "today":
                sql += " AND OrderDate = CAST(GETDATE() AS DATE)";
                break;
            case "yesterday":
                sql += " AND OrderDate = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)";
                break;
            case "last7days":
                sql += " AND OrderDate >= CAST(DATEADD(DAY, -7, GETDATE()) AS DATE)";
                break;
            case "thismonth":
                sql += " AND MONTH(OrderDate) = MONTH(GETDATE()) AND YEAR(OrderDate) = YEAR(GETDATE())";
                break;
            case "lastmonth":
                sql += " AND MONTH(OrderDate) = MONTH(DATEADD(MONTH, -1, GETDATE())) "
                        + "AND YEAR(OrderDate) = YEAR(DATEADD(MONTH, -1, GETDATE()))";
                break;
        }

        sql += " GROUP BY OrderDate ORDER BY OrderDate";

        System.out.println("Executing SQL: " + sql); // Kiểm tra câu lệnh SQL
        
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                SalesReport report = new SalesReport();
                report.setDate(rs.getDate("OrderDate"));
                report.setRevenue(rs.getObject("Revenue") != null ? rs.getDouble("Revenue") : 0.0);
                salesList.add(report);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return salesList;
    }
    public static void main(String[] args) {
        SalesReportDAO dao = new SalesReportDAO();
        
        // Chọn bộ lọc, có thể đổi thành: "today", "yesterday", "last7days", "thismonth", "lastmonth"
        String filter = "thismonth";
        
        System.out.println("🔍 Đang lấy dữ liệu doanh thu với bộ lọc: " + filter);
        List<SalesReport> salesData = dao.getSalesData(filter);

        // Kiểm tra xem dữ liệu có được lấy ra không
        if (salesData.isEmpty()) {
            System.out.println("⚠️ Không có dữ liệu!");
        } else {
            System.out.println("✅ Dữ liệu doanh thu:");
            for (SalesReport report : salesData) {
                System.out.println("📅 Ngày: " + report.getDate() + " | 💰 Doanh thu: " + report.getRevenue());
            }
        }
    }
}
