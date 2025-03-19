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
                    <div class="col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Bộ lọc</h5>
                                <form action="ProductsControllerURL" method="get">
                                    <input type="hidden" name="service" value="listAll"> 

                                    <div class="mb-3">
                                        <label for="categoryId" class="form-label">Loại hàng</label>
                                        <select class="form-control" id="categoryId" name="categoryId">
                                            <option value="">Tất cả</option>
                                            <%
                                                Vector<Category> categories = (Vector<Category>) request.getAttribute("categories");
                                                if (categories != null) {
                                                    for (Category cat : categories) {
                                            %>
                                            <option value="<%= cat.getCategoryID() %>"><%= cat.getCategoryName() %></option>
                                            <%
                                                    }
                                                }
                                            %>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label for="stockStatus" class="form-label">Tồn kho</label>
                                        <select class="form-control" id="stockStatus" name="stockStatus">
                                            <option value="">Tất cả</option>
                                            <option value="outofstock">Hết hàng</option>
                                            <option value="inStock">Còn hàng</option>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary">Lọc sản phẩm</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- Product List Table -->
                    <div class="col-lg-10">
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
                                                <a href="#" data-bs-toggle="modal" data-bs-target="#productDetailModal" 
                                                   onclick="showProductDetail('<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>',
                                                                   '<%= p.getProductCode() %>',
                                                                   '<%= p.getProductName() %>',
                                                                   '<%= category != null ? category.getCategoryName() : "N/A" %>',
                                                                   '<%= String.format("%,d", p.getPrice()) %>',
                                                                   '<%= p.getStockQuantity() %>',
                                                                   '<%= p.getStockQuantity() == 0 ? "Hết hàng" : (p.isIsAvailable() ? "Còn hàng" : "Ngừng bán") %>')">
                                                    <img src="<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>" 
                                                         alt="Product Image" class="img-thumbnail" style="width: 60px; height: 60px;">
                                                </a>
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
                                                <a class="btn btn-warning btn-sm" href="ProductsControllerURL?service=edit&id=<%= p.getId() %>">Sửa</a>
                                                <a class="btn btn-primary btn-sm" href="ProductsControllerURL?service=stopsell&id=<%= p.getId() %>"
                                                   onclick="return confirm('Bạn có chắc chắn muốn Ngừng Bán sản phẩm mã: <%= p.getProductCode() %>?')">Ngừng bán</a>
                                                <a class="btn btn-success btn-sm" href="ProductsControllerURL?service=resumesell&id=<%= p.getId() %>"
                                                   onclick="return confirm('Bạn có chắc chắn muốn Tiếp Tục Bán sản phẩm mã: <%= p.getProductCode() %>?')">Tiếp tục bán</a>
                                                <a class="btn btn-danger btn-sm" href="ProductsControllerURL?service=delete&id=<%= p.getId() %>" 
                                                   onclick="return confirm('Bạn có chắc chắn Xóa bỏ Sản phẩm không?')">Hủy bỏ</a>
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
