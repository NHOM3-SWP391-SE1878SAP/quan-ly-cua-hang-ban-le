package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.SalesReportDAO;
import entity.SalesReport;
import java.text.SimpleDateFormat;
import java.text.DecimalFormat;

@WebServlet("/SalesReportServlet")
public class SalesReportServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        // Nhận giá trị bộ lọc từ request (mặc định là "lastmonth")
        String filter = request.getParameter("filter");
        if (filter == null || filter.isEmpty()) {
            filter = "lastmonth";
        }

        SalesReportDAO salesDAO = new SalesReportDAO();
        List<SalesReport> salesData = salesDAO.getSalesData(filter);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd");

        double totalRevenue = salesData.stream().mapToDouble(SalesReport::getRevenue).sum();

        // ✅ Định dạng tổng doanh thu thành số nguyên có dấu phân cách hàng nghìn
        DecimalFormat decimalFormat = new DecimalFormat("#,###");
        String formattedTotalRevenue = decimalFormat.format(totalRevenue);
        // Tạo JSON object chứa tổng doanh thu và dữ liệu hàng ngày
        JSONObject result = new JSONObject();
        result.put("totalRevenue", formattedTotalRevenue);
        JSONArray jsonArray = new JSONArray();
        for (SalesReport report : salesData) {
            JSONObject obj = new JSONObject();
            obj.put("date", dateFormat.format(report.getDate()));
            obj.put("revenue", report.getRevenue());
            jsonArray.put(obj);
        }
        result.put("salesData", jsonArray);

        out.print(result.toString());

        out.flush();
    }
}
