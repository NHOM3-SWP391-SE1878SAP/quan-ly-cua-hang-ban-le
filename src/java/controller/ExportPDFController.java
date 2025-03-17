package controller;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import entity.Order;
import java.io.IOException;
import java.text.DecimalFormat;
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

@WebServlet(name = "ExportPDFController", urlPatterns = {"/ExportPDF"})
public class ExportPDFController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/pdf");
        request.setCharacterEncoding("UTF-8");
        
        String type = request.getParameter("type");
        if (type == null || !type.equals("sales")) {
            response.sendRedirect("SalesReport");
            return;
        }
        
        Date reportDate = getReportDate(request);
        String fileName = "BaoCaoBanHang_" + formatDate(reportDate) + ".pdf";
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        try {
            // Tạo document
            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();
            
            // Thêm font chữ hỗ trợ tiếng Việt
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
            
            // Tiêu đề báo cáo
            Paragraph title = new Paragraph("BÁO CÁO BÁN HÀNG NGÀY " + formatDateDisplay(reportDate), titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // Lấy dữ liệu báo cáo
            DAOSales daoSales = new DAOSales();
            int totalRevenue = daoSales.getTotalRevenueByDate(reportDate);
            int orderCount = daoSales.getOrderCountByDate(reportDate);
            
            // Thông tin tổng quan
            Paragraph summary = new Paragraph("THÔNG TIN TỔNG QUAN", headerFont);
            summary.setSpacingAfter(10);
            document.add(summary);
            
            PdfPTable summaryTable = new PdfPTable(2);
            summaryTable.setWidthPercentage(100);
            
            addTableCell(summaryTable, "Tổng số đơn hàng:", normalFont);
            addTableCell(summaryTable, String.valueOf(orderCount), normalFont);
            
            addTableCell(summaryTable, "Tổng doanh thu:", normalFont);
            addTableCell(summaryTable, formatCurrency(totalRevenue) + " VND", normalFont);
            
            document.add(summaryTable);
            document.add(new Paragraph("\n"));
            
            // Top sản phẩm bán chạy
            Paragraph topProductsTitle = new Paragraph("TOP SẢN PHẨM BÁN CHẠY", headerFont);
            topProductsTitle.setSpacingAfter(10);
            document.add(topProductsTitle);
            
            List<Map<String, Object>> topProducts = daoSales.getTopSellingProductsByDate(reportDate, 10);
            
            if (topProducts.isEmpty()) {
                document.add(new Paragraph("Không có dữ liệu sản phẩm bán ra trong ngày.", normalFont));
            } else {
                PdfPTable topProductsTable = new PdfPTable(4);
                topProductsTable.setWidthPercentage(100);
                
                // Header
                addTableHeaderCell(topProductsTable, "Mã sản phẩm", headerFont);
                addTableHeaderCell(topProductsTable, "Tên sản phẩm", headerFont);
                addTableHeaderCell(topProductsTable, "Số lượng", headerFont);
                addTableHeaderCell(topProductsTable, "Doanh thu", headerFont);
                
                // Data
                for (Map<String, Object> product : topProducts) {
                    addTableCell(topProductsTable, (String) product.get("productCode"), normalFont);
                    addTableCell(topProductsTable, (String) product.get("productName"), normalFont);
                    addTableCell(topProductsTable, String.valueOf(product.get("totalQuantity")), normalFont);
                    addTableCell(topProductsTable, formatCurrency((Integer) product.get("totalRevenue")) + " VND", normalFont);
                }
                
                document.add(topProductsTable);
            }
            
            document.add(new Paragraph("\n"));
            
            // Doanh thu theo giờ
            Paragraph hourlyRevenueTitle = new Paragraph("DOANH THU THEO GIỜ", headerFont);
            hourlyRevenueTitle.setSpacingAfter(10);
            document.add(hourlyRevenueTitle);
            
            Map<Integer, Integer> hourlyRevenue = daoSales.getRevenueByHourOfDay(reportDate);
            
            PdfPTable hourlyRevenueTable = new PdfPTable(4);
            hourlyRevenueTable.setWidthPercentage(100);
            
            // Header
            addTableHeaderCell(hourlyRevenueTable, "Giờ", headerFont);
            addTableHeaderCell(hourlyRevenueTable, "Doanh thu", headerFont);
            addTableHeaderCell(hourlyRevenueTable, "Giờ", headerFont);
            addTableHeaderCell(hourlyRevenueTable, "Doanh thu", headerFont);
            
            // Data
            for (int i = 0; i < 12; i++) {
                addTableCell(hourlyRevenueTable, i + ":00 - " + (i + 1) + ":00", normalFont);
                addTableCell(hourlyRevenueTable, formatCurrency(hourlyRevenue.get(i)) + " VND", normalFont);
                addTableCell(hourlyRevenueTable, (i + 12) + ":00 - " + ((i + 13) % 24) + ":00", normalFont);
                addTableCell(hourlyRevenueTable, formatCurrency(hourlyRevenue.get(i + 12)) + " VND", normalFont);
            }
            
            document.add(hourlyRevenueTable);
            document.add(new Paragraph("\n"));
            
            // Danh sách đơn hàng
            Paragraph ordersTitle = new Paragraph("DANH SÁCH ĐƠN HÀNG", headerFont);
            ordersTitle.setSpacingAfter(10);
            document.add(ordersTitle);
            
            List<Order> orders = daoSales.getOrdersByDate(reportDate);
            
            if (orders.isEmpty()) {
                document.add(new Paragraph("Không có đơn hàng nào trong ngày.", normalFont));
            } else {
                PdfPTable ordersTable = new PdfPTable(5);
                ordersTable.setWidthPercentage(100);
                
                // Header
                addTableHeaderCell(ordersTable, "Mã đơn hàng", headerFont);
                addTableHeaderCell(ordersTable, "Thời gian", headerFont);
                addTableHeaderCell(ordersTable, "Khách hàng", headerFont);
                addTableHeaderCell(ordersTable, "Nhân viên", headerFont);
                addTableHeaderCell(ordersTable, "Tổng tiền", headerFont);
                
                // Data
                SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
                for (Order order : orders) {
                    addTableCell(ordersTable, String.valueOf(order.getOrderID()), normalFont);
                    addTableCell(ordersTable, timeFormat.format(order.getOrderDate()), normalFont);
                    
                    String customerName = "Khách lẻ";
                    if (order.getCustomer() != null && order.getCustomer().getCustomerName() != null) {
                        customerName = order.getCustomer().getCustomerName();
                    }
                    addTableCell(ordersTable, customerName, normalFont);
                    
                    String employeeName = "";
                    if (order.getEmployee() != null && order.getEmployee().getEmployeeName() != null) {
                        employeeName = order.getEmployee().getEmployeeName();
                    }
                    addTableCell(ordersTable, employeeName, normalFont);
                    
                    addTableCell(ordersTable, formatCurrency(order.getTotalAmount()) + " VND", normalFont);
                }
                
                document.add(ordersTable);
            }
            
            // Chân trang
            Paragraph footer = new Paragraph("Báo cáo được tạo vào: " + new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()), normalFont);
            footer.setAlignment(Element.ALIGN_RIGHT);
            footer.setSpacingBefore(20);
            document.add(footer);
            
            document.close();
            
        } catch (DocumentException e) {
            System.out.println("Error creating PDF: " + e.getMessage());
            response.sendRedirect("SalesReport");
        }
    }
    
    private void addTableHeaderCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(5);
        table.addCell(cell);
    }
    
    private void addTableCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setPadding(5);
        table.addCell(cell);
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
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        return sdf.format(date);
    }
    
    private String formatDateDisplay(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        return sdf.format(date);
    }
    
    private String formatCurrency(int amount) {
        DecimalFormat formatter = new DecimalFormat("#,###");
        return formatter.format(amount);
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
        return "Export PDF Controller";
    }
} 