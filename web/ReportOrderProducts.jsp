<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, entity.ReportOrderProduct, entity.Product, entity.Order1 "%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Báo cáo bán hàng sản phẩm</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            .chart-container {
                height: 400px;
                margin: 20px 0;
            }
            .table-responsive {
                margin: 20px 0;
            }
            h1 {
                color: #2c3e50;
                margin: 20px 0;
            }
        </style>
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="container-fluid">
                <h1 class="mb-4">Báo cáo bán hàng sản phẩm</h1>

                <!-- Filter Form -->
                <form action="OrderDetailControllerURL" method="get" class="row g-3 mb-4 bg-light p-4 rounded shadow-sm">
                    <input type="hidden" name="service" value="reportProduct">
                    <div class="col-md-3">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" class="form-control" name="toDate" value="${toDate}">
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">Xem báo cáo</button>
                    </div>
                </form>

                <!-- Chart Container -->
                <h5>Biểu đồ Top 5 Sản phẩm bán chạy theo Doanh thu</h5>
                <div class="chart-container">
                    <canvas id="salesChart"></canvas>
                </div>

                <h5>Biểu đồ Top 5 Sản phẩm bán chạy theo Số lượng</h5>
                <div class="chart-container">
                    <canvas id="sales2Chart"></canvas>
                </div>

                <!-- Data Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>STT</th>
                                <th>Tên Sản phẩm</th>
                                <th>${groupBy == 'day' ? 'Ngày' : 'Tháng'}</th>
                                <th>Số lượng sản phẩm</th>
                                <th>Tổng doanh thu từ sản phẩm</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Vector<ReportOrderProduct> report = (Vector<ReportOrderProduct>) request.getAttribute("report");
                                if (report != null && !report.isEmpty()) {
                                    int stt = 1;
                                    String currentProduct = "";
                                    int productSoldQuantity = 0;
                                    int productTotalRevenue = 0;
                                
                                    for (ReportOrderProduct item : report) {
                                    if(!item.getProductName().equals(currentProduct)) {
                                        if (!currentProduct.isEmpty()) {
                            %>

                            <%
                                    }
                                    currentProduct = item.getProductName();
                                    productSoldQuantity = 0;
                                    productTotalRevenue = 0;
                                }

                                productSoldQuantity += item.getSoldQuantity();
                                productTotalRevenue += item.getTotalRevenue();
                            %>
                            <tr>
                                <td><%= stt++ %></td>
                                <td><%= item.getProductName() %></td>
                                <td><%= item.getReportDate() %></td>
                                <td><%= item.getSoldQuantity() %></td>
                                <td><%= String.format("%,d", item.getTotalRevenue()) %> VNĐ</td>
                            </tr>
                            <%
                                }
                                if (!currentProduct.isEmpty()) {
                            %>

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
            document.addEventListener('DOMContentLoaded', function () {
                const tableRows = document.querySelectorAll('tbody tr:not(.total-row)');
                const chartData = {
                    labels: [],
                    datasets: [{
                            label: 'Tổng doanh thu (VNĐ)',
                            data: [],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                };

                tableRows.forEach(row => {
                    const cells = row.getElementsByTagName('td');
                    if (cells.length > 4) {
                        const productName = cells[1].textContent;
                        const totalRevenue = parseInt(cells[4].textContent.replace(/[^0-9]/g, ''));

                        chartData.labels.push(productName);
                        chartData.datasets[0].data.push(totalRevenue);
                    }
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
                                        callback: function (value) {
                                            return value.toLocaleString('vi-VN');
                                        }
                                    }
                                }
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN');
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            });

        </script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const tableRows = document.querySelectorAll('tbody tr:not(.total-row)');
                const chartData = {
                    labels: [],
                    datasets: [{
                            label: 'Tổng doanh thu (VNĐ)',
                            data: [],
                            backgroundColor: 'rgba(54, 162, 235, 0.5)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                };

                tableRows.forEach(row => {
                    const cells = row.getElementsByTagName('td');
                    if (cells.length > 4) {
                        const productName = cells[1].textContent.trim(); 
                        const totalRevenue = parseInt(cells[3].textContent.replace(/[^0-9]/g, ''), '');

                        chartData.labels.push(productName);
                        chartData.datasets[0].data.push(totalRevenue);
                    }
                });

                if (chartData.labels.length > 0) {
                    const ctx = document.getElementById('sales2Chart').getContext('2d');
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
                                        callback: function (value) {
                                            return value.toLocaleString('vi-VN');
                                        }
                                    }
                                }
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            return context.dataset.label + ': ' + context.parsed.y.toLocaleString('vi-VN') + ' VNĐ';
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
</html>
