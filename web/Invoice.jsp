<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="entity.CartItem" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hóa Đơn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .top-bar {
            background-color: #007bff;
            color: white;
            padding: 10px;
        }
        .invoice-container {
            background-color: white;
            padding: 15px;
            border-radius: 5px;
            max-width: 600px;
            margin: auto;
            margin-top: 20px;
        }
        .btn-home {
            background: none;
            border: none;
            font-size: 20px;
            color: white;
            cursor: pointer;
        }
        .table th, .table td {
            text-align: center;
        }
    </style>
</head>
<body>

    <!-- Thanh menu -->
    <div class="top-bar d-flex justify-content-between">
        <button class="btn-home" onclick="window.location.href='ProductController'">
            <i class="fas fa-home"></i>
        </button>
        <span>0987654321</span>
        <i class="fas fa-bars menu-icon"></i>
    </div>

    <div class="invoice-container">
        <h5 class="text-center">HÓA ĐƠN</h5>
        <p><strong>Nhân viên:</strong> Admin</p>
        <p><strong>Thời gian:</strong> 
            <%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date()) %>
        </p>

        <hr>
        <p><strong>Khách lẻ</strong></p>

        <!-- Hiển thị danh sách sản phẩm trong giỏ hàng -->
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
                    int totalAmount = 0;
                    if (cart != null && !cart.isEmpty()) {
                        for (CartItem item : cart.values()) {
                            int itemTotal = item.getProduct().getUnitPrice() * item.getQuantity();
                            totalAmount += itemTotal;
                %>
                <tr>
                    <td><%= item.getProduct().getProductName() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= itemTotal %> VND</td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr>
                    <td colspan="3" class="text-center text-danger">Giỏ hàng trống.</td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <p><strong>Tổng tiền hàng:</strong> <%= totalAmount %> VND</p>
        <p><strong>Mã giảm giá:</strong></p>
        <p><strong>Khách cần trả:</strong> <%= totalAmount %> VND</p>

        <p><strong>Khách thanh toán:</strong></p>
        <input type="radio" name="paymentMethod" checked> Tiền mặt
        <input type="radio" name="paymentMethod"> Chuyển khoản

        <button class="btn btn-primary w-100 mt-3">Xác nhận thanh toán</button>
    </div>

</body>
</html>
