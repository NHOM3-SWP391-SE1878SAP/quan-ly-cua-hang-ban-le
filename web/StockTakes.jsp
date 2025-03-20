<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Stock Takes - Products Without Goods Receipt</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Kiểm kho</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Kiểm kho</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Sản Phẩm chưa được nhập vào kho</h5>
                                <table class="table table-hover datatable mt-3">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="w-5">Ảnh</th>
                                            <th scope="col" class="w-10">Mã hàng</th>
                                            <th scope="col" class="w-10">Tên hàng</th>
                                            <th scope="col" class="w-5">Tồn kho</th>
                                            <th scope="col" class="w-10">Giá bán (VNĐ)</th>
                                            <th scope="col" class="w-10">Tổng giá</th>
                                            <th scope="col" class="w-10">Trạng thái</th>
                                            <th scope="col" class="w-20" style="text-align: center;">Ghi chú</th>
                                            <th scope="col" class="w-20" style="text-align: center;">Cập nhật</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Vector<Product> products = (Vector<Product>) request.getAttribute("data");
                                            if (products != null && !products.isEmpty()) {
                                                for (Product p : products) {
                                        %>
                                        <tr>
                                            <td>
                                                <img src="<%= p.getImageURL() != null && !p.getImageURL().isEmpty() ? p.getImageURL() : "assets/img/no-image.png" %>" 
                                                     alt="Product Image" class="img-thumbnail" style="width: 60px; height: 60px;">
                                            </td>
                                            <td style="align-content: center;"><%= p.getProductCode() %></td>
                                            <td style="align-content: center;"><%= p.getProductName() %></td>
                                            <td style="align-content: center;"><%= p.getStockQuantity() %></td>
                                            <td style="align-content: center;"><%= String.format("%,d", p.getPrice()) %></td>
                                            <td style="align-content: center;"><%= String.format("%,d",p.getStockQuantity()*p.getPrice()) %></td>
                                            <td style="align-content: center;">
                                                <span class="badge <%= p.getStockQuantity() == 0 ? "bg-danger" : (p.isIsAvailable() ? "bg-success" : "bg-secondary") %>">
                                                    <%= p.getStockQuantity() == 0 ? "Out of Stock" : (p.isIsAvailable() ? "Available" : "Stop Sell") %>
                                                </span>
                                            </td>
                                            <td style="align-content: center;">Phiếu kiểm kho được tạo khi cập nhật hàng hóa: <br><%=p.getProductCode()%></td>
                                            <td style="align-content: center; text-align: center;">
                                                <button class="btn btn-warning btn-sm"
                                                        onclick="showProductDetail('<%= p.getImageURL() %>',
                                                                '<%= p.getProductCode() %>',
                                                                '<%= p.getProductName() %>',
                                                                '<%= p.getCategory().getCategoryName() %>',
                                                                '<%= p.getStockQuantity() %>',
                                                                '<%= p.getPrice() %>',
                                                                '<%= p.getStockQuantity() * p.getPrice() %>',
                                                                '<%= p.getStockQuantity() == 0 ? "Hết hàng" : (p.isIsAvailable() ? "Còn hàng" : "Ngừng bán") %>')">
                                                    Xem chi tiết
                                                </button>
                                                <a class="btn btn-danger btn-sm" href="ProductsControllerURL?service=delete&id=<%= p.getId() %>" 
                                                   onclick="return confirm('Bạn có chắc chắn Xóa bỏ Sản phẩm <%=p.getProductName()%> không?')">Hủy bỏ</a>
                                            </td>
                                        </tr>
                                        <%
                                                }
                                            } else {
                                        %>
                                        <tr>
                                            <td colspan="6" class="text-center text-danger">Không có sản phẩm nào!</td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                                <a href="ProductsControllerURL?service=listAll" class="btn btn-secondary mt-3">Quay về Danh Mục</a>
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
                            <div class="col-md-4 text-center">
                                <img id="productImage" src="assets/img/no-image.png" class="img-fluid rounded" style="max-width: 100%;">
                            </div>
                            <div class="col-md-8">
                                <p><strong>Mã hàng:</strong> <span id="productCode"></span></p>
                                <p><strong>Tên hàng:</strong> <span id="productName"></span></p>
                                <p><strong>Loại hàng:</strong> <span id="productCategory"></span></p>
                                <p><strong>Tồn kho:</strong> <span id="productStock"></span></p>
                                <p><strong>Giá bán:</strong> <span id="productPrice"></span> VNĐ</p>
                                <p><strong>Tổng giá:</strong> <span id="productTotal"></span> VNĐ</p>
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
    function showProductDetail(image, code, name, category, stock, price, total, status) {
        document.getElementById("productImage").src = image && image.trim() !== "" ? image : "assets/img/no-image.png";
        document.getElementById("productCode").innerText = code;
        document.getElementById("productName").innerText = name;
        document.getElementById("productCategory").innerText = category;
        document.getElementById("productStock").innerText = stock;
        document.getElementById("productPrice").innerText = new Intl.NumberFormat('vi-VN').format(price);
        document.getElementById("productTotal").innerText = new Intl.NumberFormat('vi-VN').format(total);
        document.getElementById("productStatus").innerText = status;

        // Hiển thị modal
        var productModal = new bootstrap.Modal(document.getElementById("productDetailModal"));
        productModal.show();
    }
</script>
    </body>
</html>