<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhà cung cấp</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            background-color: #f0f0f0;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .sidebar {
            width: 250px;
            float: left;
            margin-right: 20px;
        }
        
        .main-content {
            margin-left: 270px;
        }
        
        .panel {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 15px;
        }
        
        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            margin-bottom: 10px;
        }
        
        .panel-title {
            font-weight: bold;
            font-size: 16px;
            display: flex;
            align-items: center;
        }
        
        .panel-title i {
            margin-right: 5px;
            color: #555;
        }
        
        .dropdown {
            position: relative;
            cursor: pointer;
        }
        
        .dropdown i {
            margin-left: 5px;
        }
        
        .filter-row {
            display: flex;
            margin-bottom: 10px;
            align-items: center;
        }
        
        .filter-label {
            width: 40px;
            font-size: 14px;
        }
        
        .filter-input {
            flex: 1;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        
        .radio-group {
            margin: 10px 0;
        }
        
        .radio-option {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .radio-option input {
            margin-right: 10px;
        }
        
        .supplier-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .supplier-table th, .supplier-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .supplier-table th {
            background-color: #f9f9f9;
            font-weight: normal;
        }
        
        .supplier-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .supplier-item {
            background-color: #e8f5e9;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        
        .supplier-header {
            display: flex;
            align-items: center;
            padding: 10px 15px;
            border-bottom: 1px solid #d0e9d4;
        }
        
        .supplier-checkbox {
            margin-right: 15px;
        }
        
        .supplier-code {
            width: 120px;
        }
        
        .supplier-name {
            flex: 1;
        }
        
        .supplier-debt, .supplier-total {
            width: 150px;
            text-align: right;
        }
        
        .tab-nav {
            display: flex;
            border-bottom: 1px solid #d0e9d4;
            background-color: #f5fbf6;
        }
        
        .tab-item {
            padding: 10px 15px;
            cursor: pointer;
        }
        
        .tab-item.active {
            border-bottom: 2px solid #4caf50;
            color: #4caf50;
        }
        
        .transaction-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .transaction-table th, .transaction-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .transaction-table th {
            background-color: #f0f8ff;
            font-weight: normal;
        }
        
        .transaction-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        .dropdown-filter {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 3px;
            background-color: white;
            cursor: pointer;
            width: 150px;
            display: inline-block;
            position: relative;
        }
        
        .dropdown-filter i {
            float: right;
            margin-top: 3px;
        }
        
        .action-buttons {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            color: white;
            cursor: pointer;
            display: flex;
            align-items: center;
        }
        
        .btn i {
            margin-right: 5px;
        }
        
        .btn-primary {
            background-color: #4caf50;
        }
        
        .btn-secondary {
            background-color: #2196f3;
        }
        
        .btn-info {
            background-color: #ff9800;
        }
        
        .btn-export {
            background-color: #607d8b;
        }
        
        .help-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #2196f3;
            color: white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            cursor: pointer;
        }
        
        .scroll-top {
            position: fixed;
            bottom: 80px;
            right: 20px;
            background-color: #f44336;
            color: white;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <i>⚙️</i> Nhóm NCC
                    </div>
                    <div class="dropdown">
                        <i>▼</i>
                    </div>
                </div>
                <div class="panel-content">
                    <div class="dropdown-filter">
                        Tất cả các nhóm <i>▼</i>
                    </div>
                </div>
            </div>
            
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <i>💰</i> Tổng mua
                    </div>
                    <div class="dropdown">
                        <i>▼</i>
                    </div>
                </div>
                <div class="panel-content">
                    <div class="filter-row">
                        <div class="filter-label">Từ</div>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    <div class="filter-row">
                        <div class="filter-label">Tới</div>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    
                    <div class="radio-group">
                        <div class="radio-option">
                            <input type="radio" id="all-time" name="time-filter" checked>
                            <label for="all-time">Toàn thời gian</label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="custom-time" name="time-filter">
                            <label for="custom-time">Lựa chọn khác</label>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <i>📋</i> Nợ hiện tại
                    </div>
                    <div class="dropdown">
                        <i>▼</i>
                    </div>
                </div>
                <div class="panel-content">
                    <div class="filter-row">
                        <div class="filter-label">Từ</div>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    <div class="filter-row">
                        <div class="filter-label">Tới</div>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                </div>
            </div>
            
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <i>🔄</i> Trạng thái
                    </div>
                    <div class="dropdown">
                        <i>▼</i>
                    </div>
                </div>
                <div class="panel-content">
                    <div class="radio-group">
                        <div class="radio-option">
                            <input type="radio" id="all-status" name="status-filter" checked>
                            <label for="all-status">Tất cả</label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="active-status" name="status-filter">
                            <label for="active-status">Đang hoạt động</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <!-- Add Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Add custom JS -->
        <script src="assets/js/supplier-payment.js" defer></script>
    </head>
<body>
    <%@include file="HeaderAdmin.jsp"%>
    
    <div class="main-content">
        <div class="pagetitle">
            <h1>Công nợ nhà cung cấp</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="index.html">Home</a></li>
                    <li class="breadcrumb-item"><a href="supplier?action=list">Nhà cung cấp</a></li>
                    <li class="breadcrumb-item active">Công nợ</li>
                </ol>
            </nav>
        </div>

        <div class="row">
            <div class="col-12">
                <table class="supplier-table">
                <thead>
                    <tr>
                        <th width="40px"><input type="checkbox"></th>
                        <th>Mã nhà cung cấp</th>
                        <th>Tên nhà cung cấp</th>
                        <th>Điện thoại</th>
                        <th>Email</th>
                        <th>Nợ cần trả hiện tại</th>
                        <th>Tổng mua</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="7" style="padding: 0;">
                            <div class="supplier-item">
                                <div class="supplier-header">
                                    <div class="supplier-checkbox">
                                        <input type="checkbox">
                                    </div>
                                    <div class="supplier-code">${supplier.supplierCode}</div>
                                    <div class="supplier-name">${supplier.supplierName}</div>
                                    <div class="supplier-debt">
                                        <fmt:formatNumber value="${supplier.currentDebt}" type="currency" currencySymbol="₫"/>
                                    </div>
                                    <div class="supplier-total">
                                        <fmt:formatNumber value="${supplier.totalPurchase}" type="currency" currencySymbol="₫"/>
                                    </div>
                                </div>
                                
                                <div class="tab-nav">
                                    <div class="tab-item active">Thông tin</div>
                                    <div class="tab-item">Lịch sử nhập/trả hàng</div>
                                    <div class="tab-item">Nợ cần trả NCC</div>
                                </div>
                                
                                <div class="tab-content">
                                    <div class="filter-container" style="padding: 10px 15px; text-align: right;">
                                        <div class="dropdown-filter">
                                            Nhập hàng <i>▼</i>
                                        </div>
                                    </div>
                                    
                                    <table class="transaction-table">
                                        <thead>
                                            <tr>
                                                <th>Mã phiếu</th>
                                                <th>Thời gian</th>
                                                <th>Loại</th>
                                                <th>Giá trị</th>
                                                <th>Nợ cần trả NCC</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${transactions}" var="trans">
                                                <tr>
                                                    <td>${trans.id}</td>
                                                    <td><fmt:formatDate value="${trans.date}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    <td>${trans.type}</td>
                                                    <td><fmt:formatNumber value="${trans.amount}" type="currency" currencySymbol="₫"/></td>
                                                    <td><fmt:formatNumber value="${trans.remainingDebt}" type="currency" currencySymbol="₫"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    
                                    <div class="action-buttons">
                                        <button class="btn btn-primary" onclick="showAdjustmentModal()">
                                            <i class="bi bi-arrow-repeat"></i> Điều chỉnh
                                        </button>
                                        <button class="btn btn-secondary" onclick="showPaymentModal()">
                                            <i class="bi bi-cash-coin"></i> Thanh toán
                                        </button>
                                        <button class="btn btn-info" onclick="showDiscountModal()">
                                            <i class="bi bi-receipt"></i> Chiết khấu thanh toán
                                        </button>
                                        <button class="btn btn-export" onclick="exportDebtReport()">
                                            <i class="bi bi-file-earmark-arrow-down"></i> Xuất file công nợ
                                        </button>
                                        <button class="btn btn-export" onclick="exportTransactions()">
                                            <i class="bi bi-file-earmark-arrow-down"></i> Xuất file
                                        </button>
                                    </div>

                                    <!-- Filter Form -->
                                    <form id="filterForm" class="mt-3">
                                        <input type="hidden" name="action" value="filter">
                                        <input type="hidden" name="supplierId" value="${supplier.id}">
                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <input type="date" class="form-control" name="fromDate" 
                                                       value="${param.fromDate}" placeholder="Từ ngày">
                                            </div>
                                            <div class="col-md-4">
                                                <input type="date" class="form-control" name="toDate" 
                                                       value="${param.toDate}" placeholder="Đến ngày">
                                            </div>
                                            <div class="col-md-4">
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-search"></i> Lọc
                                                </button>
                                            </div>
                                        </div>
                                    </form>

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
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"></td>
                        <td>NCC0003</td>
                        <td>Công ty Pharmedia</td>
                        <td></td>
                        <td></td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="help-button">💬</div>
    <div class="scroll-top">↑</div>
    
    <div class="help-text" style="position: fixed; bottom: 20px; right: 80px; background-color: white; padding: 8px 15px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">
        Hỗ trợ: 1900 6622
    </div>
</body>
</html>
