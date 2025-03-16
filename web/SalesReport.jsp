<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Báo Cáo Doanh Số</title>

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
            body {
                font-family: Arial, sans-serif;
            }

            .main-content {
                margin-left: 300px; /* Đẩy nội dung ra khỏi sidebar */
                padding: 20px;
                transition: margin-left 0.3s;
            }

            #salesChart {
                max-height: 400px;
            }

            @media (max-width: 992px) {
                .main-content {
                    margin-left: 0; /* Nếu màn hình nhỏ, không đẩy lề */
                }
            }
        </style>
    </head>

    <body>
        <%@include file="HeaderAdmin.jsp"%>
        <div class="main-content">
    <div class="container">
        <h2 class="text-primary">Báo Cáo Doanh Số</h2>
        <h4>Tổng Doanh Thu: <span id="totalRevenue" class="text-success">0 VND</span></h4>
        <select id="timeFilter" class="form-select w-25" onchange="updateChart()">
            <option value="today">Hôm nay</option>
            <option value="yesterday">Hôm qua</option>
            <option value="last7days">7 ngày qua</option>
            <option value="thismonth">Tháng này</option>
            <option value="lastmonth" selected>Tháng trước</option>
        </select>
    </div>

    <div class="container mt-4">
        <canvas id="salesChart"></canvas>
    </div>
</div>


        <!-- ======= JavaScript ======= -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
                let chartInstance = null;

                function fetchSalesData(filter) {
                    fetch('SalesReportServlet?filter=' + filter)
                            .then(response => response.json())
                            .then(data => {
                                console.log("Dữ liệu nhận được:", data);

                                if (data.totalRevenue) {
                                    document.getElementById("totalRevenue").innerHTML = data.totalRevenue;
                                } else {
                                    document.getElementById("totalRevenue").innerHTML = "0 VND";
                                }

                                const labels = data.salesData.map(item => item.date);
                                const revenues = data.salesData.map(item => item.revenue);

                                if (chartInstance) {
                                    chartInstance.destroy();
                                }

                                const ctx = document.getElementById('salesChart').getContext('2d');
                                chartInstance = new Chart(ctx, {
                                    type: 'bar',
                                    data: {
                                        labels: labels,
                                        datasets: [{
                                                label: 'Doanh thu (VND)',
                                                data: revenues,
                                                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                                                borderColor: 'rgba(54, 162, 235, 1)',
                                                borderWidth: 1
                                            }]
                                    },
                                    options: {
                                        responsive: true,
                                        scales: {
                                            y: {
                                                beginAtZero: true
                                            }
                                        }
                                    }
                                });
                            })
                            .catch(error => console.error('Lỗi:', error));
                }

                function updateChart() {
                    const filter = document.getElementById('timeFilter').value;
                    fetchSalesData(filter);
                }

                document.addEventListener("DOMContentLoaded", function () {
                    fetchSalesData('lastmonth');
                });
        </script>
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>

</html>
