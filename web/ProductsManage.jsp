<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>Product Management - NiceAdmin</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>

    <body>
        <%@include file="HeaderAdmin.jsp"%>          

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Quản lý danh mục hàng hóa</h1>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Danh sách sản phẩm</h5>
                                <table class="table datatable">
                                    <thead>
                                        <tr>
                                            <th>Mã hàng</th>
                                            <th>Tên hàng</th>
                                            <th>Giá bán</th>
                                            <th>Giá vốn</th>
                                            <th>Số lượng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>SP00001</td>
                                            <td>Snack Khoai Tây</td>
                                            <td>10,000</td>
                                            <td>4,000</td>
                                            <td>10</td>
                                        </tr>
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
