<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title>Thông tin nhà cung cấp - SLIM</title>
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

      .nav-tabs .nav-link {
        color: #666;
        font-weight: 500;
      }

      .nav-tabs .nav-link.active {
        color: #00c853;
        border-color: #00c853;
      }

      .form-label {
        color: #666;
        font-size: 0.9em;
        margin-bottom: 5px;
      }
    </style>
  </head>

  <body>
    <!-- ======= Header ======= -->
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>Chi tiết nhà cung cấp</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item"><a href="supplier?action=list">Nhà cung cấp</a></li>
            <li class="breadcrumb-item active">Chi tiết</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="row">
          <div class="col-lg-3">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Thao tác nhanh</h5>
                <div class="d-grid gap-2">
                  <button type="button" class="btn btn-primary" onclick="window.location.href='supplier-purchase-history.jsp?id=${supplier.id}'">
                    <i class="bi bi-clock-history"></i> Lịch sử nhập/trả hàng
                  </button>
                  <button type="button" class="btn btn-success" onclick="window.location.href='supplier-payment.jsp?id=${supplier.id}'">
                    <i class="bi bi-cash-coin"></i> Nợ cần trả NCC
                  </button>
                  <button type="button" class="btn btn-info text-white">
                    <i class="bi bi-download"></i> Xuất thông tin
                  </button>
                </div>

                <hr>

                <div class="text-center mb-3">
                  <span class="badge ${supplier.status ? 'badge-active' : 'badge-inactive'} fs-6">
                    ${supplier.status ? 'Đang hoạt động' : 'Ngưng hoạt động'}
                  </span>
                </div>

                <div class="mb-3">
                  <label class="form-label">Nợ hiện tại</label>
                  <div class="fs-5 text-end">${supplier.currentDebt}</div>
                </div>

                <div class="mb-3">
                  <label class="form-label">Tổng mua</label>
                  <div class="fs-5 text-end">${supplier.totalPurchase}</div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-lg-9">
            <div class="card">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <h5 class="card-title mb-0">Thông tin nhà cung cấp</h5>
                </div>

                <ul class="nav nav-tabs mb-3">
                  <li class="nav-item">
                    <a class="nav-link active" href="#">Thông tin</a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link" href="supplier-purchase-history.jsp?id=${supplier.id}">Lịch sử nhập/trả hàng</a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link" href="supplier-payment.jsp?id=${supplier.id}">Nợ cần trả NCC</a>
                  </li>
                </ul>

                <form action="supplier" method="POST" class="row g-3">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${supplier.id}">
                
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Mã nhà cung cấp</label>
                      <input type="text" class="form-control" name="supplierCode" value="${supplier.supplierCode}" readonly>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Tên công ty</label>
                      <input type="text" class="form-control" name="companyName" value="${supplier.companyName}">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Tên nhà cung cấp</label>
                      <input type="text" class="form-control" name="supplierName" value="${supplier.supplierName}">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Mã số thuế</label>
                      <input type="text" class="form-control" name="taxCode" value="${supplier.taxCode}">
                    </div>
                  </div>
                  <div class="col-md-12">
                    <div class="form-group">
                      <label class="form-label">Địa chỉ</label>
                      <input type="text" class="form-control" name="address" value="${supplier.address}">
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="form-label">Nhóm NCC</label>
                      <input type="text" class="form-control" name="supplierGroup" value="${supplier.supplierGroup}">
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="form-label">Khu vực</label>
                      <input type="text" class="form-control" name="region" value="${supplier.region}">
                    </div>
                  </div>
                  <div class="col-md-4">
                    <div class="form-group">
                      <label class="form-label">Phường xã</label>
                      <input type="text" class="form-control" name="ward" value="${supplier.ward}">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Điện thoại</label>
                      <input type="text" class="form-control" name="phone" value="${supplier.phone}">
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group">
                      <label class="form-label">Email</label>
                      <input type="text" class="form-control" name="email" value="${supplier.email}">
                    </div>
                  </div>
                  <div class="col-md-12">
                    <div class="form-group">
                      <label class="form-label">Ghi chú</label>
                      <textarea class="form-control" name="notes" rows="3">${supplier.notes}</textarea>
                    </div>
                  </div>

                  <div class="col-12">
                    <div class="alert alert-info">
                      <small>
                        <i class="bi bi-info-circle"></i>
                        Người tạo: ${supplier.createdBy} - Ngày tạo: ${supplier.createdDate}
                      </small>
                    </div>
                  </div>

                  <div class="col-12 text-end">
                  <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-lg"></i> Cập nhật
                  </button>
                  <button type="button" class="btn btn-warning" 
                          onclick="if(confirm('Bạn có chắc muốn ngưng hoạt động nhà cung cấp này?')) {
                            document.getElementById('statusForm').submit();
                          }">
                    <i class="bi bi-pause-circle"></i> Ngưng hoạt động
                  </button>
                  <button type="button" class="btn btn-danger"
                          onclick="if(confirm('Bạn có chắc muốn xóa nhà cung cấp này?')) {
                            window.location.href = 'supplier?action=delete&id=${supplier.id}';
                          }">
                    <i class="bi bi-trash"></i> Xóa
                  </button>
                  <a href="supplier?action=list" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                  </a>
                </div>
              </form>

              <form id="statusForm" action="supplier" method="POST" style="display: none;">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${supplier.id}">
                <input type="hidden" name="status" value="false">
              </form>
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
    
    <script>
      // Set active tab based on action parameter
      document.addEventListener('DOMContentLoaded', function() {
          const urlParams = new URLSearchParams(window.location.search);
          const action = urlParams.get('action');
          const tabs = document.querySelectorAll('.tab');
          
          tabs.forEach(tab => tab.classList.remove('active'));
          
          switch(action) {
              case 'history':
                  tabs[1].classList.add('active');
                  break;
              case 'debt':
                  tabs[2].classList.add('active');
                  break;
              default:
                  tabs[0].classList.add('active');
          }
      });
    </script>
  </body>
</html>
