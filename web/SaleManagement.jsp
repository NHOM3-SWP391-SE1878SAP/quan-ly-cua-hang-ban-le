<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="entity.Product" %>
<%@ page import="entity.CartItem" %>
<!DOCTYPE html>
<html>     
    <head>         
        <meta charset="UTF-8">         
        <title>POS System</title>         
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">         
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">         
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
            .cart-container {
                background-color: white;
                padding: 15px;
                border-radius: 5px;
            }
            .cart-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 5px 0;
                padding: 10px;
                border-bottom: 1px solid #ddd;
            }
            .product-list {
                height: 500px;
                overflow-y: auto;
                margin-bottom: 10px;
            }
            .product-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 10px;
            }
            .product-grid-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 10px;
                border: 1px solid #ddd;
                cursor: pointer;
                text-align: center;
            }
            .product-image {
                width: 80px;
                height: auto;
                margin-bottom: 10px;
            }
            .cart-actions button {
                border: none;
                background: none;
                font-size: 16px;
                cursor: pointer;
                margin-left: 5px;
            }
        </style>

        <script>
            function addToCart(productId) {
                $.post("CartController", {action: "add", productId: productId}, function (data) {
                    $("#cart-items").html(data);
                    updateTotal();
                });
            }

            function updateCart(productId, actionType) {
                $.post("CartController", {action: actionType, productId: productId}, function (data) {
                    $("#cart-items").html(data);
                    updateTotal();
                });
            }

            function updateTotal() {
                $.get("CartController", {action: "getTotal"}, function (total) {
                    $("#totalAmount").text(total + " VND");
                });
            }
        </script>
    </head>     

    <body>         
        <div class="top-bar d-flex justify-content-end">             
            <div>                 
                <i class="fas fa-shopping-cart me-3"></i>                 
                <i class="fas fa-sync-alt me-3"></i>                 
                <i class="fas fa-print me-3"></i>                 
                <span>0385726162</span>                 
                <i class="fas fa-bars menu-icon ms-3"></i>             
            </div>         
        </div>          

        <div class="container mt-3">             
            <div class="row">                 
                <!-- Giỏ hàng bên trái -->                 
                <div class="col-md-6">                     
                    <div class="cart-container">                         
                        <h5>Giỏ hàng</h5>    

                        <!-- Ô tìm khách hàng -->
                        <input type="text" class="form-control mb-3" placeholder="Tìm khách hàng...">                     

                        <div id="cart-items">
                            <% 
                                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
                                if (cart != null && !cart.isEmpty()) {
                                    for (CartItem item : cart.values()) { 
                            %>
                            <div class="cart-item">
                                <span><%= item.getProduct().getProductName() %> (x<%= item.getQuantity() %>)</span>
                                <span><%= item.getProduct().getUnitPrice() * item.getQuantity() %> VND</span>
                                <div class="cart-actions">
                                    <button onclick="updateCart(<%= item.getProduct().getId() %>, 'decrease')">➖</button>
                                    <button onclick="updateCart(<%= item.getProduct().getId() %>, 'increase')">➕</button>
                                    <button onclick="updateCart(<%= item.getProduct().getId() %>, 'remove')">🗑️</button>
                                </div>
                            </div>
                            <% 
                                    }
                                } else { 
                            %>
                            <p class="text-danger">Giỏ hàng trống.</p>
                            <% } %>
                        </div>
                        <p>Tổng tiền hàng: <strong id="totalAmount">
                                <%= session.getAttribute("totalAmount") != null ? session.getAttribute("totalAmount") : "0" %> VND
                            </strong></p>                       

                        <button class="btn btn-primary w-100" onclick="window.location.href = 'Invoice.jsp'">THANH TOÁN</button>

                    </div>                 
                </div>                   

                <!-- Danh sách sản phẩm bên phải -->                 
                <div class="col-md-6">   
                    <div class="cart-container">    

                        <!-- Ô tìm sản phẩm -->
                        <input type="text" class="form-control mb-3" placeholder="Tìm sản phẩm...">    

                        <div class="product-list border p-2">                         
                            <div class="product-grid">                             
                                <%  
                                    Vector<Product> productList = (Vector<Product>) request.getAttribute("productList");
                                    if (productList != null && !productList.isEmpty()) {                                     
                                        for (Product product : productList) {                             
                                %>                                 
                                <div class="product-grid-item" onclick="addToCart(<%= product.getId() %>)">                                     
                                    <img src="<%= product.getImageURL() %>" alt="Ảnh sản phẩm" class="product-image">                                     
                                    <div class="product-info">
                                        <h6><%= product.getProductName() %></h6>                                     
                                        <p><%= product.getProductCode() %></p>                                     
                                        <p><%= product.getUnitPrice() %> VND</p>                                     
                                        <p>Số lượng còn lại: <strong><%= product.getStockQuantity() %></strong></p>                                 
                                    </div>
                                </div>                             
                                <% } } else { %>                                 
                                <p class="text-danger">Không có sản phẩm nào.</p>                             
                                <% } %>                         
                            </div>                     
                        </div>  
                    </div>               
                </div>             
            </div>         
        </div>  
    </body> 
</html>
