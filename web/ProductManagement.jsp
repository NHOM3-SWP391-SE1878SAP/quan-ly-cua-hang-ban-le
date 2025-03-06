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
                <h1>Product Management</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Products</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <!-- Add New Product Form -->
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Add New Product</h5>

                                <!-- Hiển thị lỗi nếu có -->
                                <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
                                <% if (errorMessage != null) { %>
                                    <div class="alert alert-danger"><%= errorMessage %></div>
                                <% } %>

                                <form action="ProductsControllerURL" method="post" class="w-100" onsubmit="return validateForm()">
                                    <input type="hidden" name="service" value="addProduct">
                                    <div class="mb-3">
                                        <label for="productName" class="form-label">Product Name</label>
                                        <input type="text" class="form-control" id="productName" name="productName" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="productCode" class="form-label">Product Code</label>
                                        <input type="text" class="form-control" id="productCode" name="productCode" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Price (VNĐ)</label>
                                        <input type="number" class="form-control" id="price" name="price" min="0" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="stockQuantity" class="form-label">Stock Quantity</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" min="0" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label">Image</label>
                                        <input type="text" class="form-control" id="imageURL" name="imageURL" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="category" class="form-label">Category</label>
                                        <select class="form-control" id="category" name="categoryId" required>
                                            <option value="1">Electronics</option>
                                            <option value="2">Apparel</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Add Product</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Product List Table -->
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Product List</h5>
                                <table class="table table-borderless datatable mt-3">
                                    <thead>
                                        <tr>
                                            <th scope="col">Image</th>
                                            <th scope="col">Product Code</th>
                                            <th scope="col">Product Name</th>
                                            <th scope="col">Category</th>
                                            <th scope="col">Price (VNĐ)</th>
                                            <th scope="col">Stock</th>
                                            <th scope="col">Status</th>
                                            <th scope="col" style="text-align: center;">Actions</th>
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
                                                <span class="badge <%= p.getStockQuantity() > 0  ? "bg-success" : "bg-danger" %>">
                                                    <%= p.getStockQuantity() > 0 ? "Available" : "Out of Stock" %>
                                                </span>
                                            </td>
                                            <td style="text-align: center;">
                                                <a class="btn btn-outline-warning btn-sm" href="ProductsControllerURL?service=edit&id=<%= p.getId() %>">Edit</a>
                                                <a class="btn btn-outline-success btn-sm" href="ProductsControllerURL?service=detail&id=<%= p.getId() %>">Detail</a>
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
