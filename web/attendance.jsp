<%@ page import="entity.Shift" %>
<%@ page import="entity.Employee" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession sessionUser = request.getSession();
    Employee employee = (Employee) sessionUser.getAttribute("employee");
    Shift currentShift = (Shift) sessionUser.getAttribute("currentShift");
    String shiftMessage = (String) sessionUser.getAttribute("shiftMessage");

    if (employee == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Chấm công nhân viên</title>

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

  <style>
    /* Center the main content */
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
      background-color: #f8f9fa;
    }

    .container {
      max-width: 600px;
      width: 100%;
    }

    .section {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 100%;
    }

    .card {
      width: 100%;
      max-width: 500px;
      margin: auto;
    }

    .card-body {
      padding: 20px;
      text-align: center;
    }

    h5.card-title {
      margin-bottom: 20px;
    }

    form {
      margin-top: 20px;
    }

    .btn-primary {
      width: 100%;
    }
  </style>
</head>

<body>


            <div class="col-lg-6 col-md-8 d-flex flex-column align-items-center justify-content-center">

              <div class="d-flex justify-content-center py-4">
                <a href="index.html" class="logo d-flex align-items-center w-auto">
                  <img src="assets/img/logo.png" alt="">
                  <span class="d-none d-lg-block">Your Company</span>
                </a>
              </div><!-- End Logo -->

              <div class="card mb-3">
                <div class="card-body">

                  <h5 class="card-title pb-0 fs-4">Chấm công nhân viên</h5>
                  <p class="text-center small">Thông tin ca làm hiện tại của bạn</p>

                  <div class="pt-4 pb-2">
                    <h5 class="text-center">Chào <%= employee.getEmployeeName() %>, đây là ca làm hiện tại:</h5>
                    <div class="col-12">
                        <% if (currentShift != null) { %>
                            <p><strong>Ca làm:</strong> <%= currentShift.getShiftName() %></p>
                            <p><strong>Thời gian:</strong> <%= currentShift.getStartTime() %> - <%= currentShift.getEndTime() %></p>
                        <% } else { %>
                            <p><strong>Không có ca làm nào phù hợp với giờ hiện tại.</strong></p>
                        <% } %>
                    </div>

                    <% if (shiftMessage != null) { %>
                        <p style="color: red;"><%= shiftMessage %></p>
                    <% } %>

                    <% if (currentShift != null && "Bạn đang trong ca làm của mình.".equals(shiftMessage)) { %>
                        <form action="AttendanceController" method="post">
                            <input type="hidden" name="action" value="markAttendance">
                            <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
                            <input type="hidden" name="shiftID" value="<%= currentShift.getShiftId() %>">

                            <label>Bạn có đi làm hôm nay không?</label><br>
                            <input type="radio" name="isPresent" value="yes" checked> Có
                            <input type="radio" name="isPresent" value="no"> Không

                            <button class="btn btn-primary" type="submit">Chấm công</button>
                        </form>
                    <% } %>
                  </div>
                </div>
              </div>

            </div>



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
