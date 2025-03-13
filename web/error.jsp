<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lỗi - SLIM</title>
    
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
      .error-container {
        text-align: center;
        padding: 50px 20px;
      }
      
      .error-icon {
        font-size: 80px;
        color: #f44336;
        margin-bottom: 20px;
      }
      
      .error-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 15px;
      }
      
      .error-message {
        font-size: 18px;
        margin-bottom: 30px;
        color: #555;
      }
      
      .error-actions {
        margin-top: 30px;
      }
    </style>
  </head>
  <body>
    <!-- ======= Header ======= -->
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>Lỗi</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item active">Lỗi</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="row">
          <div class="col-lg-12">
            <div class="card">
              <div class="card-body">
                <div class="error-container">
                  <div class="error-icon">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                  </div>
                  <div class="error-title">Đã xảy ra lỗi!</div>
                  <div class="error-message">
                    <c:choose>
                      <c:when test="${not empty errorMessage}">
                        ${errorMessage}
                      </c:when>
                      <c:otherwise>
                        Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="error-actions">
                    <a href="javascript:history.back()" class="btn btn-secondary">
                      <i class="bi bi-arrow-left"></i> Quay lại
                    </a>
                    <a href="index.html" class="btn btn-primary">
                      <i class="bi bi-house"></i> Trang chủ
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- ======= Footer ======= -->
    <footer id="footer" class="footer">
      <div class="copyright">
        &copy; Copyright <strong><span>SLIM</span></strong>. All Rights Reserved
      </div>
      <div class="credits">
        Designed by <a href="#">FPT University</a>
      </div>
    </footer><!-- End Footer -->

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