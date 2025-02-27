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
                                <form action="ProductsControllerURL" method="post" class="w-100">
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
                                        <label for="price" class="form-label">Price</label>
                                        <input type="number" class="form-control" id="price" name="price" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="stockQuantity" class="form-label">Stock Quantity</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label">Image</label>
                                        <input type="text" class="form-control" id="imageURL" name="imageURL" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="category" class="form-label">Category</label>
                                        <select class="form-control" id="category" name="categoryId">
                                            <!-- Add categories dynamically from the database -->
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
                                            <th scope="col">Price</th>
                                            <th scope="col">Stock</th>
                                            <th scope="col">Status</th>
                                            <th scope="col" style="text-align: center;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            // Retrieve the 'data' attribute passed from the controller
                                            Vector<Product> productList = (Vector<Product>) request.getAttribute("data");
                                            if (productList != null && !productList.isEmpty()) {
                                                // Iterate over each product
                                                for (Product p : productList) {
                                                    Category category = p.getCategory(); // Get the associated category
                                        %>
                                        <tr>
                                            <td>
                                                <img src="<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>" 
                                                     alt="Product Image" class="img-thumbnail" style="width: 60px; height: 60px;">
                                            </td>
                                            <td><%= p.getProductCode() %></td>
                                            <td><%= p.getProductName() %></td>
                                            <td><%= category != null ? category.getCategoryName() : "N/A" %></td> <!-- Display Category Name -->
                                            <td><%= String.format("%,d", p.getPrice()) %> VNĐ</td>
                                            <td><%= p.getStockQuantity() %></td>
                                            <td>
                                                <span class="badge <%= p.isIsAvailable() ? "bg-success" : "bg-danger" %>">
                                                    <%= p.isIsAvailable() ? "Available" : "Out of Stock" %>
                                                </span>
                                            </td>
                                            <td style="text-align: center;">
                                                <a class="btn btn-outline-warning btn-sm" href="ProductsControllerURL?service=edit&id=<%= p.getId() %>">Edit</a>
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
    </body>
</html>
