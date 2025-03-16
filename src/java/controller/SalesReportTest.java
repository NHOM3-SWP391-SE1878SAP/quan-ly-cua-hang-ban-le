package controller;

import dao.SalesReportDAO;
import entity.SalesReport;
import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.List;

public class SalesReportTest {
    public static void main(String[] args) {
        String filter = "lastmonth"; // Có thể thay đổi thành today, yesterday, last7days, thismonth, lastmonth

        SalesReportDAO salesDAO = new SalesReportDAO();
        List<SalesReport> salesData = salesDAO.getSalesData(filter);

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd");

        // ✅ Tính tổng doanh thu
        double totalRevenue = salesData.stream().mapToDouble(SalesReport::getRevenue).sum();

        // ✅ Định dạng số tiền có dấu phẩy ngăn cách hàng nghìn
        DecimalFormat decimalFormat = new DecimalFormat("#,###");
        String formattedTotalRevenue = decimalFormat.format(totalRevenue) + " VND";

        // ✅ Tạo JSON object chứa tổng doanh thu và dữ liệu doanh thu theo ngày
        JSONObject result = new JSONObject();
        result.put("totalRevenue", formattedTotalRevenue);

        JSONArray jsonArray = new JSONArray();
        for (SalesReport report : salesData) {
            JSONObject obj = new JSONObject();
            obj.put("date", dateFormat.format(report.getDate())); // Chỉ lấy ngày
            obj.put("revenue", report.getRevenue());
            jsonArray.put(obj);
        }

        result.put("salesData", jsonArray);

        // ✅ Debug dữ liệu đầu ra
        System.out.println("=== DỮ LIỆU TEST ===");
        System.out.println(result.toString(4)); // In JSON đẹp hơn
    }
}
