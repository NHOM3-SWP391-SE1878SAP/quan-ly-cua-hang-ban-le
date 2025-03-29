<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />

        <title>Quản lý nhà cung cấp - SLIM</title>
        <meta content="" name="description" />
        <meta content="" name="keywords" />

        <!-- Favicons -->
        <link href="assets/img/favicon.png" rel="icon" />
        <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon" />

        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect" />
        <link
            href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
            rel="stylesheet"
            />

        <!-- Vendor CSS Files -->
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet" />
        <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
        <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet" />
        <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
        <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />

        <!-- Template Main CSS File -->
        <link href="assets/css/style.css" rel="stylesheet" />

        <style>
            .table tbody tr {
                cursor: pointer;
            }

            .table tbody tr:hover {
                background-color: #f5f5f5;
                transition: background-color 0.2s ease;
            }

            .badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
            }

            .badge-active {
                background-color: #00c853;
                color: white;
            }

            .badge-inactive {
                background-color: #757575;
                color: white;
            }

            .action-btn {
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 14px;
            }
            /* Custom styles for the form */
            form {
                width: 100%;
                max-width: 500px;
                margin: auto;
            }

            .form-group .form-check {
                padding-left: 20px;
            }

        </style>
    </head>

    <body>
        <!-- ======= Header ======= -->
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Quản lý nhà cung cấp</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                        <li class="breadcrumb-item active">Nhà cung cấp</li>
                    </ol>
                </nav>
            </div>
            <a href="AddSupplier.jsp" class="btn btn-primary mb-3">Thêm Nhà Cung Cấp</a>
            <section class="section">
                <div class="row">
                    <div class="col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Lọc nhà cung cấp theo trạng thái</h5>
                                <form action="SuppliersControllerURL" method="get" class="p-4 border rounded shadow-sm bg-light">
                                    <input type="hidden" name="service" value="listAll"> 

                                    <div class="form-group mb-3">
                                        <label for="status" class="form-label">Trạng thái:</label>

                                        <!-- Radio button for All -->
                                        <div class="form-check">
                                            <input type="radio" id="all" name="status" value="all" class="form-check-input" checked>
                                            <label for="all" class="form-check-label">Tất cả</label>
                                        </div>

                                        <!-- Radio button for Active -->
                                        <div class="form-check">
                                            <input type="radio" id="active" name="status" value="true" class="form-check-input">
                                            <label for="active" class="form-check-label">Đang hoạt động</label>
                                        </div>

                                        <!-- Radio button for Inactive -->
                                        <div class="form-check">
                                            <input type="radio" id="inactive" name="status" value="false" class="form-check-input">
                                            <label for="inactive" class="form-check-label">Ngưng hoạt động</label>
                                        </div>
                                    </div>

                                    <!-- Submit Button -->
                                    <div class="form-group">
                                        <button type="submit" class="btn btn-primary">Lọc</button>
                                    </div>
                                </form>

                            </div>
                        </div>
                    </div>

                    <div class="col-lg-10">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Danh sách nhà cung cấp</h5>

                                <table class="table datatable">
                                    <thead>
                                        <tr>
                                            <th>Mã NCC</th>
                                            <th>Tên NCC</th>
                                            <th>Điện thoại</th>
                                            <th>Email</th>
                                            <!--                                            <th>Nợ hiện tại (VNĐ)</th>-->
                                            <th>Tổng mua (VNĐ)</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${suppliers}" var="s">
                                            <tr onclick="showSupplierDetail('${s.supplierCode}', '${s.supplierName}', '${s.companyName}', '${s.taxCode}', 
                                                        '${s.phone}', '${s.address}', '${s.email}', '${s.region}', '${s.ward}', 
                                                        '${s.createdBy}', '${s.createdDate}', '${s.notes}', '${s.supplierGroup}', 
                                                        '${s.totalPurchase}', '${s.currentDebt}', '${s.status}')">
                                                <td>${s.supplierCode}</td>
                                                <td>${s.supplierName}</td>
                                                <td>${s.phone}</td>
                                                <td>${s.email}</td>
                                                <!--<td></td>-->
                                                <td><fmt:formatNumber value="${s.totalPurchase}" type="number" groupingUsed="true" /> VNĐ</td>
                                                <td>
                                                    <span class="badge ${s.status ? 'badge-active' : 'badge-inactive'}">
                                                        ${s.status ? 'Hoạt động' : 'Ngưng hoạt động'}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a class="btn btn-warning btn-sm" href="SuppliersControllerURL?service=editSupplier&id=${s.id}">Cập nhật</a>
                                                    <a class="btn btn-danger btn-sm" href="SuppliersControllerURL?service=deleteSupplier&id=${s.id}" 
                                                       onclick="return confirm('Bạn có chắc chắn Xóa bỏ Nhà Cung Cấp Mã ${s.supplierCode} không?')">Hủy bỏ</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <!-- Modal Hiển thị thông tin nhà cung cấp -->
        <div class="modal fade" id="supplierDetailModal" tabindex="-1" aria-labelledby="supplierDetailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="supplierDetailModalLabel">Thông tin Nhà Cung Cấp</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <th>Mã NCC <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalSupplierCode"></td>
                                </tr>
                                <tr>
                                    <th>Tên NCC <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalSupplierName"></td>
                                </tr>
                                <tr>
                                    <th>Công ty </th><td style="text-align: center; font-weight: bold; font-style: italic;" id="modalCompanyName"></td>
                                </tr>
                                <tr>
                                    <th>Mã số thuế </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalTaxCode"></td>
                                </tr>
                                <tr>
                                    <th>Điện thoại <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalPhone"></td>
                                </tr>
                                <tr>
                                    <th>Địa chỉ </th><td style="text-align: center; font-weight: bold; font-style: italic;" id="modalAddress"></td>
                                </tr>
                                <tr>
                                    <th>Email <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalEmail"></td>
                                </tr>
                                <tr>
                                    <th>Khu vực </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalRegion"></td>
                                </tr>
                                <tr>
                                    <th>Phường/Xã </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalWard"></td>
                                </tr>
                                <tr>
                                    <th>Người tạo </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalCreatedBy"></td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalCreatedDate"></td>
                                </tr>
                                <tr>
                                    <th>Ghi chú </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalNotes"></td>
                                </tr>
                                <tr>
                                    <th>Nhóm NCC </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalSupplierGroup"></td>
                                </tr>
                                <tr>
                                    <th>Tổng mua <a style="font-weight: bold; color: red">*</a></th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalTotalPurchase"></td>
                                </tr>
                                <tr>
                                    <th>Nợ hiện tại </th>
                                    <td style="text-align: center; font-weight: bold; font-style: italic;" id="modalCurrentDebt"></td>
                                </tr>
                                <tr>
                                    <th>Trạng thái <a style="font-weight: bold; color: red">*</a>
                                    </th><td style="text-align: center; font-weight: bold; font-style: italic; color: #0080ff" id="modalStatus"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

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
        <script>
            function showSupplierDetail(supplierCode, supplierName, companyName, taxCode, phone, address, email, region, ward, createdBy, createdDate, notes, supplierGroup, totalPurchase, currentDebt, status) {
            // Gán giá trị vào modal
                document.getElementById("modalSupplierCode").textContent = supplierCode;
                document.getElementById("modalSupplierName").textContent = supplierName;
                document.getElementById("modalCompanyName").textContent = companyName || "Đang để trống";
                document.getElementById("modalTaxCode").textContent = taxCode || "Đang để trống";
                document.getElementById("modalPhone").textContent = phone;
                document.getElementById("modalAddress").textContent = address || "Đang để trống";
                document.getElementById("modalEmail").textContent = email;
                document.getElementById("modalRegion").textContent = region || "Đang để trống";
                document.getElementById("modalWard").textContent = ward || "Đang để trống";
                document.getElementById("modalCreatedBy").textContent = createdBy || "Đang để trống";
                document.getElementById("modalCreatedDate").textContent = createdDate || "Đang để trống";
                document.getElementById("modalNotes").textContent = notes || "Đang để trống";
                document.getElementById("modalSupplierGroup").textContent = supplierGroup || "Đang để trống";
                document.getElementById("modalTotalPurchase").textContent = new Intl.NumberFormat('vi-VN').format(totalPurchase) + " VNĐ";
                document.getElementById("modalCurrentDebt").textContent = new Intl.NumberFormat('vi-VN').format(currentDebt) + " VNĐ";
                document.getElementById("modalStatus").textContent = status === "true" ? "Hoạt động" : "Ngưng hoạt động";

                // Hiển thị modal
                var supplierModal = new bootstrap.Modal(document.getElementById('supplierDetailModal'));
                supplierModal.show();
            }
        </script>
    </body>
</html>
