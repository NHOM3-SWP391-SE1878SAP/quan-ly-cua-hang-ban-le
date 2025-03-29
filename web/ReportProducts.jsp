<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Sản phẩm Bán chạy</title>
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
        <div class="pagetitle">
            <h1>Báo Cáo Sản phẩm Bán Chạy</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                    <li class="breadcrumb-item active">Báo Cáo Sản phẩm Bán chạy</li>
                </ol>
            </nav>
        </div>

        <section class="section">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Danh sách sản phẩm bán chạy</h5>
                    
                    <!-- Xuất Excel -->
                    <a href="ExportBestSellingProductsServlet" class="btn btn-success mb-3">Xuất File Excel</a>

                    <table class="table table-striped mt-3">
                        <thead>
                            <tr>
                                <th scope="col">Sản phẩm</th>
                                <th scope="col">Mã sản phẩm</th>
                                <th scope="col">Số lượng bán</th>
                                <th scope="col">Tổng doanh thu</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                // Lấy dữ liệu sản phẩm bán chạy từ request
                                Vector<Product> reportProducts = (Vector<Product>) request.getAttribute("reportProducts");
                                if (reportProducts != null && !reportProducts.isEmpty()) {
                                    for (Product product : reportProducts) {
                            %>
                            <tr>
                                <td><%= product.getProductName() %></td>
                                <td><%= product.getProductCode() %></td>
                                <td><%= product.getOrderDetail1().getQuantity() %></td>
                                <td><%= String.format("%,d",product.getOrderDetail1().getPrice()) %> VNĐ</td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="4" class="text-center text-danger">Không có dữ liệu sản phẩm bán chạy.</td>
                            </tr>
                            <% 
                                }
                            %>
                        </tbody>
                    </table>

                    <a href="ProductsControllerURL?service=listAll" class="btn btn-primary">Quay lại danh sách sản phẩm</a>
                </div>
            </div>
        </section>
    </main>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>

</body>
</html>
