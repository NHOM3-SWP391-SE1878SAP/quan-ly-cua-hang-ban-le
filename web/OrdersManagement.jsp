<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý hóa đơn</title>
    <link rel="stylesheet" href="assets/vendor/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/vendor/bootstrap-icons/bootstrap-icons.css">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>
    <main id="main" class="main">
        <div class="container mt-4">
            <h2 class="mb-3">Hóa đơn</h2>

            <!-- Form tìm kiếm với 3 trường gọn trong một ô -->
            <form method="get" action="InvoiceSearchServlet" class="mb-4">
                <div class="input-group">
                    <!-- Mã hóa đơn -->
                    <input type="text" class="form-control" name="invoiceCode" placeholder="Mã hóa đơn" aria-label="Mã hóa đơn">
                    <!-- Tên khách hàng -->
                    <input type="text" class="form-control" name="customerName" placeholder="Tên khách hàng" aria-label="Tên khách hàng">
                    <!-- Người bán -->
                    <input type="text" class="form-control" name="sellerName" placeholder="Người bán" aria-label="Người bán">
                    <!-- Nút tìm kiếm -->
                    <button class="btn btn-primary" type="submit">Tìm kiếm</button>
                </div>
                
                <!-- Thêm khoảng thời gian -->
                <div class="input-group mt-3">
                    <!-- Ngày bắt đầu -->
                    <input type="date" class="form-control" name="startDate" aria-label="Ngày bắt đầu">
                    <!-- Ngày kết thúc -->
                    <input type="date" class="form-control" name="endDate" aria-label="Ngày kết thúc">
                    <!-- Nút tìm kiếm -->
                    <button class="btn btn-primary" type="submit">Tìm kiếm</button>
                </div>
            </form>

            <!-- Bảng hiển thị hóa đơn -->
            <table class="table mt-4 table-bordered">
                <thead>
                    <tr>
                        <th>Mã hóa đơn</th>
                        <th>Thời gian</th>
                        <th>Khách hàng</th>
                        <th>Người bán</th>
                        <th>Tổng tiền hàng</th>
                        <th>Giảm giá</th>
                        <th>Khách đã trả</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
</body>
</html>
