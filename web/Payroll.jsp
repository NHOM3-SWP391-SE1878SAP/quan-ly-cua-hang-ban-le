<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<%@ page import="entity.EmployeePayroll" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Bảng Lương Nhân Viên</title>

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">
</head>

<body>

    <%@ include file="HeaderAdmin.jsp" %>

    <main id="main" class="main">
        <div class="pagetitle">
            <h1>Bảng Lương Nhân Viên</h1>
        </div>
        <div class="d-flex mb-3">
    <div class="me-auto">
        <!-- Các phần form trước đó -->
    </div>
    <div class="ms-2">
                                <form action="ExportPayrollExcelServlet" method="GET">
    <input type="hidden" name="month" value="${selectedMonth}">
    <input type="hidden" name="year" value="${selectedYear}">
    <button type="submit" class="btn btn-success">
        <i class="bi bi-file-earmark-excel"></i> Xuất Excel
    </button>
</form>
    </div>
</div>
        <div class="container">
            <div class="d-flex mb-3">
                <div class="me-auto">
                    <form method="GET" action="PayrollController" class="d-flex">
                        <div class="input-group">
                            <label for="month" class="input-group-text">Tháng:</label>
                            <input type="number" id="month" name="month" min="1" max="12" class="form-control" value="<%= request.getAttribute("selectedMonth") %>">
                        </div>
                        <div class="input-group ms-2">
                            <label for="year" class="input-group-text">Năm:</label>
                            <input type="number" id="year" name="year" min="2000" max="2100" class="form-control" value="<%= request.getAttribute("selectedYear") %>">
                        </div>
                        <div class="ms-2">
                            <input type="submit" value="Xem lương" class="btn btn-primary">
                        </div>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-body">
                    <table class="table table-striped datatable" id="payrollTable">
                        <thead>
    <tr>
        <th>ID Nhân Viên</th>
        <th>Tên Nhân Viên</th>
        <th>Số Ngày Công</th>
                <th>Số Ngày Nghỉ</th> <!-- Thêm cột mới -->

        <th>Lương Cơ Bản</th>
        <th>Tổng Lương</th>
        <th>Ngày Thanh Toán</th>
        <th>Hành Động</th>
    </tr>
</thead>
<tbody>
    <% 
        Vector<EmployeePayroll> payrollList = (Vector<EmployeePayroll>) request.getAttribute("payrollList");
        if (payrollList != null && !payrollList.isEmpty()) {
            for (EmployeePayroll payroll : payrollList) { 
    %>
        <tr>
            <td>NV<%= payroll.getEmployee().getEmployeeID() %></td>
            <td><%= payroll.getEmployee().getEmployeeName() %></td>
            <td><%= payroll.getWorkDays() %></td>
                        <td><%= payroll.getOffDays() %></td> <!-- Hiển thị OffDays -->

            <td><%= payroll.getEmployee().getSalary() %></td>
             <td><%= 
    Math.max(
        payroll.getEmployee().getSalary() * payroll.getWorkDays() 
        - (payroll.getEmployee().getSalary() * 0.1 * payroll.getOffDays()), 
        0
    ) 
%></td>
            <td><%= payroll.getPayDate() != null ? payroll.getPayDate() : "Chưa thanh toán" %></td>
            <td>
                <% if (payroll.getPayDate() == null) { %>
                    <form method="POST" action="PayrollController">
                        <input type="hidden" name="payrollID" value="<%= payroll.getPayroll().getPayrollID() %>">
                        <input type="hidden" name="employeeID" value="<%= payroll.getEmployee().getEmployeeID() %>">
                        <input type="submit" name="payButton" value="Thanh toán" class="btn btn-success">
                    </form>
                <% } else { %>
                    <button class="btn btn-secondary" disabled>Đã thanh toán</button>
                <% } %>
            </td>
        </tr>
    <% 
            } 
        } else {
    %>
        <tr>
            <td colspan="7" class="text-center">Không có dữ liệu bảng lương!</td>
        </tr>
    <% } %>
</tbody>


                    </table>
                </div>
            </div>
        </div>

    </main>

    

    <!-- Bootstrap JS -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

   

</body>
</html>
