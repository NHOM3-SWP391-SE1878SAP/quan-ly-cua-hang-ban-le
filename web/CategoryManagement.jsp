<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Category"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Danh Mục</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Quản Lý Loại Hàng</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Quản Lý Loại Hàng</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <a href="AddCategory.jsp" class="btn btn-primary mb-3">Thêm loại hàng</a>
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Danh Sách Các Loại Hàng</h5>
                                 <a href="ExportCategoryExcelServlet" class="btn btn-success mb-3">Xuất Excel</a>
                                <table class="table table-hover datatable mt-3">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="w-15">Ảnh</th>
                                            <th scope="col" class="w-25">Tên Loại Hàng</th>
                                            <th scope="col" class="w-35">Mô Tả</th>
                                            <th scope="col" class="w-25" style="text-align: center;">Cập nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Vector<Category> categories = (Vector<Category>) request.getAttribute("categories");
                                            if (categories != null && !categories.isEmpty()) {
                                                for (Category category : categories) {
                                        %>
                                        <tr>
                                            <td>
                                                <img src="<%= category.getImage() != null && !category.getImage().isEmpty() ? category.getImage() : "assets/img/no-image.png" %>" 
                                                     alt="Category Image" class="img-thumbnail" style="width: 60px; height: 60px;">
                                            </td>
                                            <td style="align-content: center"><%= category.getCategoryName() %></td>
                                            <td style="align-content: center"><%= category.getDescription() %></td>
                                            <td style="align-content: center; text-align: center;">
                                                <a class="btn btn-success btn-sm" href="CategoryControllerURL?service=getProduct&categoryId=<%= category.getCategoryID() %>">
                                                    Xem hàng
                                                </a>
                                                <a class="btn btn-warning btn-sm" href="CategoryControllerURL?service=edit&categoryID=<%= category.getCategoryID() %>">Sửa</a>
                                                <a class="btn btn-danger btn-sm" href="CategoryControllerURL?service=delete&categoryID=<%= category.getCategoryID() %>" 
                                                   onclick="return confirm('Bạn có chắc chắn Xóa bỏ Loại hàng <%= category.getCategoryName() %> không?')">Xóa</a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="7" class="text-center text-danger">Không có danh mục nào!</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                                <a href="ProductsControllerURL?service=listAll" class="btn btn-secondary mt-3">Quay về Danh Mục Hàng Hóa</a>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/main.js"></script>
    </body>
</html>
