<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Customer" %>

<%
    // Lấy thông báo từ session nếu có
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Slim - Nhân viên</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">

</head>

<%@include file="HeaderAdmin.jsp"%>
<main id="main" class="main">
    <div class="container mt-4">
        <h2 class="text-center">Quản lý Khách hàng</h2>

        <!-- Hiển thị thông báo -->
        <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
        <% } %>

        <!-- Thanh tìm kiếm -->
        <form action="CustomerServlet" method="get" class="d-flex mb-3">
            <input class="form-control me-2" type="text" name="search" placeholder="Tìm kiếm theo tên hoặc số điện thoại...">
            <button class="btn btn-primary" type="submit">Tìm kiếm</button>
        </form>

        <!-- Nút Thêm Khách hàng -->
        <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addCustomerModal">Thêm Khách hàng</button>

        <!-- Bảng hiển thị danh sách khách hàng -->
        <div class="table-responsive">
            <table class="table table-hover datatable">
                <thead class="table-primary">
                    <tr>
                        
                        <th>Tên</th>
                        <th>Số điện thoại</th>
                        <th>Địa chỉ</th>
                        <th>Điểm thưởng</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                        if (customers != null && !customers.isEmpty()) {
                            for (Customer c : customers) { %>
                    <tr>
                        
                        <td><%= c.getCustomerName() %></td>
                        <td><%= c.getPhone() %></td>
                        <td><%= c.getAddress() %></td>
                        <td><%= c.getPoints() != null ? c.getPoints() : 0 %></td>
                        <td>
                            <div class="d-flex gap-2">
<!--                                <form action="CustomerServlet" method="post" onsubmit="return confirmDelete(this)">
                                    <input type="hidden" name="id" value="<%= c.getId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" name="action" value="delete">Xóa</button>
                                </form>-->
                                    <div>
                                <button class="btn btn-warning btn-sm" 
                                        onclick="openEditForm('<%= c.getId() %>', '<%= c.getCustomerName() %>', 
                                                              '<%= c.getPhone() %>', '<%= c.getAddress() %>', 
                                                              '<%= c.getPoints() != null ? c.getPoints() : 0 %>')" 
                                        data-bs-toggle="modal" data-bs-target="#editCustomerModal">
                                    Sửa
                                </button>
                                                                        </div>

                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="6" class="text-center">Không có khách hàng nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
                <ul class="pagination justify-content-center">
            <% 
                Integer currentPageObj = (Integer) request.getAttribute("currentPage");
                Integer totalPagesObj = (Integer) request.getAttribute("totalPages");

                int currentPage = (currentPageObj != null) ? currentPageObj : 1;
                int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;

                if (currentPage > 1) { %>
            <li class="page-item"><a class="page-link" href="CustomerServlet?page=1">Trang đầu</a></li>
            <li class="page-item"><a class="page-link" href="CustomerServlet?page=<%= currentPage - 1 %>">Trước</a></li>
                <% } 

                    for (int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                <a class="page-link" href="CustomerServlet?page=<%= i %>"><%= i %></a>
            </li>
            <% } 

                if (currentPage < totalPages) { %>
            <li class="page-item"><a class="page-link" href="CustomerServlet?page=<%= currentPage + 1 %>">Sau</a></li>
            <li class="page-item"><a class="page-link" href="CustomerServlet?page=<%= totalPages %>">Trang cuối</a></li>
                <% } %>
        </ul>
    </div>
</main>

    <!-- 🟢 MODAL THÊM KHÁCH HÀNG -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Khách hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="CustomerServlet" method="post" onsubmit="return confirmAdd(this)">
                        <input type="hidden" name="action" value="add">

                        <label class="form-label">Tên Khách hàng</label>
                        <input type="text" class="form-control mb-3" name="customerName" required>

                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control mb-3" name="phone" required>

                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-control mb-3" name="address">

                        <label class="form-label">Điểm thưởng</label>
                        <input type="number" class="form-control mb-3" name="points">

                        <button type="submit" class="btn btn-success w-100">Thêm</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 🟡 MODAL CẬP NHẬT KHÁCH HÀNG -->
    <div class="modal fade" id="editCustomerModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chỉnh sửa Khách hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="CustomerServlet" method="post" onsubmit="return confirmUpdate(this)">
                        <input type="hidden" id="editCustomerId" name="id">
                        <input type="hidden" name="action" value="update">

                        <label class="form-label">Tên Khách hàng</label>
                        <input type="text" class="form-control mb-3" id="editCustomerName" name="customerName" required>

                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-control mb-3" id="editCustomerPhone" name="phone" required>

                        <label class="form-label">Địa chỉ</label>
                        <input type="text" class="form-control mb-3" id="editCustomerAddress" name="address">

                        <label class="form-label">Điểm thưởng</label>
                        <input type="number" class="form-control mb-3" id="editCustomerPoints" name="points">

                        <button type="submit" class="btn btn-warning w-100">Cập nhật</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script>
        function openEditForm(id, name, phone, address, points) {
            document.getElementById("editCustomerId").value = id;
            document.getElementById("editCustomerName").value = name;
            document.getElementById("editCustomerPhone").value = phone;
            document.getElementById("editCustomerAddress").value = address;
            document.getElementById("editCustomerPoints").value = points;
        }

        function confirmDelete() {
            return confirm("⚠️ Bạn có chắc chắn muốn xóa khách hàng này?");
        }

        function confirmAdd() {
            return confirm("✅ Xác nhận thêm khách hàng?");
        }

        function confirmUpdate() {
            return confirm("⚠️ Bạn có chắc chắn muốn cập nhật khách hàng?");
        }
    </script>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>

</html>