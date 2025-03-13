<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>

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
                        <% List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
                           if (vouchers != null && !vouchers.isEmpty()) {
                               for (Voucher v : vouchers) { %>
                        <tr>
                            <td><%= v.getCode() %></td>
                            <td><%= String.format("%,d", v.getMinOrder()) %> VND</td>
                            <td><%= v.getDiscountRate() %>%</td>
                            <td><%= String.format("%,d", v.getMaxValue()) %> VND</td>
                            <td><%= v.getStartDate() %></td>
                            <td><%= v.getEndDate() %></td>
                            <td>
                                <div class="d-flex gap-2">
                                    <form action="VoucherServlet" method="post" onsubmit="return confirmDelete(this)">
                                        <input type="hidden" name="id" value="<%= v.getId() %>">
                                        <button type="submit" class="btn btn-danger btn-sm" name="action" value="delete" >Xóa</button>
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
                        <% } } else { %>
                        <tr><td colspan="8" class="text-center">Không có voucher nào.</td></tr>
                        <% } %>
                    </tbody>

                </table>
            </div>
        </div>
        <ul class="pagination justify-content-center">
            <% 
                Integer currentPageObj = (Integer) request.getAttribute("currentPage");
                Integer totalPagesObj = (Integer) request.getAttribute("totalPages");

                int currentPage = (currentPageObj != null) ? currentPageObj : 1;
                int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;

                if (currentPage > 1) { %>
            <li class="page-item"><a class="page-link" href="VoucherServlet?page=1">Trang đầu</a></li>
            <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= currentPage - 1 %>">Trước</a></li>
                <% } 

                    for (int i = 1; i <= totalPages; i++) { %>
            <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                <a class="page-link" href="VoucherServlet?page=<%= i %>"><%= i %></a>
            </li>
            <% } 

                if (currentPage < totalPages) { %>
            <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= currentPage + 1 %>">Sau</a></li>
            <li class="page-item"><a class="page-link" href="VoucherServlet?page=<%= totalPages %>">Trang cuối</a></li>
                <% } %>
        </ul>


        <!-- 🟢 MODAL THÊM VOUCHER -->
        <div class="modal fade" id="addVoucherModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thêm Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form action="VoucherServlet" method="post" onsubmit="return  confirmAdd(this)">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">

                                <div class="input-group">
                                    <input type="hidden" class="form-control" id="newVoucherCode" name="code" >

                                </div>
                            </div>

                            <label class="form-label">Min Order</label>
                            <input type="text" class="form-control mb-3" name="minOrder" oninput="formatCurrency(this)"  placeholder="Nhập số tiền..." required>

                            <label class="form-label">Discount Rate (%)</label>
                            <input type="number" class="form-control mb-3" name="discountRate" required>

                            <label class="form-label">Max Value</label>
                            <input type="text" class="form-control mb-3" name="maxValue" oninput="formatCurrency(this)"  placeholder="Nhập số tiền..." required>

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
                        <form action="VoucherServlet" method="post" onsubmit="return confirmUpdate(this)">
                            <input type="hidden" id="editVoucherId" name="id">
                            <input type="hidden" name="action" value="update">


                            <input type="hidden" class="form-control mb-3" id="editVoucherCode" name="code" >

                            <label class="form-label">Min Order</label>
                            <input type="text" class="form-control mb-3" id="editVoucherMinOrder" name="minOrder" oninput="formatVND(input)"  placeholder="Nhập số tiền..." required>

                            <label class="form-label">Discount Rate (%)</label>
                            <input type="number" class="form-control mb-3" id="editVoucherDiscountRate" name="discountRate" required>

                            <label class="form-label">Max Value</label>
                            <input type="text" class="form-control mb-3" id="editVoucherMaxValue" name="maxValue" oninput="formatVND(input)"  placeholder="Nhập số tiền..." required>

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
            function formatCurrency(input) {
                // ✅ Loại bỏ tất cả ký tự không phải số
                let value = input.value.replace(/\D/g, "");

                // ✅ Đảm bảo có ít nhất một số
                if (value === "")
                    return;

                // ✅ Định dạng lại số theo kiểu tiền Việt Nam (1.000, 10.000.000, ...)
                value = Number(value).toLocaleString("vi-VN");

                // ✅ Gán lại vào ô input
                input.value = value;
            }




            // ✅ Chuyển đổi số tiền có dấu '.' về số nguyên khi submit form
            function convertToNumber(value) {
                return parseInt(value.replace(/\./g, ""), 10) || 0;
            }

            // ✅ Xác nhận khi xóa voucher
            function confirmDelete() {
                return confirm("⚠️ Bạn có chắc chắn muốn xóa voucher này?");
            }

            // ✅ Xác nhận khi cập nhật voucher
            function confirmUpdate(form) {
                let minOrder = form.querySelector("[name='minOrder']");
                let maxValue = form.querySelector("[name='maxValue']");
                let startDate = new Date(form.querySelector("[name='startDate']").value);
                let endDate = new Date(form.querySelector("[name='endDate']").value);

                let minOrderValue = convertToNumber(minOrder.value);
                let maxValueValue = convertToNumber(maxValue.value);

                // Kiểm tra nếu startDate >= endDate
                if (startDate >= endDate) {
                    alert("❌ Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    return false;
                }

                // Kiểm tra giá trị không được nhỏ hơn 1
                if (minOrderValue < 1 || maxValueValue < 1) {
                    alert("❌ Min Order và Max Value phải lớn hơn 0!");
                    return false;
                }

                // ✅ Gán lại giá trị dạng số trước khi gửi form
                minOrder.value = minOrderValue;
                maxValue.value = maxValueValue;

                return confirm("⚠️ Bạn có chắc chắn muốn cập nhật voucher?");
            }

            // ✅ Xác nhận khi thêm voucher
            function confirmAdd(form) {
                let minOrder = form.querySelector("[name='minOrder']");
                let maxValue = form.querySelector("[name='maxValue']");
                let startDate = new Date(form.querySelector("[name='startDate']").value);
                let endDate = new Date(form.querySelector("[name='endDate']").value);

                let minOrderValue = convertToNumber(minOrder.value);
                let maxValueValue = convertToNumber(maxValue.value);

                // Kiểm tra nếu startDate >= endDate
                if (startDate >= endDate) {
                    alert("❌ Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    return false;
                }

                // Kiểm tra giá trị không được nhỏ hơn 1
                if (minOrderValue < 1 || maxValueValue < 1) {
                    alert("❌ Min Order và Max Value phải lớn hơn 0!");
                    return false;
                }

                // ✅ Gán lại giá trị dạng số trước khi gửi form
                minOrder.value = minOrderValue;
                maxValue.value = maxValueValue;

                return confirm("✅ Xác nhận thêm voucher?");
            }
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
