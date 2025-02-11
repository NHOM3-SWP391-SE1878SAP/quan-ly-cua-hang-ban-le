
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
        <%@include file="HeaderAdmin.jsp"%>
  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Hóa đơn</h1>
      
      <div class="card">
        <div class="card-body">
          <div class="row mb-3">
            <label for="monthFilter" class="col-sm-2 col-form-label">Lọc theo tháng:</label>
            <div class="col-sm-4">
              <select id="monthFilter" class="form-select" onchange="filterByMonth()">
                <option value="">Tất cả</option>
                <option value="01">Tháng 1</option>
                <option value="02">Tháng 2</option>
                <option value="03">Tháng 3</option>
                <option value="04">Tháng 4</option>
                <option value="05">Tháng 5</option>
                <option value="06">Tháng 6</option>
                <option value="07">Tháng 7</option>
                <option value="08">Tháng 8</option>
                <option value="09">Tháng 9</option>
                <option value="10">Tháng 10</option>
                <option value="11">Tháng 11</option>
                <option value="12">Tháng 12</option>
              </select>
            </div>
          </div>

          <table class="table datatable" id="invoiceTable">
            <thead>
              <tr>
                <th>Mã hóa đơn</th>
                <th>Thời gian</th>
                <th>Mã trả hàng</th>
                <th>Khách hàng</th>
                <th>Tổng tiền</th>
                <th>Giảm giá</th>
                <th>Khách đã trả</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>HD000046</td>
                <td>06/02/2025 08:38</td>
                <td>TH000002</td>
                <td>Nguyễn Văn Hải</td>
                <td>1,854,000</td>
                <td>0</td>
                <td>1,854,000</td>
              </tr>
              <tr>
                <td>HD000045</td>
                <td>05/02/2025 08:37</td>
                <td></td>
                <td>Anh Hoàng - Sài Gòn</td>
                <td>262,000</td>
                <td>0</td>
                <td>262,000</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
<!-- Vendor JS Files -->
<script>
    function filterByMonth() {
      let selectedMonth = document.getElementById("monthFilter").value;
      let table = document.getElementById("invoiceTable");
      let rows = table.getElementsByTagName("tr");

      for (let i = 1; i < rows.length; i++) {
        let dateCell = rows[i].getElementsByTagName("td")[1];
        if (dateCell) {
          let dateText = dateCell.textContent || dateCell.innerText;
          let month = dateText.split("/")[1];
          if (selectedMonth === "" || month === selectedMonth) {
            rows[i].style.display = "";
          } else {
            rows[i].style.display = "none";
          }
        }
      }
    }
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
