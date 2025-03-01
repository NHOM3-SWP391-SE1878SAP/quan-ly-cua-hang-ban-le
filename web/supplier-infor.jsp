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
      .info-card {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
      }
      
      .info-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
      }
      
      .info-title {
        font-size: 1.2em;
        font-weight: 600;
        color: #333;
      }
      
      .info-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
      }
      
      .info-item {
        margin-bottom: 15px;
      }
      
      .info-label {
        color: #666;
        font-size: 0.9em;
        margin-bottom: 5px;
      }
      
      .info-value {
        color: #333;
        font-weight: 500;
      }
      
      .info-input {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      
      .info-textarea {
        width: 100%;
        min-height: 100px;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        resize: vertical;
      }
      
      .tabs {
        display: flex;
        border-bottom: 1px solid #ddd;
        margin-bottom: 20px;
      }
      
      .tab {
        padding: 10px 20px;
        cursor: pointer;
        color: #666;
        font-weight: 500;
        border-bottom: 2px solid transparent;
      }
      
      .tab.active {
        color: #00c853;
        border-bottom-color: #00c853;
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
          <div class="col-12">
            <div class="info-card">
              <div class="info-header">
                <div class="info-title">Thông tin nhà cung cấp</div>
                <div class="status">
                  <span class="badge ${supplier.status ? 'badge-active' : 'badge-inactive'}">
                    ${supplier.status ? 'Hoạt động' : 'Ngưng hoạt động'}
                  </span>
                </div>
              </div>

              <div class="tabs">
                <div class="tab active">Thông tin</div>
                <div class="tab" onclick="window.location.href='supplier-purchase-history.jsp?id=${supplier.id}'">
                  Lịch sử nhập/trả hàng
                </div>
                <div class="tab" onclick="window.location.href='supplier-payment.jsp?id=${supplier.id}'">
                  Nợ cần trả NCC
                </div>
              </div>

              <form action="supplier" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${supplier.id}">
                
                <div class="info-grid">
                  <div class="info-item">
                    <div class="info-label">Mã nhà cung cấp</div>
                    <input type="text" class="info-input" name="supplierCode" value="${supplier.supplierCode}" readonly>
                  </div>
                  <div class="info-item">
                    <div class="info-label">Tên công ty</div>
                    <input type="text" class="info-input" name="companyName" value="${supplier.companyName}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Tên nhà cung cấp</div>
                    <input type="text" class="info-input" name="supplierName" value="${supplier.supplierName}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Mã số thuế</div>
                    <input type="text" class="info-input" name="taxCode" value="${supplier.taxCode}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Địa chỉ</div>
                    <input type="text" class="info-input" name="address" value="${supplier.address}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Nhóm NCC</div>
                    <input type="text" class="info-input" name="supplierGroup" value="${supplier.supplierGroup}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Khu vực</div>
                    <input type="text" class="info-input" name="region" value="${supplier.region}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Phường xã</div>
                    <input type="text" class="info-input" name="ward" value="${supplier.ward}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Điện thoại</div>
                    <input type="text" class="info-input" name="phone" value="${supplier.phone}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Email</div>
                    <input type="text" class="info-input" name="email" value="${supplier.email}">
                  </div>
                  <div class="info-item">
                    <div class="info-label">Nợ hiện tại</div>
                    <div class="info-value">${supplier.currentDebt}</div>
                  </div>
                  <div class="info-item">
                    <div class="info-label">Tổng mua</div>
                    <div class="info-value">${supplier.totalPurchase}</div>
                  </div>
                  <div class="info-item">
                    <div class="info-label">Người tạo</div>
                    <div class="info-value">${supplier.createdBy}</div>
                  </div>
                  <div class="info-item">
                    <div class="info-label">Ngày tạo</div>
                    <div class="info-value">${supplier.createdDate}</div>
                  </div>
                </div>

                <div class="info-item mt-4">
                  <div class="info-label">Ghi chú</div>
                  <textarea class="info-textarea" name="notes">${supplier.notes}</textarea>
                </div>

                <div class="d-flex justify-content-end gap-2 mt-4">
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
