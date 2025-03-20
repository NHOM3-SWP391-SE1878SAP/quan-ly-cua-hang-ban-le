<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>
<%@page import="entity.Category"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Sản Phẩm</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Danh sách sản phẩm theo loại hàng</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="CategoryControllerURL?service=listAll">Quản lý loại hàng</a></li>
                        <li class="breadcrumb-item active">Sản phẩm theo loại hàng</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div>
                        <div class="card">
                            <div class="card-body">
                                <% 
                                    Category category = (Category) request.getAttribute("category");
                                    if (category != null) {
                                %>
                                <div class="row">
                                    <div class="col-lg-4">
                                        <div class="row">
                                            <h5 class="card-title" style="text-align: center;">Ảnh loại hàng</h5>
                                        </div>
                                        <div class="row">
                                            <div style="text-align: center;">
                                                <img src="<%= category.getImage() != null && !category.getImage().isEmpty() ? category.getImage() : "assets/img/no-image.png" %>" 
                                                     alt="Category Image" class="img-thumbnail" style="width: 200px; height: 200px;">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-lg-8">
                                        <div class="row">
                                            <h5 class="card-title">Thông tin loại hàng</h5>
                                        </div>
                                        <div class="row">
                                            <div style="margin-bottom: 5px">Loại hàng: <%= category.getCategoryName() %></div>
                                            <div style="margin-bottom: 5px">Mô tả: <%= category.getDescription() %></div>
                                        </div>
                                    </div>
                                </div>
                                <% 
                                    } else {
                                %>
                                <p class="text-danger">Không có thông tin loại hàng.</p>
                                <% } %>
                                <a href="CategoryControllerURL?service=listAll" class="btn btn-secondary mt-3">Quay về</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <% 
                        Vector<Product> productList = (Vector<Product>) request.getAttribute("data");
                        if (productList != null && !productList.isEmpty()) {
                            for (Product p : productList) {
                    %>
                    <div class="col-md-3 mb-3">
                        <div class="card" style="height: 350px" href="#" data-bs-toggle="modal" data-bs-target="#productDetailModal" 
                                                   onclick="showProductDetail('<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>',
                                                                   '<%= p.getProductCode() %>',
                                                                   '<%= p.getProductName() %>',
                                                                   '<%= category != null ? category.getCategoryName() : "N/A" %>',
                                                                   '<%= String.format("%,d", p.getPrice()) %>',
                                                                   '<%= p.getStockQuantity() %>',
                                                                   '<%= p.getStockQuantity() == 0 ? "Hết hàng" : (p.isIsAvailable() ? "Còn hàng" : "Ngừng bán") %>')">
                            <img src="<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>" 
                                 class="card-img-top" alt="Product Image" style="height: 200px; object-fit: contain; margin-top: 20px">
                            <div class="card-body">
                                <h5 class="card-title"><%= p.getProductName() %></h5>
                                <p class="card-text">Giá bán: <%= String.format("%,d", p.getPrice()) %> VNĐ</p>
                            </div>
                        </div>
                    </div>
                    <% 
                        }
                        } else {
                    %>
                    <div class="col-12 text-center text-danger">
                        Không có sản phẩm trong danh mục này!
                    </div>
                    <% } %>
                </div>
            </section>
        </main>
        <!-- Modal Chi Tiết Sản Phẩm -->
        <div class="modal fade" id="productDetailModal" tabindex="-1" aria-labelledby="productDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="productDetailModalLabel">Chi Tiết Sản Phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-4">
                                <img id="productImage" class="img-fluid" alt="Product Image">
                            </div>
                            <div class="col-md-8">
                                <p><strong>Mã hàng:</strong> <span id="productCode"></span></p>
                                <p><strong>Tên hàng:</strong> <span id="productName"></span></p>
                                <p><strong>Loại hàng:</strong> <span id="productCategory"></span></p>
                                <p><strong>Giá bán:</strong> <span id="productPrice"></span></p>
                                <p><strong>Tồn kho:</strong> <span id="productStock"></span></p>
                                <p><strong>Trạng thái:</strong> <span id="productStatus"></span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/main.js"></script>
        <script>
            function showProductDetail(image, code, name, category, price, stock, status) {
                // Set values into modal
                document.getElementById("productImage").src = image;
                document.getElementById("productCode").innerText = code;
                document.getElementById("productName").innerText = name;
                document.getElementById("productCategory").innerText = category;
                document.getElementById("productPrice").innerText = price + " VNĐ";
                document.getElementById("productStock").innerText = stock;
                document.getElementById("productStatus").innerText = status;
            }
        </script>
    </body>
</html>
