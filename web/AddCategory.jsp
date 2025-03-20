<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.Category"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Loại Hàng</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Thêm Loại Hàng</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="CategoryControllerURL?service=listAll">Quản Lý Loại Hàng</a></li>
                        <li class="breadcrumb-item active">Thêm Loại Hàng</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Thêm Loại Hàng Mới</h5>
                                <form action="CategoryControllerURL" method="post">
                                    <input type="hidden" name="service" value="add">
                                    
                                    <!-- Display error message if category name already exists -->
                                    <% if (request.getAttribute("errorMessage") != null) { %>
                                        <div class="alert alert-danger">
                                            <%= request.getAttribute("errorMessage") %>
                                        </div>
                                    <% } %>

                                    <div class="mb-3">
                                        <label for="categoryName">Tên Loại Hàng</label>
                                        <input type="text" class="form-control" id="categoryName" name="categoryName" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="description">Mô Tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label for="imageName" class="form-label">Hình ảnh (URL)</label>
                                        <input type="text" class="form-control" id="imageName" name="imageName" placeholder="Enter the image URL" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary mt-3">Thêm Mới</button>
                                    <a href="CategoryControllerURL?service=listAll" class="btn btn-secondary mt-3 ml-3">Quay lại</a>
                                </form>
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
