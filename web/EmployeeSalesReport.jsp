<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, entity.EmployeeSalesReport"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Báo cáo bán hàng nhân viên</title>

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
    <style>
        .chart-container {
            height: 300px; /* Giảm chiều cao */
            margin: 20px 0;
            max-width: 800px; /* Giới hạn độ rộng */
            margin-left: auto;
            margin-right: auto;
        }
        .compact-table {
            font-size: 0.9em;
            max-width: 1000px;
            margin: 0 auto;
        }
        .compact-table th,
        .compact-table td {
            padding: 0.5rem;
        }
        h1 {
            color: #2c3e50;
            margin: 20px 0;
            font-size: 1.5rem;
        }
        .total-row {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .filter-form {
            max-width: 800px;
            margin: 0 auto 20px;
        }
    </style>
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>
    
    <main id="main" class="main">
        <div class="container-fluid">
            <h1 class="mb-4 text-center">Báo cáo bán hàng nhân viên</h1>
            
            <!-- Filter Form -->
            <form action="EmployeeControllerURL" method="get" class="row g-3 mb-4 bg-light p-3 rounded shadow-sm filter-form">
                <input type="hidden" name="service" value="salesReport">
                <div class="col-md-5">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" class="form-control form-control-sm" name="fromDate" value="${fromDate}">
                </div>
                <div class="col-md-5">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" class="form-control form-control-sm" name="toDate" value="${toDate}">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-sm w-100">Xem báo cáo</button>
                </div>
            </form>

            <!-- Chart Container -->
            <div class="chart-container">
                <canvas id="salesChart"></canvas>
            </div>

            <!-- Data Table -->
            <div class="table-responsive compact-table">
                <table class="table table-striped table-bordered table-sm">
                    <thead class="table-dark">
                        <tr>
                            <th width="50">STT</th>
                            <th>Nhân viên</th>
                            <th width="120">Ngày</th>
                            <th width="100">Số đơn</th>
                            <th width="150">Doanh thu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Phần hiển thị dữ liệu giữ nguyên như trước --%>
                        <%
                            Vector<EmployeeSalesReport> report = (Vector<EmployeeSalesReport>) request.getAttribute("report");
                            if (report != null && !report.isEmpty()) {
                                int stt = 1;
                                String currentEmployee = "";
                                int empOrderCount = 0;
                                int empTotalSales = 0;

                                for (EmployeeSalesReport item : report) {
                                    if (!item.getEmployeeName().equals(currentEmployee)) {
                                        if (!currentEmployee.isEmpty()) {
                        %>
                                            <tr class="total-row">
                                                <td colspan="2">Tổng <%= currentEmployee %></td>
                                                <td></td>
                                                <td><%= empOrderCount %></td>
                                                <td><%= String.format("%,d", empTotalSales) %>₫</td>
                                            </tr>
                        <%
                                        }
                                        currentEmployee = item.getEmployeeName();
                                        empOrderCount = 0;
                                        empTotalSales = 0;
                                    }
                                    
                                    empOrderCount += item.getOrderCount();
                                    empTotalSales += item.getTotalSales();
                        %>
                                    <tr>
                                        <td><%= stt++ %></td>
                                        <td><%= item.getEmployeeName() %></td>
                                        <td><%= item.getReportDate() %></td>
                                        <td><%= item.getOrderCount() %></td>
                                        <td><%= String.format("%,d", item.getTotalSales()) %>₫</td>
                                    </tr>
                        <%
                                }
                                if (!currentEmployee.isEmpty()) {
                        %>
                                    <tr class="total-row">
                                        <td colspan="2">Tổng <%= currentEmployee %></td>
                                        <td></td>
                                        <td><%= empOrderCount %></td>
                                        <td><%= String.format("%,d", empTotalSales) %>₫</td>
                                    </tr>
                        <%
                                }
                            } else {
                        %>
                                <tr>
                                    <td colspan="5" class="text-center">Không có dữ liệu</td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        // Phần script giữ nguyên như trước
        document.addEventListener('DOMContentLoaded', function() {
            const totalRows = document.querySelectorAll('tr.total-row');
            const chartData = {
                labels: [],
                datasets: [{
                    label: 'Tổng doanh thu',
                    data: [],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            };

            totalRows.forEach(row => {
                const cells = row.getElementsByTagName('td');
                const employeeName = cells[0].textContent.replace('Tổng ', '');
                const totalSales = parseInt(cells[3].textContent.replace(/[^0-9]/g, ''));
                
                chartData.labels.push(employeeName);
                chartData.datasets[0].data.push(totalSales);
            });

            if (chartData.labels.length > 0) {
                const ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: chartData,
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return value.toLocaleString('vi-VN') + '₫';
                                    }
                                }
                            }
                        },
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        let label = context.dataset.label || '';
                                        if (label) label += ': ';
                                        if (context.parsed.y !== null) {
                                            label += context.parsed.y.toLocaleString('vi-VN') + '₫';
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>
</body>
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
</html>