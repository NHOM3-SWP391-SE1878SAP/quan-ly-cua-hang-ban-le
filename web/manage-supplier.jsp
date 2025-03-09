<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <li class="breadcrumb-item">Quản lý</li>
            <li class="breadcrumb-item active">Nhà cung cấp</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="row">
          <div class="col-lg-3">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Tìm kiếm & Lọc</h5>
                <form id="searchForm" action="supplier" method="GET">
                  <input type="hidden" name="action" value="search" />
                  <div class="mb-3">
                    <input type="text" name="code" class="form-control" placeholder="Mã nhà cung cấp"/>
                  </div>
                  <div class="mb-3">
                    <input type="text" name="name" class="form-control" placeholder="Tên nhà cung cấp"/>
                  </div>
                  <div class="mb-3">
                    <input type="text" name="phone" class="form-control" placeholder="Số điện thoại"/>
                  </div>
                  <div class="mb-3">
                    <input type="text" name="company" class="form-control" placeholder="Tên công ty"/>
                  </div>
                  <div class="mb-3">
                    <select name="status" class="form-select">
                      <option value="">-- Trạng thái --</option>
                      <option value="true">Đang hoạt động</option>
                      <option value="false">Ngưng hoạt động</option>
                    </select>
                  </div>
                  <div class="mb-3">
                    <button type="submit" class="btn btn-primary w-100">
                      <i class="bi bi-search"></i> Tìm kiếm
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <div class="col-lg-9">
            <div class="card">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <h5 class="card-title">Danh sách nhà cung cấp</h5>
                  <div>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                      <i class="bi bi-plus-circle"></i> Thêm mới
                    </button>
                    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#importSupplierModal">
                      <i class="bi bi-upload"></i> Import
                    </button>
                    <button class="btn btn-info">
                      <i class="bi bi-download"></i> Export
                    </button>
                  </div>
                </div>

                <table class="table datatable">
                  <thead>
                    <tr>
                      <th>Mã NCC</th>
                      <th>Tên NCC</th>
                      <th>Công ty</th>
                      <th>Điện thoại</th>
                      <th>Email</th>
                      <th>Nợ hiện tại</th>
                      <th>Tổng mua</th>
                      <th>Trạng thái</th>
                      <th>Thao tác</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${suppliers}" var="s">
                      <tr onclick="goToSupplierDetail('${s.id}')">
                        <td>${s.supplierCode}</td>
                        <td>${s.supplierName}</td>
                        <td>${s.companyName}</td>
                        <td>${s.phone}</td>
                        <td>${s.email}</td>
                        <td>${s.currentDebt}</td>
                        <td>${s.totalPurchase}</td>
                        <td>
                          <span class="badge ${s.status ? 'badge-active' : 'badge-inactive'}">
                            ${s.status ? 'Hoạt động' : 'Ngưng hoạt động'}
                          </span>
                        </td>
                        <td>
                          <button class="btn btn-sm btn-primary action-btn" onclick="editSupplier(event, '${s.id}')">
                            <i class="bi bi-pencil"></i>
                          </button>
                          <button class="btn btn-sm btn-danger action-btn" onclick="deleteSupplier(event, '${s.id}')">
                            <i class="bi bi-trash"></i>
                          </button>
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

    <!-- Include modals -->
    <jsp:include page="modal-add-supplier.jsp"/>
    <jsp:include page="model-import-supplier.jsp"/>
    <jsp:include page="add-group-modal.jsp"/>
    <jsp:include page="modal-edit-supplier.jsp"/>

    <script>
      function goToSupplierDetail(id) {
        window.location.href = "supplier?action=view&id=" + id;
      }

      function editSupplier(event, id) {
        event.stopPropagation();
        const editForm = document.createElement("form");
        editForm.style.display = "none";
        editForm.method = "GET";
        editForm.action = "supplier";
        editForm.innerHTML = 
          '<input type="hidden" name="id" value="' + id + '">' +
          '<input type="hidden" name="action" value="edit">';
        document.body.appendChild(editForm);
        editForm.submit();
      }

      function deleteSupplier(event, id) {
        event.stopPropagation();
        if (confirm("Bạn có chắc muốn xóa nhà cung cấp này?")) {
          window.location.href = "supplier?action=delete&id=" + id;
        }
      }

      document.getElementById("searchForm").addEventListener("submit", function(e) {
        e.preventDefault();
        const formData = new FormData(this);
        const params = new URLSearchParams();

        for (let pair of formData.entries()) {
          if (pair[1]) {
            params.append(pair[0], pair[1]);
          }
        }

        window.location.href = "supplier?" + params.toString();
      });
    </script>
  </body>
</html>
