<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chi tiết phiếu nhập hàng - SLIM</title>

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
            .detail-card {
                margin-bottom: 20px;
            }

            .detail-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .detail-title {
                font-size: 1.2rem;
                font-weight: bold;
            }

            .detail-actions {
                display: flex;
                gap: 10px;
            }

            .detail-info {
                display: flex;
                flex-wrap: wrap;
                margin-bottom: 20px;
            }

            .info-group {
                flex: 1;
                min-width: 250px;
                margin-bottom: 15px;
            }

            .info-label {
                font-weight: bold;
                margin-bottom: 5px;
                color: #6c757d;
            }

            .info-value {
                font-size: 1rem;
            }

            .detail-table th {
                background-color: #f8f9fa;
            }

            .summary-section {
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #dee2e6;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .summary-label {
                font-weight: bold;
            }

            .summary-value {
                font-weight: bold;
            }

            .summary-total {
                font-size: 1.2rem;
                color: #198754;
            }

            .nav-tabs .nav-link.active {
                font-weight: bold;
                color: #198754;
                border-bottom: 2px solid #198754;
            }
        </style>
    </head>
    <body>
        <!-- ======= Header ======= -->
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Chi tiết phiếu nhập hàng</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                        <li class="breadcrumb-item"><a href="inventory">Phiếu nhập hàng</a></li>
                        <li class="breadcrumb-item active">Chi tiết phiếu nhập</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-12">
                        <!-- Thông tin phiếu nhập -->
                        <div class="card detail-card">
                            <div class="card-body">
                                <div class="detail-header">
                                    <div class="detail-title">
                                        Phiếu nhập hàng #PN${empty goodReceipt ? 'N/A' : String.format("%06d", goodReceipt.goodReceiptID)}
                                    </div>
                                    <div class="detail-actions">

                                        <button class="btn btn-success" onclick="printReceipt()">
                                            <i class="bi bi-printer"></i> In phiếu
                                        </button>

                                    </div>
                                </div>

                                <div class="detail-info">
                                    <div class="info-group">
                                        <div class="info-label">Mã phiếu nhập</div>
                                        <div class="info-value">PN${String.format("%06d", goodReceipt.goodReceiptID)}</div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Ngày nhập</div>
                                        <div class="info-value"><fmt:formatDate value="${goodReceipt.receivedDate}" pattern="dd/MM/yyyy HH:mm" /></div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Nhà cung cấp</div>
                                        <div class="info-value">${goodReceipt.supplier.supplierName}</div>
                                    </div>
                                    <div class="info-group">
                                        <div class="info-label">Tổng tiền</div>
                                        <div class="info-value"><fmt:formatNumber value="${goodReceipt.totalCost}" type="number" groupingUsed="true" /> VNĐ</div>
                                    </div>
                                </div>

                                <!-- Tabs -->
                                <ul class="nav nav-tabs" id="detailTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="products-tab" data-bs-toggle="tab" data-bs-target="#products" type="button" role="tab" aria-controls="products" aria-selected="true">
                                            Danh sách sản phẩm
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="supplier-tab" data-bs-toggle="tab" data-bs-target="#supplier" type="button" role="tab" aria-controls="supplier" aria-selected="false">
                                            Thông tin nhà cung cấp
                                        </button>
                                    </li>
                                </ul>

                                <!-- Tab Content -->
                                <div class="tab-content" id="detailTabContent">
                                    <!-- Danh sách sản phẩm -->
                                    <div class="tab-pane fade show active" id="products" role="tabpanel" aria-labelledby="products-tab">
                                        <div class="table-responsive mt-3">
                                            <table class="table table-bordered detail-table">
                                                <thead>
                                                    <tr>
                                                        <th width="50">STT</th>
                                                        <th>Mã sản phẩm</th>
                                                        <th>Tên sản phẩm</th>
                                                        <th>Số lô</th>
                                                        <th>Hạn sử dụng</th>
                                                        <th>Số lượng</th>
                                                        <th>Đơn giá</th>
                                                        <th>Thành tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="detail" items="${goodReceiptDetails}" varStatus="status">
                                                        <tr>
                                                            <td>${status.index + 1}</td>
                                                            <td>${detail.product.productCode}</td>
                                                            <td>${detail.product.productName}</td>
                                                            <td>${detail.batchNumber}</td>
                                                            <td><fmt:formatDate value="${detail.expirationDate}" pattern="dd/MM/yyyy" /></td>
                                                            <td>${detail.quantityReceived}</td>
                                                            <td><fmt:formatNumber value="${detail.unitCost}" type="number" groupingUsed="true" /></td>
                                                            <td><fmt:formatNumber value="${detail.quantityReceived * detail.unitCost}" type="number" groupingUsed="true" /></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>

                                        <!-- Tổng kết -->
                                        <div class="summary-section">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="summary-row">
                                                        <div class="summary-label">Tổng số sản phẩm:</div>
                                                        <div class="summary-value">${goodReceiptDetails.size()}</div>
                                                    </div>
                                                    <div class="summary-row">
                                                        <div class="summary-label">Tổng số lượng:</div>
                                                        <div class="summary-value">
                                                            <c:set var="totalQuantity" value="0" />
                                                            <c:forEach var="detail" items="${goodReceiptDetails}">
                                                                <c:set var="totalQuantity" value="${totalQuantity + detail.quantityReceived}" />
                                                            </c:forEach>
                                                            ${totalQuantity}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="summary-row">
                                                        <div class="summary-label">Tổng tiền hàng:</div>
                                                        <div class="summary-value"><fmt:formatNumber value="${goodReceipt.totalCost}" type="number" groupingUsed="true" /> VNĐ</div>
                                                    </div>
                                                    <div class="summary-row">
                                                        <div class="summary-label summary-total">Tổng cộng:</div>
                                                        <div class="summary-value summary-total"><fmt:formatNumber value="${goodReceipt.totalCost}" type="number" groupingUsed="true" /> VNĐ</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thông tin nhà cung cấp -->
                                    <div class="tab-pane fade" id="supplier" role="tabpanel" aria-labelledby="supplier-tab">
                                        <div class="mt-3">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <div class="info-label">Tên nhà cung cấp</div>
                                                        <div class="info-value">${goodReceipt.supplier.supplierName}</div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <div class="info-label">Số điện thoại</div>
                                                        <div class="info-value">${goodReceipt.supplier.phone}</div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <div class="info-label">Email</div>
                                                        <div class="info-value">${goodReceipt.supplier.email}</div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <div class="info-label">Địa chỉ</div>
                                                        <div class="info-value">${goodReceipt.supplier.address}</div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mt-4">
                                                <a href="supplier?action=view&id=${goodsReceipt.supplier.ID}" class="btn btn-primary">
                                                    <i class="bi bi-info-circle"></i> Xem chi tiết nhà cung cấp
                                                </a>
                                            </div>
                                        </div>
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

        <script>
                            // Xác nhận xóa phiếu nhập hàng
                            function confirmDelete(id) {
                                if (confirm("Bạn có chắc chắn muốn xóa phiếu nhập hàng này không?")) {
                                    window.location.href = "inventory?action=delete&id=" + id;
                                }
                            }

                            // In phiếu nhập hàng
                            function printReceipt() {
                                window.print();
                            }
        </script>
    </body>
</html> 