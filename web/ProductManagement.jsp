<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>
<%@page import="entity.Category"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý sản phẩm</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Quản lý sản phẩm</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Products</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    
                    <a href="AddProduct.jsp" class="btn btn-primary mb-3">Thêm sản phẩm</a>

                    <!-- Product List Table -->
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Danh sách sản phẩm</h5>
                                <table class="table table-borderless datatable mt-3">
                                    <thead>
                                        <tr>
                                            <th scope="col">Ảnh</th>
                                            <th scope="col">Mã hàng</th>
                                            <th scope="col">Tên hàng</th>
                                            <th scope="col">Loại hàng</th>
                                            <th scope="col">Giá bán (VNĐ)</th>
                                            <th scope="col">Tồn kho</th>
                                            <th scope="col">Trạng thái</th>
                                            <th scope="col" style="text-align: center;">Cập nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Vector<Product> productList = (Vector<Product>) request.getAttribute("data");
                                            if (productList != null && !productList.isEmpty()) {
                                                for (Product p : productList) {
                                                    Category category = p.getCategory();
                                        %>
                                        <tr>
                                            <td>
                                                <img src="<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>" 
                                                     alt="Product Image" class="img-thumbnail" style="width: 60px; height: 60px;">
                                            </td>
                                            <td><%= p.getProductCode() %></td>
                                            <td><%= p.getProductName() %></td>
                                            <td><%= category != null ? category.getCategoryName() : "N/A" %></td>
                                            <td><%= String.format("%,d", p.getPrice()) %></td>
                                            <td><%= p.getStockQuantity() %></td>
                                            <td>
                                                <span class="badge
                                                      <%= p.getStockQuantity() == 0 ? "bg-danger" : (p.isIsAvailable() ? "bg-success" : "bg-secondary") %>">
                                                    <%= p.getStockQuantity() == 0 ? "Out of Stock" : (p.isIsAvailable() ? "Available" : "Stop Sell") %>
                                                </span>
                                            </td>
                                            <td style="text-align: center;">
                                                <a class="btn btn-outline-warning btn-sm" href="ProductsControllerURL?service=edit&id=<%= p.getId() %>">Edit</a>
                                                <a class="btn btn-outline-primary btn-sm" href="ProductsControllerURL?service=stopsell&id=<%= p.getId() %>"
                                                   onclick="return confirm('Are you sure you want to stop sell this <%= p.getProductCode() %> product?')">Stop Sell</a>
                                                <a class="btn btn-outline-success btn-sm" href="ProductsControllerURL?service=resumesell&id=<%= p.getId() %>"
                                                   onclick="return confirm('Are you sure you want to resume sell this <%= p.getProductCode() %> product?')">Resume Sell</a>
                                                <a class="btn btn-outline-danger btn-sm" href="ProductsControllerURL?service=delete&id=<%= p.getId() %>" 
                                                   onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="8" class="text-center text-danger">Không có mặt hàng nào!</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
        <script src="assets/js/main.js"></script>

        <script>
                                                       function validateForm() {
                                                           let productName = document.getElementById("productName").value.trim();
                                                           let productCode = document.getElementById("productCode").value.trim();
                                                           let price = document.getElementById("price").value;
                                                           let stockQuantity = document.getElementById("stockQuantity").value;

                                                           if (productName.length < 3) {
                                                               alert("Product Name must be at least 3 characters long.");
                                                               return false;
                                                           }
                                                           if (!/^[A-Z0-9]+$/.test(productCode)) {
                                                               alert("Product Code must contain only uppercase letters and numbers.");
                                                               return false;
                                                           }
                                                           return true;
                                                       }
        </script>
    </body>
</html>
