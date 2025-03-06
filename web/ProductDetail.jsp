<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="entity.Product"%>
<%@page import="entity.Category"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm</title>
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
        <div class="pagetitle">
            <h1>Chi tiết sản phẩm</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                    <li class="breadcrumb-item"><a href="ProductsControllerURL?service=listAll">Products</a></li>
                    <li class="breadcrumb-item active">Product Detail</li>
                </ol>
            </nav>
        </div>

        <section class="section">
            <div class="card">
                <div class="card-body">
                    <%
                        Product product = (Product) request.getAttribute("product");
                        if (product != null) {
                            Category category = product.getCategory();
                    %>
                    <div class="row">
                        <!-- Ảnh sản phẩm -->
                        <div class="col-md-4 text-center">
                            <img src="<%= product.getImageURL() != null && !product.getImageURL().isEmpty() ? product.getImageURL() : "assets/img/no-image.png" %>" 
                                 class="img-fluid rounded" alt="Product Image" style="max-width: 100%;">
                        </div>

                        <!-- Thông tin sản phẩm -->
                        <div class="col-md-8">
                            <h3><strong><%= product.getProductName() %></strong></h3>
                            <p>
                                <span class="text-success fw-bold">✔ Bán trực tiếp</span>
                                <span class="text-danger ms-3 fw-bold">✘ Không tích điểm</span>
                            </p>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Mã hàng:</strong> <%= product.getProductCode() %></p>
                                    <p><strong>Mã vạch:</strong> 8936048470685</p>
                                    <p><strong>Nhóm hàng:</strong> <%= category != null ? category.getCategoryName() : "N/A" %></p>
                                    <p><strong>Loại hàng:</strong> Hàng hóa</p>
                                    <p><strong>Thương hiệu:</strong> <%= category != null ? category.getCategoryName() : "N/A" %></p>
                                    <p><strong>Định mức tồn:</strong> 0 > 10</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Giá bán:</strong> <%= String.format("%,d", product.getPrice()) %> VNĐ</p>
                                    <p><strong>Giá vốn:</strong> <%= String.format("%,d", product.getStockQuantity()) %> VNĐ</p>
                                    <p><strong>Trọng lượng:</strong> --- </p>
                                    <p><strong>Vị trí:</strong> --- </p>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>Mô tả:</strong></p>
                                    <p>---</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>Ghi chú đặt hàng:</strong></p>
                                    <p>---</p>
                                    <p><strong>Nhà cung cấp:</strong></p>
                                    <p>---</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Nút chức năng -->
                    <div class="d-flex justify-content-between mt-4">
                        <div>
                            <a href="ProductsControllerURL?service=edit&id=<%= product.getId() %>" class="btn btn-success">
                                <i class="bi bi-pencil-square"></i> Cập nhật
                            </a>
                            <button class="btn btn-secondary">
                                <i class="bi bi-upc"></i> In tem mã
                            </button>
                            <button class="btn btn-success">
                                <i class="bi bi-files"></i> Sao chép
                            </button>
                        </div>
                        <div>
                            <button class="btn btn-danger">
                                <i class="bi bi-x-circle"></i> Ngừng kinh doanh
                            </button>
                            <a href="ProductsControllerURL?service=delete&id=<%= product.getId() %>" class="btn btn-danger"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">
                                <i class="bi bi-trash"></i> Xóa
                            </a>
                        </div>
                    </div>
                    <%
                        } else {
                    %>
                    <p class="text-danger text-center">Sản phẩm không tồn tại hoặc đã bị xóa.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </section>
    </main>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
</body>
</html>
