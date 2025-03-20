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
        <title>Chỉnh sửa sản phẩm</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Chỉnh sửa sản phẩm</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="ProductsControllerURL?service=listAll">Quản lý sản phẩm</a></li>
                        <li class="breadcrumb-item active">Chỉnh sửa sản phẩm</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Chỉnh sửa thông tin sản phẩm</h5>

                                <!-- Hiển thị thông báo lỗi nếu có -->
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger" role="alert">
                                        ${error}
                                    </div>    
                                    <div class="mb-3">
                                        <a href="ProductsControllerURL?service=edit&id=${product.id}" class="btn btn-primary">Nhập lại</a> <!-- Quay lại trang chỉnh sửa -->                                    
                                    </div>
                                </c:if>

                                <!-- Lấy sản phẩm từ cơ sở dữ liệu -->
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
                                        <label for="productName" class="form-label">Tên sản phẩm</label>
                                        <input type="text" class="form-control" id="productName" name="productName" value="<%= product.getProductName() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="productCode" class="form-label">Mã sản phẩm</label>
                                        <input type="text" class="form-control" id="productCode" name="productCode" value="<%= product.getProductCode() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="price" class="form-label">Giá</label>
                                        <input type="number" class="form-control" id="price" name="price" value="<%= product.getPrice() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="stockQuantity" class="form-label">Số lượng tồn kho</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="<%= product.getStockQuantity() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label">Hình ảnh</label>
                                        <input type="text" class="form-control" id="imageURL" name="imageURL" value="<%= product.getImageURL() %>" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="categoryId" class="form-label">Danh mục</label>
                                        <select class="form-control" id="categoryId" name="categoryId" required>
                                            <option value="<%= category.getCategoryID() %>" selected><%= category.getCategoryName() %></option>
                                            <%
                                                Vector<Category> categories = dao.getAllCategories();
                                                    for (Category cat : categories) {
                                            %>
                                            <option value="<%= cat.getCategoryID() %>"><%= cat.getCategoryName() %></option>
                                            <%
                                                    }
                                            %>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary">Cập nhật sản phẩm</button>
                                </form>

                                <% } else { %>
                                <p class="text-danger">Sản phẩm không tồn tại!</p>
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
