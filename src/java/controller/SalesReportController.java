package controller;

import entity.Order;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DAOSales;

@WebServlet(name = "SalesReportController", urlPatterns = {"/SalesReport"})
public class SalesReportController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }
        
        DAOSales daoSales = new DAOSales();
        Date reportDate = getReportDate(request);
        
        switch (action) {
            case "view":
                // Lấy dữ liệu báo cáo
                List<Order> orders = daoSales.getOrdersByDate(reportDate);
                int totalRevenue = daoSales.getTotalRevenueByDate(reportDate);
                int orderCount = daoSales.getOrderCountByDate(reportDate);
                List<Map<String, Object>> topProducts = daoSales.getTopSellingProductsByDate(reportDate, 10);
                Map<Integer, Integer> hourlyRevenue = daoSales.getRevenueByHourOfDay(reportDate);
                
                // Đặt dữ liệu vào request
                request.setAttribute("reportDate", reportDate);
                request.setAttribute("orders", orders);
                request.setAttribute("totalRevenue", totalRevenue);
                request.setAttribute("orderCount", orderCount);
                request.setAttribute("topProducts", topProducts);
                request.setAttribute("hourlyRevenue", hourlyRevenue);
                
                // Chuyển hướng đến trang báo cáo
                request.getRequestDispatcher("SalesReport.jsp").forward(request, response);
                break;
                
            case "exportPDF":
                // Chuyển hướng đến servlet xuất PDF
                response.sendRedirect("ExportPDF?type=sales&date=" + formatDate(reportDate));
                break;
                
            default:
                response.sendRedirect("SalesReport");
                break;
        }
    }
    
    private Date getReportDate(HttpServletRequest request) {
        String dateStr = request.getParameter("date");
        Date date = new Date(); // Mặc định là ngày hiện tại
        
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                date = sdf.parse(dateStr);
            } catch (ParseException e) {
                System.out.println("Error parsing date: " + e.getMessage());
            }
        }
        
        return date;
    }
    
    private String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Sales Report Controller";
    }
} 