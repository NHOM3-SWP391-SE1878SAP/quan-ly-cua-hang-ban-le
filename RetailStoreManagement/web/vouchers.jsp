<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>

<%
    List<Voucher> vouchers = (List<Voucher>) session.getAttribute("vouchers");
    if (vouchers == null) {
        vouchers = new java.util.ArrayList<>();
    }

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Voucher</title>

    <!-- Bootstrap & CSS -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>

<body>
    <div class="container mt-4">
        <h2 class="text-center">Quản lý Voucher</h2>

        <!-- Hiển thị thông báo -->
        <% if (message != null) { %>
        <div class="alert alert-info"><%= message %></div>
        <% } %>

        <!-- Thanh tìm kiếm -->
        <form action="VoucherServlet" method="get" class="d-flex mb-3">
            <input class="form-control me-2" type="text" name="search" placeholder="Tìm kiếm mã voucher..." >
            <button class="btn btn-primary" type="submit">Tìm kiếm</button>
        </form>

        <!-- Nút Thêm Voucher -->
        <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addVoucherModal">Thêm Voucher</button>

        <!-- Bảng hiển thị voucher -->
        <div class="table-responsive">
            <table class="table table-bordered text-center">
                <thead class="table-primary">
                    <tr>
                        
                        <th>Code</th>
                        <th>Min Order</th>
                        <th>Discount Rate</th>
                        <th>Max Value</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Voucher v : vouchers) { %>
                    <tr>
                        
                        <td><%= v.getCode() %></td>
                        <td><%= v.getMinOrder() %></td>
                        <td><%= v.getDiscountRate() %>%</td>
                        <td><%= v.getMaxValue() %></td>
                        <td><%= v.getStartDate() %></td>
                        <td><%= v.getEndDate() %></td>
                        <td>
                            <div class="d-flex gap-2">
                                <form action="VoucherServlet" method="post">
                                    <input type="hidden" name="id" value="<%= v.getId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" name="action" value="delete">Xóa</button>
                                </form>
                                <button class="btn btn-warning btn-sm" 
                                    onclick="openEditForm('<%= v.getId() %>', '<%= v.getCode() %>', '<%= v.getMinOrder() %>', 
                                                           '<%= v.getDiscountRate() %>', '<%= v.getMaxValue() %>', 
                                                           '<%= v.getStartDate() %>', '<%= v.getEndDate() %>')" 
                                    data-bs-toggle="modal" data-bs-target="#editVoucherModal">
                                    Sửa
                                </button>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 🟢 MODAL THÊM VOUCHER -->
    <div class="modal fade" id="addVoucherModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Voucher</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="VoucherServlet" method="post">
                        <input type="hidden" name="action" value="add">

                        <div class="mb-3">
                            
                            <div class="input-group">
                                <input type="hidden" class="form-control" id="newVoucherCode" name="code" >
                                
                            </div>
                        </div>

                        <label class="form-label">Min Order</label>
                        <input type="number" class="form-control mb-3" name="minOrder" required>

                        <label class="form-label">Discount Rate (%)</label>
                        <input type="number" class="form-control mb-3" name="discountRate" required>

                        <label class="form-label">Max Value</label>
                        <input type="number" class="form-control mb-3" name="maxValue" required>

                        <label class="form-label">Ngày Bắt Đầu</label>
                        <input type="date" class="form-control mb-3" name="startDate" required>

                        <label class="form-label">Ngày Kết Thúc</label>
                        <input type="date" class="form-control mb-3" name="endDate" required>

                        <button type="submit" class="btn btn-success w-100">Thêm</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- 🟡 MODAL CẬP NHẬT VOUCHER -->
    <div class="modal fade" id="editVoucherModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chỉnh Sửa Voucher</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form action="VoucherServlet" method="post">
                    <input type="hidden" id="editVoucherId" name="id">
                    <input type="hidden" name="action" value="update">

                    
                    <input type="hidden" class="form-control mb-3" id="editVoucherCode" name="code" >

                    <label class="form-label">Min Order</label>
                    <input type="number" class="form-control mb-3" id="editVoucherMinOrder" name="minOrder" required>

                    <label class="form-label">Discount Rate (%)</label>
                    <input type="number" class="form-control mb-3" id="editVoucherDiscountRate" name="discountRate" required>

                    <label class="form-label">Max Value</label>
                    <input type="number" class="form-control mb-3" id="editVoucherMaxValue" name="maxValue" required>

                    <label class="form-label">Ngày Bắt Đầu</label>
                    <input type="date" class="form-control mb-3" id="editVoucherStartDate" name="startDate" required>

                    <label class="form-label">Ngày Kết Thúc</label>
                    <input type="date" class="form-control mb-3" id="editVoucherEndDate" name="endDate" required>

                    <button type="submit" class="btn btn-warning w-100">Cập Nhật</button>
                </form>
            </div>
        </div>
    </div>
</div>

    <!-- JavaScript -->
    <script>
        function openEditForm(id, code, minOrder, discountRate, maxValue) {
            document.getElementById("editVoucherId").value = id;
            document.getElementById("editVoucherCode").value = code;
            document.getElementById("editVoucherMinOrder").value = minOrder;
            document.getElementById("editVoucherDiscountRate").value = discountRate;
            document.getElementById("editVoucherMaxValue").value = maxValue;
        }

        function generateVoucherCode() {
            fetch('GenerateVoucherCodeServlet')
                .then(response => response.text())
                .then(code => document.getElementById('newVoucherCode').value = code);
        }
    </script>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>
