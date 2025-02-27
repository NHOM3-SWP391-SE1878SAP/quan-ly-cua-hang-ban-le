
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Slim - Giao dịch - Hóa đơn</title>
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
    <body>
        
        <%@include file="HeaderAdmin.jsp"%>
  <main id="main" class="main">
        <div class="pagetitle">
            <h1>Nhân viên</h1>
            <div class="d-flex justify-content-between mb-3">
                <select id="statusFilter" class="form-select w-auto">
                    <option value="all">Tất cả</option>
                    <option value="Còn làm việc">Còn làm việc</option>
                    <option value="Nghỉ việc">Nghỉ việc</option>
                </select>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEmployeeModal" ><i class="bi-person-plus-fill"></i><span> Thêm Nhân Viên</span></button>
            </div>
            
            <div class="card">
                <div class="card-body">
                    <table class="table datatable" id="invoiceTable">
                        <thead>
                            <tr>
                                <th>Mã nhân viên</th>
                                <th>Mã chấm công</th>
                                <th>Tên nhân viên</th>
                                <th>Số điện thoại</th>
                                <th>Chi tiết</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>NV00001</td>
                                <td>CC00001</td>
                                <td>Nguyễn Đức Thắng</td>
                                <td>0962572118</td>
                                <td><button type="button" class="btn btn-outline-warning btn-sm" data-bs-toggle="modal" data-bs-target="#employeeDetailModal">Chi tiết</button></td>
                                <td><span class="badge rounded-pill bg-success">Còn làm việc</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
     <!-- Modal Thêm Nhân Viên -->
    <div class="modal fade" id="addEmployeeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Nhân Viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addEmployeeForm">
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <div class="mb-3">
                                    <label class="form-label">Ảnh đại diện</label>
                                    <input type="file" class="form-control" accept="image/*">
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="row">
                                    <div class="col-md-6">
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Tên nhân viên</label>
                                            <input type="text" class="form-control" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Ngày sinh</label>
                                            <input type="date" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Số CMND/CCCD</label>
                                            <input type="text" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        
                                        <div class="mb-3">
                                            <label class="form-label">Số điện thoại</label>
                                            <input type="text" class="form-control" required>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Email</label>
                                            <input type="email" class="form-control">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Địa chỉ</label>
                                            <input type="text" class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary">Thêm</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
   <!-- Modal Chi Tiết Nhân Viên -->
    <div class="modal fade" id="employeeDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi Tiết Nhân Viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <img src="assets/img/default-avatar.png" class="img-fluid" alt="Avatar">
                        </div>
                        <div class="col-md-8">
                            <p><strong>Mã nhân viên:</strong> NV00001</p>
                            <p><strong>Tên nhân viên:</strong> Nguyễn Đức Thắng</p>
                            <p><strong>Mã chấm công:</strong>CC00001</p>
                            <p><strong>Ngày sinh:</strong></p>
                            <p><strong>Giới tính:</strong></p>
                            <p><strong>Số CMND/CCCD:</strong></p>
                            <p><strong>Phòng ban:</strong></p>
                            <p><strong>Chức danh:</strong></p>
                            <p><strong>Số điện thoại:</strong>0962572118</p>
                            <p><strong>Email:</strong></p>
                            <p><strong>Facebook:</strong></p>
                            <p><strong>Địa chỉ:</strong></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
   
   <script>
        document.getElementById("statusFilter").addEventListener("change", function() {
            let selectedStatus = this.value;
            let rows = document.querySelectorAll("#invoiceTable tbody tr");
            rows.forEach(row => {
                let status = row.querySelector(".status").innerText;
                row.style.display = (selectedStatus === "all" || status === selectedStatus) ? "" : "none";
            });
        });
    </script>

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

