<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="entity.Supplier" %>
<%@ page import="java.util.Vector" %>
<%@ page import="model.DAOSupplier" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa nhà cung cấp</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp" %>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Chỉnh sửa nhà cung cấp</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.html">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="SuppliersControllerURL?service=listAll">Nhà cung cấp</a></li>
                        <li class="breadcrumb-item active">Chỉnh sửa</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-8 mx-auto">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Thông tin nhà cung cấp</h5>

                                <!-- Lấy dữ liệu từ cơ sở dữ liệu -->
                                <% 
                                    int supplierId = Integer.parseInt(request.getParameter("id"));
                                    DAOSupplier dao = new DAOSupplier();
                                    Supplier supplier = dao.getSupplierById(supplierId);
                                    if (supplier != null) {
                                %>

                                <form action="SuppliersControllerURL" method="post" onsubmit="return validateForm()">
                                    <input type="hidden" name="service" value="updateSupplier">
                                    <input type="hidden" name="Id" value="<%= supplier.getId() %>">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="supplierCode" class="form-label">Mã Nhà Cung Cấp</label>
                                                <input type="text" class="form-control" id="supplierCode" name="supplierCode" value="<%= supplier.getSupplierCode() %>" readonly>
                                            </div>
                                            <div class="mb-3">
                                                <label for="supplierName" class="form-label">Tên Nhà Cung Cấp</label>
                                                <input type="text" class="form-control" id="supplierName" name="supplierName" value="<%= supplier.getSupplierName() %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="phone" class="form-label">Số Điện Thoại</label>
                                                <input type="text" class="form-control" id="phone" name="phone" value="<%= supplier.getPhone() %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="companyName" class="form-label">Tên Công Ty</label>
                                                <input type="text" class="form-control" id="companyName" name="companyName" value="<%= supplier.getCompanyName() %>" >
                                            </div>
                                            <div class="mb-3">
                                                <label for="taxCode" class="form-label">Mã Số Thuế</label>
                                                <input type="text" class="form-control" id="taxCode" name="taxCode" value="<%= supplier.getTaxCode() %>" >
                                            </div>
                                        </div>                                  
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" value="<%= supplier.getEmail() %>" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="address" class="form-label">Địa Chỉ</label>
                                                <input type="text" class="form-control" id="address" name="address" value="<%= supplier.getAddress() %>" >
                                            </div>
                                            <div class="mb-3">
                                                <label for="region" class="form-label">Khu Vực</label>
                                                <input type="text" class="form-control" id="region" name="region" value="<%= supplier.getRegion() %>" >
                                            </div>
                                            <div class="mb-3">
                                                <label for="ward" class="form-label">Phường/Xã</label>
                                                <input type="text" class="form-control" id="ward" name="ward" value="<%= supplier.getWard() %>" >
                                            </div>
                                            <div class="mb-3">
                                                <label for="createdBy" class="form-label">Người Tạo</label>
                                                <input type="text" class="form-control" id="createdBy" name="createdBy" value="<%= supplier.getCreatedBy() %>" >
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">Ngày tạo</label>
                                                <input type="date" class="form-control" 
                                                       value="<%= supplier.getCreatedDate() %>" 
                                                       readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="notes" class="form-label">Ghi chú</label>
                                                <textarea class="form-control" id="notes" name="notes"><%= supplier.getNotes() %></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="status" class="form-label">Trạng thái</label>
                                                <select class="form-select" id="status" name="status" required>
                                                    <option value="true" <%= supplier.isStatus() ? "selected" : "" %>>Hoạt động</option>
                                                    <option value="false" <%= !supplier.isStatus() ? "selected" : "" %>>Ngưng hoạt động</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="supplierGroup" class="form-label">Nhóm NCC</label>
                                                <input type="text" class="form-control" id="supplierGroup" name="supplierGroup" value="<%= supplier.getSupplierGroup() %>">
                                            </div>
                                        </div>
                                    </div>

<!--                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="totalPurchase" class="form-label">Tổng mua</label>
                                                <input type="number" class="form-control" id="totalPurchase" name="totalPurchase" 
                                                       value="" step="0.01">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="currentDebt" class="form-label">Nợ hiện tại</label>
                                                <input type="number" class="form-control" id="currentDebt" name="currentDebt" 
                                                       value="" step="0.01">
                                            </div>
                                        </div>
                                    </div>-->

                                    <button type="submit" class="btn btn-primary">Cập Nhật Nhà Cung Cấp</button>
                                    <a href="SuppliersControllerURL?service=listAll" class="btn btn-secondary">Quay Lại</a>
                                </form>

                                <% } else { %>
                                <p class="text-danger">Nhà cung cấp không tồn tại!</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
        <script src="assets/js/main.js"></script>
        <script>
            function validateForm() {
                let supplierCode = document.getElementById("supplierCode").value.trim();
                let supplierName = document.getElementById("supplierName").value.trim();
                let phone = document.getElementById("phone").value.trim();
                let email = document.getElementById("email").value.trim();

                if (supplierCode.length < 3) {
                    alert("Mã nhà cung cấp phải có ít nhất 3 ký tự.");
                    return false;
                }
                if (supplierName.length < 3) {
                    alert("Tên nhà cung cấp phải có ít nhất 3 ký tự.");
                    return false;
                }
                if (!/^[0-9]{10}$/.test(phone)) {
                    alert("Số điện thoại phải có 10 chữ số.");
                    return false;
                }
                if (!/\S+@\S+\.\S+/.test(email)) {
                    alert("Email không hợp lệ.");
                    return false;
                }

                return true;
            }
        </script>
    </body>
</html>
