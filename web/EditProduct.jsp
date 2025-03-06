<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.Product"%>
<%@page import="entity.Category"%>
<%@page import="java.util.Vector"%>
<%@page import="model.DAOProduct"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Product</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Edit Product</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="ProductsControllerURL?service=listAll">Products</a></li>
                        <li class="breadcrumb-item active">Edit Product</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Edit Product</h5>
                                
                                <!-- Fetch the product using the ID -->
                                <%
                                    int productId = Integer.parseInt(request.getParameter("id"));
                                    DAOProduct dao = new DAOProduct();
                                    Product product = dao.getProductByIdNg(productId);
                                    if (product != null) {
                                        Category category = product.getCategory();
                                %>

                                <form action="ProductsControllerURL" method="post" class="w-100">
                                    <input type="hidden" name="service" value="updateProduct">
                                    <input type="hidden" name="productId" value="<%= product.getId() %>">
                                    
                                    <div class="mb-3">
                                        <label for="productName" class="form-label">Product Name</label>
                                        <input type="text" class="form-control" id="productName" name="productName" value="<%= product.getProductName() %>" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="productCode" class="form-label">Product Code</label>
                                        <input type="text" class="form-control" id="productCode" name="productCode" value="<%= product.getProductCode() %>" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Price</label>
                                        <input type="number" class="form-control" id="price" name="price" value="<%= product.getPrice() %>" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="stockQuantity" class="form-label">Stock Quantity</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="<%= product.getStockQuantity() %>" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label">Image</label>
                                        <input type="text" class="form-control" id="imageURL" name="imageURL" value="<%= product.getImageURL() %>" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="category" class="form-label">Category</label>
                                        <select class="form-control" id="category" name="categoryId">
                                            <option value="<%= category.getCategoryID() %>" selected><%= category.getCategoryName() %></option>
                                            <!-- Add categories dynamically from the database -->
                                            <option value="1">Electronics</option>
                                            <option value="2">Apparel</option>
                                        </select>
                                    </div>
                                    
                                    <button type="submit" class="btn btn-primary">Update Product</button>
                                </form>

                                <% } else { %>
                                    <p class="text-danger">Product not found!</p>
                                <% } %>

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
