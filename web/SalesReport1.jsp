<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="entity.Order1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo Cáo Bán Hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .report-container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .report-title {
            font-size: 24px;
            font-weight: bold;
        }
        .summary-card {
            background-color: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .summary-title {
            font-size: 16px;
            color: #6c757d;
        }
        .summary-value {
            font-size: 24px;
            font-weight: bold;
            color: #007bff;
        }
        .chart-container {
            height: 300px;
            margin-bottom: 20px;
        }
        .table-container {
            margin-top: 20px;
        }
        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 5px;
            border-bottom: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <%@ include file="HeaderAdmin.jsp" %>
    
    <div class="container" style="margin-left: 300px; margin-top: 70px;">
        <div class="report-container">
            <div class="report-header">
                <div class="report-title">Báo Cáo Bán Hàng</div>
                <div>
                    <%
                        Date reportDate = (Date) request.getAttribute("reportDate");
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        String dateStr = sdf.format(reportDate);
                    %>
                    <form action="SalesReport" method="get" class="d-flex">
                        <input type="date" name="date" class="form-control me-2" value="<%= dateStr %>">
                        <button type="submit" class="btn btn-primary me-2">Xem báo cáo</button>
                        <a href="SalesReport1?action=exportPDF&date=<%= dateStr %>" class="btn btn-success">
                            <i class="fas fa-file-pdf me-1"></i> Xuất PDF
                        </a>
                    </form>
                </div>
            </div>
            
            <div class="row">
                <%
                    int totalRevenue = (Integer) request.getAttribute("totalRevenue");
                    int orderCount = (Integer) request.getAttribute("orderCount");
                    DecimalFormat formatter = new DecimalFormat("#,###");
                %>
                <div class="col-md-6">
                    <div class="summary-card">
                        <div class="summary-title">Tổng doanh thu</div>
                        <div class="summary-value"><%= formatter.format(totalRevenue) %> VND</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="summary-card">
                        <div class="summary-title">Số đơn hàng</div>
                        <div class="summary-value"><%= orderCount %></div>
                    </div>
                </div>
            </div>
            
            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="section-title">Top sản phẩm bán chạy</div>
                    <div class="table-container">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Mã SP</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Map<String, Object>> topProducts = (List<Map<String, Object>>) request.getAttribute("topProducts");
                                    if (topProducts != null && !topProducts.isEmpty()) {
                                        for (Map<String, Object> product : topProducts) {
                                %>
                                <tr>
                                    <td><%= product.get("productCode") %></td>
                                    <td><%= product.get("productName") %></td>
                                    <td><%= product.get("totalQuantity") %></td>
                                    <td><%= formatter.format(product.get("totalRevenue")) %> VND</td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="4" class="text-center">Không có dữ liệu</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
            <div class="row mt-4">
                <div class="col-12">
                    <div class="section-title">Danh sách đơn hàng</div>
                    <div class="table-container">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Thời gian</th>
                                    <th>Khách hàng</th>
                                    <th>Nhân viên</th>
                                    <th>Phương thức thanh toán</th>
                                    <th>Tổng tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Order1> orders = (List<Order1>) request.getAttribute("orders");
                                    if (orders != null && !orders.isEmpty()) {
                                        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
                                        for (Order1 order : orders) {
                                %>
                                <tr>
                                    <td><%= order.getOrderID() %></td>
                                    <td><%= timeFormat.format(order.getOrderDate()) %></td>
                                    <td>
                                        <% if (order.getCustomer() != null && order.getCustomer().getCustomerName() != null) { %>
                                            <%= order.getCustomer().getCustomerName() %>
                                        <% } else { %>
                                            Khách lẻ
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (order.getEmployee() != null && order.getEmployee().getEmployeeName() != null) { %>
                                            <%= order.getEmployee().getEmployeeName() %>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (order.getPayment() != null && order.getPayment().getPaymentMethods() != null) { %>
                                            <%= order.getPayment().getPaymentMethods() %>
                                        <% } %>
                                    </td>
                                    <td><%= formatter.format(order.getTotalAmount()) %> VND</td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center">Không có đơn hàng nào</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 