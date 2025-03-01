<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - SLIM</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
    <!-- Include Header -->
    <%@include file="HeaderAdmin.jsp"%>
    
    <main id="main" class="main">
        <div class="pagetitle">
            <h1>${pageTitle}</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                    <li class="breadcrumb-item"><a href="supplier?action=list">Nhà cung cấp</a></li>
                    <li class="breadcrumb-item active">${pageTitle}</li>
                </ol>
            </nav>
        </div>

        <section class="section">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="card-title mb-0">${supplier.supplierName}</h5>
                        <small class="text-muted">Mã NCC: ${supplier.supplierCode}</small>
                    </div>
                    <div class="text-end">
                        <div class="fs-5">Nợ hiện tại: <fmt:formatNumber value="${supplier.currentDebt}" type="currency" currencySymbol="₫"/></div>
                        <small class="text-muted">Tổng mua: <fmt:formatNumber value="${supplier.totalPurchase}" type="currency" currencySymbol="₫"/></small>
                    </div>
                </div>
                
                <div class="card-body">
                    <!-- Tab Navigation -->
                    <ul class="nav nav-tabs">
                        <li class="nav-item">
                            <a class="nav-link" href="supplier-infor.jsp?id=${param.id}">
                                Thông tin
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="supplier-purchase-history.jsp?id=${param.id}">
                                Lịch sử nhập/trả hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="#">
                                Nợ cần trả NCC
                            </a>
                        </li>
                    </ul>

                    <!-- Filter Form -->
                    <form id="filterForm" class="row g-3 mt-3">
                        <input type="hidden" name="action" value="${tab}">
                        <input type="hidden" name="id" value="${supplier.id}">
                        <div class="col-md-4">
                            <input type="date" class="form-control" name="fromDate" 
                                   value="${fromDate}" placeholder="Từ ngày">
                        </div>
                        <div class="col-md-4">
                            <input type="date" class="form-control" name="toDate" 
                                   value="${toDate}" placeholder="Đến ngày">
                        </div>
                        <div class="col-md-4">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Lọc
                            </button>
                        </div>
                    </form>

                    <!-- Transactions Table -->
                    <div class="table-responsive mt-3">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Mã phiếu</th>
                                    <th>Thời gian</th>
                                    <th>Loại</th>
                                    <th class="text-end">Giá trị</th>
                                    <th class="text-end">Nợ cần trả</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${transactions}" var="trans">
                                    <tr>
                                        <td>${trans.id}</td>
                                        <td><fmt:formatDate value="${trans.date}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>${trans.type}</td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${trans.amount}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="text-end">
                                            <fmt:formatNumber value="${trans.remainingDebt}" type="currency" currencySymbol="₫"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex gap-2 mt-3">
                        <button class="btn btn-primary" onclick="showAdjustmentModal()">
                            <i class="bi bi-arrow-repeat"></i> Điều chỉnh
                        </button>
                        <button class="btn btn-success" onclick="showPaymentModal()">
                            <i class="bi bi-cash-coin"></i> Thanh toán
                        </button>
                        <button class="btn btn-info text-white" onclick="showDiscountModal()">
                            <i class="bi bi-receipt"></i> Chiết khấu thanh toán
                        </button>
                        <button class="btn btn-secondary" onclick="exportDebtReport()">
                            <i class="bi bi-file-earmark-arrow-down"></i> Xuất file công nợ
                        </button>
                        <button class="btn btn-secondary" onclick="exportTransactions()">
                            <i class="bi bi-file-earmark-arrow-down"></i> Xuất file
                        </button>
                    </div>
                </div>
            </div>

            <!-- Payment Modal -->
            <div class="modal fade" id="paymentModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Thanh toán công nợ</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form id="paymentForm" action="supplier" method="POST">
                                <input type="hidden" name="action" value="makePayment">
                                <input type="hidden" name="supplierId" value="${supplier.id}">
                                
                                <div class="mb-3">
                                    <label class="form-label">Số tiền thanh toán</label>
                                    <input type="number" class="form-control" name="amount" required 
                                           max="${supplier.currentDebt}">
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Phương thức thanh toán</label>
                                    <select class="form-select" name="paymentMethod" required>
                                        <option value="CASH">Tiền mặt</option>
                                        <option value="BANK">Chuyển khoản</option>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ghi chú</label>
                                    <textarea class="form-control" name="notes" rows="3"></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" form="paymentForm" class="btn btn-primary">Xác nhận</button>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Utility Functions -->
    <script src="assets/js/util.js"></script>
    <!-- Custom JS -->
    <script src="assets/js/supplier-payment.js"></script>
    
    <script>
        // Apply currency formatting on load
        document.addEventListener('DOMContentLoaded', function() {
            // Format debt and total amount in header
            const debtElement = document.querySelector('.fs-5');
            const totalElement = debtElement.nextElementSibling;
            
            if (debtElement) {
                const debtValue = parseCurrency(debtElement.textContent.split(':')[1]);
                debtElement.innerHTML = 'Nợ hiện tại: ' + formatCurrency(debtValue);
            }
            
            if (totalElement) {
                const totalValue = parseCurrency(totalElement.textContent.split(':')[1]);
                totalElement.innerHTML = 'Tổng mua: ' + formatCurrency(totalValue);
            }
            
            // Format amounts in transaction table
            document.querySelectorAll('.text-end').forEach(cell => {
                if (cell.textContent.trim() && !isNaN(parseCurrency(cell.textContent))) {
                    const value = parseCurrency(cell.textContent);
                    cell.textContent = formatCurrency(value);
                }
            });
        });
    </script>
</body>
</html>
