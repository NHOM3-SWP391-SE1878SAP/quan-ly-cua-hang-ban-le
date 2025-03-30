<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%
  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
  String currentDate = sdf.format(new Date());
%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Dashboard - NiceAdmin Bootstrap Template</title>
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
<!-- Add these in HEAD section -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>

  <!-- ======= Header ======= -->
  <header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="index.html" class="logo d-flex align-items-center">
        <img src="assets/img/logo.png" alt="">
        <span class="d-none d-lg-block">Slim</span>
      </a>
      <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

   

    <<nav class="header-nav ms-auto">
    <ul class="d-flex align-items-center">
        <li class="nav-item dropdown pe-3">
            <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                <img src="assets/img/admin.png" alt="Profile" class="rounded-circle">
                <span class="d-none d-md-block dropdown-toggle ps-2">thangnd</span>
            </a>

            <!-- Dropdown Menu -->
            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                <li class="dropdown-header">
                    <h6>thangnd</h6>
                    <span>Admin</span>
                </li>
                
                <li><hr class="dropdown-divider"></li>

                <li>
                    <a class="dropdown-item" href="change-password.jsp">
                        <i class="bi bi-question-circle"></i> Đổi mật khẩu
                    </a>
                </li>
                
                <li><hr class="dropdown-divider"></li>

                <li>
                    <a class="dropdown-item d-flex align-items-center" href="/Logout">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Sign Out</span>
                    </a>
                </li>
            </ul>
        </li>
    </ul>
</nav>

  </header><!-- End Header -->

  <!-- ======= Sidebar ======= -->
  <aside id="sidebar" class="sidebar">

    <ul class="sidebar-nav" id="sidebar-nav">

      <li class="nav-item">
        <a class="nav-link " href="SalesReport.jsp">
          <i class="ri-eye-fill"></i>
          <span>Tổng quan</span>
        </a>
      </li><!-- End Dashboard Nav -->

      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#components-nav" data-bs-toggle="collapse" href="#">
          <i class="bi-box-seam"></i><span>Hàng hóa</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="components-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
          <li>
            <a href="ProductsControllerURL?service=listAll">
              <i class="bi bi-circle"></i><span>Danh mục</span>
            </a>
          </li>
         <li>
            <a href="ProductsControllerURL?service=setPrice">
              <i class="bi bi-circle"></i><span>Thiết lập giá</span>
            </a>
          </li>
           <li>
            <a href="ProductsControllerURL?service=stockTakes">
              <i class="bi bi-circle"></i><span>Kiểm kho</span>
            </a>
          </li>
          <li>
            <a href="CategoryControllerURL?service=listAll">
              <i class="bi bi-circle"></i><span>Loại hàng</span>
            </a>
          </li>
          <li>
            <a href="VoucherServlet">
              <i class="bi bi-circle"></i><span>Mã giảm giá</span>
            </a>
          </li>
          
        </ul>
      </li>

      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#forms-nav" data-bs-toggle="collapse" href="#">
          <i class="bi-arrow-left-right"></i><span>Giao dịch</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="forms-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
         
          <li>
            <a href="order">
              <i class="bi bi-circle"></i><span>Hóa đơn</span>
            </a>
          </li>
         
         
          <li>
            <a href="inventory">
              <i class="bi bi-circle"></i><span>Nhập hàng</span>
            </a>
          </li>
         
        </ul>
      </li><!-- End Forms Nav -->

      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#tables-nav" data-bs-toggle="collapse" href="#">
          <i class="ri-user-2-fill"></i><span>Đối tác</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="tables-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
          <li>
            <a href="CustomerServlet">
              <i class="bi bi-circle"></i><span>Khách hàng</span>
            </a>
          </li>
          <li>
            <a href="SuppliersControllerURL?service=listAll">
<!--            <a href="supplier">-->
              <i class="bi bi-circle"></i><span>Nhà cung cấp</span>
            </a>
          </li>
        </ul>
      </li><!-- End Tables Nav -->

      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#charts-nav" data-bs-toggle="collapse" href="#">
          <i class="ri-parent-fill"></i><span>Nhân viên</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="charts-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
          <li>
            <a href="EmployeeControllerURL?service=getAllEmployees">
              <i class="bi bi-circle"></i><span>Nhân viên</span>
            </a>
          </li>
          <li>
            <a href="WeeklyScheduleController">
              <i class="bi bi-circle"></i><span>Lịch làm việc</span>
            </a>
          </li>
          <li>
            <a href="WeeklyScheduleController?service=getAllAttendanceHistory">
              <i class="bi bi-circle"></i><span>Chấm công</span>
            </a>
          </li>
          <li>
            <a href="PayrollController">
              <i class="bi bi-circle"></i><span>Bảng tính lương</span>
            </a>
          </li>
        </ul>
      </li>
      
      <li class="nav-item">
        <a class="nav-link collapsed" href="">
          <i class="ri-coins-fill"></i>
          <span>Số quỹ</span>
        </a>
      </li>


      <li class="nav-item">
        <a class="nav-link collapsed" data-bs-target="#icons-nav" data-bs-toggle="collapse" href="#">
          <i class="ri-clipboard-fill"></i><span>Báo cáo</span><i class="bi bi-chevron-down ms-auto"></i>
        </a>
        <ul id="icons-nav" class="nav-content collapse " data-bs-parent="#sidebar-nav">
            <li>
            <a href="SalesReport1">
              <i class="bi bi-circle"></i><span>Bán hàng</span>
            </a>
          </li>
        
          <li>
            <a href="EmployeeControllerURL?service=salesReport&fromDate=<%= currentDate %>&toDate=<%= currentDate %>">
              <i class="bi bi-circle"></i><span>Nhân viên</span>
            </a>
          </li>
          
          <li>
            <a href="OrderDetailControllerURL?service=reportProduct&fromDate=<%= currentDate %>&toDate=<%= currentDate %>">
              <i class="bi bi-circle"></i><span>Sản phẩm</span>
            </a>
          </li>
        </ul>
      </li>

      
    </ul>

  </aside><!-- End Sidebar-->

  

  

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

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