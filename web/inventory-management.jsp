<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phiếu nhập hàng - SLIM</title>

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon" />
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon" />

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet" />
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.bootstrap5.min.css">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet" />

    <style>
        /* Giữ nguyên các style cũ */
        .table-hover tbody tr:hover { cursor: pointer; }
        .action-buttons .btn { margin-left: 5px; }
        .alert-success { margin: 15px 0; }
    </style>
</head>
<body>
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
        <div class="pagetitle">
            <h1>Phiếu nhập hàng</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                    <li class="breadcrumb-item">Quản lý</li>
                    <li class="breadcrumb-item active">Phiếu nhập hàng</li>
                </ol>
            </nav>
        </div>

        <section class="section">
            <div class="container">
<c:if test="${not empty sessionScope.errorMessages}">
            <div class="alert alert-danger">
              <strong>Lỗi!</strong>
              <ul>
                <c:forEach var="error" items="${sessionScope.errorMessages}">
                  <li>${error}</li>
                </c:forEach>
              </ul>
            </div>
            <!-- Xóa thông báo lỗi sau khi hiển thị -->
            <c:remove var="errorMessages"/>
          </c:if>

          <!-- Hiển thị thông báo thành công nếu có -->
          <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
              <strong>Thành công!</strong> ${sessionScope.successMessage}
            </div>
            <!-- Xóa thông báo thành công sau khi hiển thị -->
            <c:remove var="successMessage"/>
          </c:if>

                <div class="card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="card-title">Danh sách phiếu nhập hàng</h5>
                            <div class="action-buttons">
                                <a href="inventory?action=add" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>Thêm mới
                                </a>
                                
                                <div class="dropdown d-inline-block">
                                    <button class="btn btn-success dropdown-toggle" type="button" 
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-download me-1"></i>Xuất file
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="#" id="exportExcel">Excel</a></li>
                                        <li><a class="dropdown-item" href="DownloadInventoryTemplateServlet">Tải mẫu</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="#" data-bs-toggle="modal" 
                                            data-bs-target="#importExcelModal">Nhập từ Excel</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- DataTable -->
                        <table id="goodsReceiptTable" class="table table-hover" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Thời gian</th>
                                    <th>Nhà cung cấp</th>
                                    <th>Tổng tiền</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="receipt" items="${goodsReceipts}">
                                    <tr data-id="${receipt.goodReceiptID}">
                                        <td>PN${String.format("%06d", receipt.goodReceiptID)}</td>
                                        <td><fmt:formatDate value="${receipt.receivedDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                        <td>${receipt.supplier.supplierName}</td>
                                        <td><fmt:formatNumber value="${receipt.totalCost}" /></td>
                                        <td>
                                            <a href="inventory?action=view&id=${receipt.goodReceiptID}" 
                                                class="btn btn-sm btn-info">
                                                <i class="bi bi-eye"></i>
                                            </a>
<!--                                            <a href="inventory?action=edit&id=${receipt.goodReceiptID}" 
                                                class="btn btn-sm btn-warning">
                                                <i class="bi bi-pencil"></i>
                                            </a>-->
<!--                                            <button onclick="confirmDelete(${receipt.goodReceiptID}, event)" 
                                                class="btn btn-sm btn-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>-->
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Import Excel Modal -->
    <div class="modal fade" id="importExcelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nhập hàng từ Excel</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ImportInventoryExcelServlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Nhà cung cấp</label>
                            <select class="form-select" name="supplierID" required>
                                <option value="">-- Chọn nhà cung cấp --</option>
                                <c:forEach var="supplier" items="${suppliers}">
                                    <option value="${supplier.id}">${supplier.supplierName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Chọn file Excel</label>
                            <input type="file" class="form-control" name="excelFile" 
                                accept=".xls,.xlsx" required>
                        </div>
                        <a href="DownloadInventoryTemplateServlet" class="text-decoration-none">
                            <i class="bi bi-download me-1"></i>Tải file mẫu
                        </a>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Nhập hàng</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

    <script>
        // Khởi tạo DataTable
        $(document).ready(function() {
            var table = $('#goodsReceiptTable').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.6/i18n/vi.json'
                },
                dom: '<"row"<"col-sm-12 col-md-6"Bl><"col-sm-12 col-md-6"f>>rtip',
                buttons: [{
                    extend: 'excel',
                    text: 'Xuất Excel',
                    className: 'btn btn-success',
                    title: 'Danh_sach_phieu_nhap_hang',
                    exportOptions: {
                        columns: [0, 1, 2, 3]
                    }
                }],
                columnDefs: [
                    { orderable: false, targets: 4 },
                    { className: "text-center", targets: [4] }
                ]
            });

            // Xử lý xuất Excel
            document.getElementById('exportExcel').addEventListener('click', function(e) {
                e.preventDefault();
                $('.buttons-excel').click();
            });

            // Xử lý click row
            $('#goodsReceiptTable tbody').on('click', 'tr', function(e) {
                if ($(e.target).closest('button, a').length === 0) {
                    window.location = 'inventory?action=view&id=' + $(this).data('id');
                }
            });
        });

        function confirmDelete(id, e) {
            e.stopPropagation();
            if (confirm('Bạn có chắc chắn muốn xóa phiếu nhập này?')) {
                window.location = 'inventory?action=delete&id=' + id;
            }
        }
    </script>
</body>
</html>