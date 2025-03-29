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

<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Chấm công | Slim</title>

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">

  <style>
    body {
      background-color: #f6f9ff;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      font-family: 'Nunito', sans-serif;
    }
    
    .attendance-container {
      max-width: 450px;
      width: 100%;
      padding: 20px;
    }
    
    .attendance-card {
      background: white;
      border-radius: 10px;
      box-shadow: 0 5px 25px rgba(65, 84, 241, 0.1);
      overflow: hidden;
      text-align: center;
      padding: 30px;
    }
    
    .employee-name {
      color: #4154f1;
      font-weight: 700;
      font-size: 1.5rem;
      margin-bottom: 5px;
    }
    
    .employee-role {
      color: #6c757d;
      margin-bottom: 30px;
    }
    
    .shift-info {
      background-color: #f6f9ff;
      padding: 15px;
      margin: 20px 0;
      border-radius: 8px;
    }
    
    .shift-name {
      font-weight: 600;
      color: #4154f1;
      margin-bottom: 5px;
    }
    
    .shift-time {
      color: #6c757d;
    }
    
    .btn-attendance {
      background-color: #4154f1;
      border: none;
      padding: 12px 30px;
      font-size: 1.1rem;
      font-weight: 600;
      margin-top: 20px;
      transition: all 0.3s;
    }
    
    .btn-attendance:hover {
      background-color: #3143b5;
      transform: translateY(-2px);
    }
    
    .status-message {
      margin-top: 20px;
      padding: 10px;
      border-radius: 5px;
      font-weight: 500;
    }
    
    .success-message {
      background-color: #d4edda;
      color: #155724;
    }
    
    .error-message {
      background-color: #f8d7da;
      color: #721c24;
    }
    
    .warning-message {
      background-color: #fff3cd;
      color: #856404;
    }
  </style>
</head>

<body>
  <div class="attendance-container">
    <div class="attendance-card">
      <div class="mb-4">
        <i class="bi bi-calendar-check" style="font-size: 3rem; color: #4154f1;"></i>
      </div>
      
      <h3 class="employee-name"><%= employee.getEmployeeName() %></h3>
      <p class="employee-role">Nhân viên</p>
      
      <% if (currentShift != null) { %>
        <div class="shift-info">
          <div class="shift-name">CA <%= currentShift.getShiftName().toUpperCase() %></div>
          <div class="shift-time">
            <%= currentShift.getStartTime() %> - <%= currentShift.getEndTime() %>
          </div>
        </div>
        
        <form action="AttendanceController" method="post">
          <input type="hidden" name="action" value="markAttendance">
          <input type="hidden" name="employeeID" value="<%= employee.getEmployeeID() %>">
          <input type="hidden" name="shiftID" value="<%= currentShift.getShiftId() %>">
          <input type="hidden" name="isPresent" value="true">
          
          <button type="submit" class="btn btn-primary btn-attendance">
            <i class="bi bi-check-circle"></i> CHẤM CÔNG
          </button>
        </form>
      <% } else { %>
        <div class="alert alert-warning">
          <i class="bi bi-exclamation-triangle"></i> 
          Hiện không phải ca làm của bạn
        </div>
      <% } %>
      
      <% if (shiftMessage != null) { %>
        <div class="status-message 
            <%= shiftMessage.contains("thành công") ? "success-message" : 
               shiftMessage.contains("lỗi") ? "error-message" : "warning-message" %>">
          <%= shiftMessage %>
        </div>
      <% } %>
    </div>
  </div>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>
</html>