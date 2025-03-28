<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="entity.Voucher" %>

<%
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
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>
    <main id="main" class="main">
        <div class="container mt-4">
            <h2 class="text-center">Quản lý Voucher</h2>

            <% if (message != null) { %>
            <div class="alert alert-info"><%= message %></div>
            <% } %>
            <div>
<!--             Search 
            <form action="VoucherServlet" method="get" class="d-flex mb-3">
                <input class="form-control me-2" type="text" name="search" placeholder="Tìm kiếm mã voucher...">
                <button class="btn btn-primary" type="submit">Tìm</button>
            </form>-->

            <!-- Add Button -->
            <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addVoucherModal">Thêm Voucher</button>
            </div>
            <!-- Voucher Table -->
                        <div class="row">

             <div class="card">
                        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover datatable">
                    <thead class="table-primary">
                        <tr>
                            <th>Code</th>
                            <th>Min Order</th>
                            <th>Discount</th>
                            <th>Max Value</th>
                            <th>Usage Limit</th>
                            <th>Used</th>
                            <th>Status</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                           if (vouchers != null && !vouchers.isEmpty()) {
                               for (Voucher v : vouchers) { %>
                        <tr>
                            <td><%= v.getCode() %></td>
                            <td><%= String.format("%,d", v.getMinOrder()) %>₫</td>
                            <td><%= v.getDiscountRate() %>%</td>
                            <td><%= String.format("%,d", v.getMaxValue()) %>₫</td>
                            <td><%= v.getUsage_limit() %></td>
                            <td><%= v.getUsage_count() %></td>
                            <td><%= v.getStatus() ? "🟢 Hoạt động" : "🔴 Tạm dừng" %></td>
                            <td><%= v.getStartDate() %></td>
                            <td><%= v.getEndDate() %></td>
                            <td>
                                <div class="d-flex gap-2 justify-content-center">
<!--                                    <form method="post" onsubmit="return confirm('Xóa voucher này?')">
                                        <input type="hidden" name="id" value="<%= v.getId() %>">
                                        <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm">Xóa</button>
                                    </form>-->
                                    <button class="btn btn-warning btn-sm" 
                                        onclick="openEditForm(
                                            '<%= v.getId() %>',
                                            '<%= v.getCode() %>',
                                            '<%= v.getMinOrder() %>',
                                            '<%= v.getDiscountRate() %>',
                                            '<%= v.getMaxValue() %>',
                                            '<%= v.getUsage_limit() %>',
                                            '<%= v.getUsage_count() %>',
                                            '<%= v.getStatus() %>',
                                            '<%= v.getStartDate() %>',
                                            '<%= v.getEndDate() %>'
                                        )" 
                                        data-bs-toggle="modal" data-bs-target="#editVoucherModal">
                                        Sửa
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="10" class="text-center">Không có voucher nào.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
                        </div>
             </div>
                        </div>
            <!-- Pagination -->
            <ul class="pagination justify-content-center">
                <% 
                int currentPage = (Integer)request.getAttribute("currentPage");
                int totalPages = (Integer)request.getAttribute("totalPages");
                
                if (currentPage > 1) { %>
                    <li class="page-item"><a class="page-link" href="VoucherServlet?page=1">Đầu</a></li>
                    <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= currentPage-1 %>">Trước</a></li>
                <% } 
                
                for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="VoucherServlet?page=<%= i %>"><%= i %></a>
                    </li>
                <% } 
                
                if (currentPage < totalPages) { %>
                    <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= currentPage+1 %>">Sau</a></li>
                    <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= totalPages %>">Cuối</a></li>
                <% } %>
            </ul>
        </div>

        <!-- Add Modal -->
        <div class="modal fade" id="addVoucherModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm Voucher Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="VoucherServlet" method="post" onsubmit="return validateAddForm()">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-3">
                                <label class="form-label">Min Order (₫)</label>
                                <input type="text" class="form-control" name="minOrder" 
                                    oninput="formatCurrency(this)" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Rate (%)</label>
                                <input type="number" class="form-control" name="discountRate" 
                                    min="1" max="100" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Max Value (₫)</label>
                                <input type="text" class="form-control" name="maxValue" 
                                    oninput="formatCurrency(this)" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Usage Limit</label>
                                <input type="number" class="form-control" name="usageLimit" 
                                    min="1" value="1" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status">
                                    <option value="true">Hoạt động</option>
                                    <option value="false">Tạm dừng</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Start Date</label>
                                <input type="date" class="form-control" name="startDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">End Date</label>
                                <input type="date" class="form-control" name="endDate" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Thêm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editVoucherModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chỉnh Sửa Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="VoucherServlet" method="post" onsubmit="return validateEditForm()">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" id="editId" name="id">
                            <input type="hidden" id="editUsageCount" name="usageCount">
                            
                            <div class="mb-3">
                                <label class="form-label">Code</label>
                                <input type="text" class="form-control" id="editCode" name="code" readonly>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Min Order (₫)</label>
                                <input type="text" class="form-control" id="editMinOrder" 
                                    name="minOrder" oninput="formatCurrency(this)" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Discount Rate (%)</label>
                                <input type="number" class="form-control" id="editDiscountRate" 
                                    name="discountRate" min="1" max="100" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Max Value (₫)</label>
                                <input type="text" class="form-control" id="editMaxValue" 
                                    name="maxValue" oninput="formatCurrency(this)" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Usage Limit</label>
                                <input type="number" class="form-control" id="editUsageLimit" 
                                    name="usageLimit" min="1" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" id="editStatus" name="status">
                                    <option value="true">Hoạt động</option>
                                    <option value="false">Tạm dừng</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="editStartDate" 
                                    name="startDate" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">End Date</label>
                                <input type="date" class="form-control" id="editEndDate" 
                                    name="endDate" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script>
        // Format currency input
        function formatCurrency(input) {
            let value = input.value.replace(/\D/g, "");
            if (!value) return;
            input.value = parseInt(value).toLocaleString("vi-VN");
        }

        // Open edit modal with data
        function openEditForm(id, code, minOrder, discountRate, maxValue, usageLimit, usageCount, status, startDate, endDate) {
            document.getElementById('editId').value = id;
            document.getElementById('editCode').value = code;
            document.getElementById('editMinOrder').value = parseInt(minOrder).toLocaleString("vi-VN");
            document.getElementById('editDiscountRate').value = discountRate;
            document.getElementById('editMaxValue').value = parseInt(maxValue).toLocaleString("vi-VN");
            document.getElementById('editUsageLimit').value = usageLimit;
            document.getElementById('editUsageCount').value = usageCount;
            document.getElementById('editStatus').value = status;
            document.getElementById('editStartDate').value = startDate;
            document.getElementById('editEndDate').value = endDate;
        }

        // Form validation
        function validateAddForm() {
            const minOrder = parseInt(document.querySelector('#addVoucherModal [name="minOrder"]').value.replace(/\./g, ''));
            const maxValue = parseInt(document.querySelector('#addVoucherModal [name="maxValue"]').value.replace(/\./g, ''));
            
            if (minOrder < 1000) {
                alert("Min Order phải tối thiểu 1.000₫");
                return false;
            }
            
            if (maxValue < 1000) {
                alert("Max Value phải tối thiểu 1.000₫");
                return false;
            }
            
            return confirm("Xác nhận thêm voucher mới?");
        }

        function validateEditForm() {
            const minOrder = parseInt(document.getElementById('editMinOrder').value.replace(/\./g, ''));
            const maxValue = parseInt(document.getElementById('editMaxValue').value.replace(/\./g, ''));
            
            if (minOrder < 1000) {
                alert("Min Order phải tối thiểu 1.000₫");
                return false;
            }
            
            if (maxValue < 1000) {
                alert("Max Value phải tối thiểu 1.000₫");
                return false;
            }
            
            return confirm("Xác nhận cập nhật voucher?");
        }
    </script>
        <!-- Vendor JS Files -->
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>
</body>
</html>