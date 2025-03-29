<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm Nhà Cung Cấp</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@ include file="HeaderAdmin.jsp" %>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Thêm Nhà Cung Cấp</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="SuppliersControllerURL?service=listAll">Quản lý Nhà Cung Cấp</a></li>
                        <li class="breadcrumb-item active">Thêm Nhà Cung Cấp</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Thêm Nhà Cung Cấp Mới</h5>

                                <%-- Hiển thị thông báo lỗi nếu có --%>
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger">${errorMessage}</div>
                                </c:if>

                                <form action="SuppliersControllerURL" method="post" onsubmit="return validateForm()">
                                    <input type="hidden" name="service" value="addSupplier">

                                    <div class="row">
                                        <!-- Cột 1 -->
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="supplierCode" class="form-label">Mã Nhà Cung Cấp</label>
                                                <input type="text" class="form-control" id="supplierCode" name="supplierCode" placeholder="NCC001" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="supplierName" class="form-label">Tên Nhà Cung Cấp</label>
                                                <input type="text" class="form-control" id="supplierName" name="supplierName" placeholder="Tên nhà cung cấp" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="phone" class="form-label">Số Điện Thoại</label>
                                                <input type="text" class="form-control" id="phone" name="phone" placeholder="Số điện thoại" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="companyName" class="form-label">Tên Công Ty</label>
                                                <input type="text" class="form-control" id="companyName" name="companyName" placeholder="Tên công ty">
                                            </div>
                                            <div class="mb-3">
                                                <label for="taxCode" class="form-label">Mã Số Thuế</label>
                                                <input type="text" class="form-control" id="taxCode" name="taxCode" placeholder="Mã số thuế">
                                            </div>
                                        </div>

                                        <!-- Cột 2 -->
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="email" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                                            </div>
                                            <div class="mb-3">
                                                <label for="address" class="form-label">Địa Chỉ</label>
                                                <input type="text" class="form-control" id="address" name="address" placeholder="Địa chỉ">
                                            </div>
                                            <div class="mb-3">
                                                <label for="region" class="form-label">Khu Vực</label>
                                                <input type="text" class="form-control" id="region" name="region" placeholder="Khu vực">
                                            </div>
                                            <div class="mb-3">
                                                <label for="ward" class="form-label">Phường/Xã</label>
                                                <input type="text" class="form-control" id="ward" name="ward" placeholder="Phường/Xã">
                                            </div>
                                            <div class="mb-3">
                                                <label for="createdBy" class="form-label">Người Tạo</label>
                                                <input type="text" class="form-control" id="createdBy" name="createdBy" placeholder="Người tạo" >
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="createdDate" class="form-label">Ngày Tạo</label>
                                                <input type="date" class="form-control" id="createdDate" name="createdDate" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="notes" class="form-label">Ghi Chú</label>
                                                <textarea class="form-control" id="notes" name="notes" placeholder="Ghi chú"></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="status" class="form-label">Trạng Thái</label>
                                                <select class="form-select" id="status" name="status" required>
                                                    <option value="true">Hoạt động</option>
                                                    <option value="false">Ngưng hoạt động</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="supplierGroup" class="form-label">Nhóm Nhà Cung Cấp</label>
                                                <input type="text" class="form-control" id="supplierGroup" name="supplierGroup" placeholder="Nhóm nhà cung cấp">
                                            </div>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-primary">Thêm Nhà Cung Cấp</button>
                                    <a href="SuppliersControllerURL?service=listAll" class="btn btn-secondary">Quay Lại</a>
                                </form>
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
