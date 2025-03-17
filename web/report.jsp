<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo - Hệ thống quản lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .search-options {
            padding: 15px;
        }
        .table th, .table td {
            padding: 0.5rem;
        }
        .pagination-btn {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <!-- Header/Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Hệ thống quản lý</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="dashboard">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="products">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="orders">Đơn hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="order-return">Trả hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="customers">Khách hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="reports">Báo cáo</a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="profile">
                            <i class="bi bi-person-circle"></i> Tài khoản
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout">
                            <i class="bi bi-box-arrow-right"></i> Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col">
                <h2 class="mb-0">Báo cáo doanh thu</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="dashboard">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Báo cáo doanh thu</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <!-- Left sidebar with search options -->
            <div class="col-md-3 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title mb-3">Tìm kiếm</h5>
                        
                        <form action="<c:url value='/report'/>" method="get" id="searchForm">
                            <div class="mb-3">
                                <label class="form-label small">Theo mã hóa đơn</label>
                                <input type="text" class="form-control form-control-sm" name="orderId" placeholder="Nhập mã hóa đơn" value="${param.orderId}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small">Theo nhân viên</label>
                                <input type="text" class="form-control form-control-sm" name="employee" placeholder="Nhập tên nhân viên" value="${param.employee}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small">Theo khách hàng hoặc ĐT</label>
                                <input type="text" class="form-control form-control-sm" name="customer" placeholder="Nhập tên hoặc SĐT" value="${param.customer}">
                            </div>

                            <div class="mb-3">
                                <label class="form-label small">Loại đơn hàng</label>
                                <select class="form-select form-select-sm" name="orderType">
                                    <option value="" ${empty param.orderType ? 'selected' : ''}>Tất cả</option>
                                    <option value="SALE" ${param.orderType == 'SALE' ? 'selected' : ''}>Bán hàng</option>
                                    <option value="RETURN" ${param.orderType == 'RETURN' ? 'selected' : ''}>Trả hàng</option>
                                </select>
                            </div>

                            <h6 class="mb-3 mt-4">Thời gian</h6>
                            
                            <div class="mb-3">
                                <label class="form-label small">Từ ngày</label>
                                <div class="input-group">
                                    <input type="date" class="form-control form-control-sm" name="fromDate" value="${param.fromDate}">
                                    <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Đến ngày</label>
                                <div class="input-group">
                                    <input type="date" class="form-control form-control-sm" name="toDate" value="${param.toDate}">
                                    <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-sm w-100">Tìm kiếm</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Right side with report content -->
            <div class="col-md-9">
                <div class="card mb-4">
                    <div class="card-body p-3">
                        <!-- Filter buttons -->
                        <div class="btn-group mb-3">
                            <a href="?period=day" class="btn btn-outline-primary btn-sm ${param.period == 'day' ? 'active' : ''}">Hôm nay</a>
                            <a href="?period=week" class="btn btn-outline-primary btn-sm ${param.period == 'week' ? 'active' : ''}">Tuần này</a>
                            <a href="?period=month" class="btn btn-outline-primary btn-sm ${param.period == 'month' ? 'active' : ''}">Tháng này</a>
                            <a href="?period=year" class="btn btn-outline-primary btn-sm ${param.period == 'year' ? 'active' : ''}">Năm nay</a>
                            <a href="?period=all" class="btn btn-outline-primary btn-sm ${param.period == 'all' || empty param.period ? 'active' : ''}">Tất cả</a>
                        </div>

                        <!-- Summary cards -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <div class="card bg-primary text-white">
                                    <div class="card-body p-3">
                                        <div>Tổng doanh thu</div>
                                        <h4 class="mb-0"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> đ</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-success text-white">
                                    <div class="card-body p-3">
                                        <div>Đơn bán hàng</div>
                                        <h4 class="mb-0">${totalSales} đơn</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-danger text-white">
                                    <div class="card-body p-3">
                                        <div>Đơn trả hàng</div>
                                        <h4 class="mb-0">${totalReturns} đơn</h4>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Orders table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã hóa đơn <i class="bi bi-arrow-down-up text-primary"></i></th>
                                        <th>Loại</th>
                                        <th>Thời gian <i class="bi bi-arrow-down text-primary"></i></th>
                                        <th>Nhân viên</th>
                                        <th>Khách hàng</th>
                                        <th>Voucher</th>
                                        <th>Trạng thái</th>
                                        <th class="text-end">Tổng tiền</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <!-- Mã hóa đơn -->
                                            <td><a href="#" class="text-primary">${order.id}</a></td>
                                            <!-- Loại đơn hàng -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.orderType eq 'SALE'}">
                                                        <span class="badge bg-success">Bán hàng</span>
                                                    </c:when>
                                                    <c:when test="${order.orderType eq 'RETURN'}">
                                                        <span class="badge bg-warning">Trả hàng</span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <!-- Thời gian -->
                                            <td><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <!-- Nhân viên -->
                                            <td>
                                                <c:set var="employee" value="${accountDAO.getEmployeeByID(order.employeeID)}" />
                                                <c:choose>
                                                    <c:when test="${not empty employee and not empty employee.account}">
                                                        ${employee.employeeName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Nhân viên #${order.employeeID}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <!-- Khách hàng -->
                                            <td>${order.customerName}</td>
                                            <!-- Voucher -->
                                            <td>
                                                <c:if test="${order.orderType == 'SALE' && not empty order.voucherId}">
                                                    <c:set var="voucher" value="${voucherDAO.getVoucherById(order.voucherId)}" />
                                                    <c:choose>
                                                        <c:when test="${not empty voucher}">
                                                            <span class="badge bg-info" title="Giảm ${voucher.discountRate}%, tối đa ${voucher.maxValue}đ">
                                                                ${voucher.code}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">-</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${order.orderType == 'RETURN' || empty order.voucherId}">
                                                    <span class="text-muted">-</span>
                                                </c:if>
                                            </td>
                                            <!-- Trạng thái -->
                                            <td>
                                                <span class="badge bg-success">Thành công</span>
                                            </td>
                                            <!-- Tổng tiền -->
                                            <td class="text-end"><fmt:formatNumber value="${order.totalAmount}" pattern="#,##0"/> đ</td>
                                            <!-- Nút xem chi tiết -->
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.orderType eq 'SALE'}">
                                                        <a href="report?action=viewDetails&type=SALE&id=${order.id}" class="btn btn-sm btn-primary">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:when test="${order.orderType eq 'RETURN'}">
                                                        <a href="report?action=viewDetails&type=RETURN&id=${order.id}" class="btn btn-sm btn-primary">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="9" class="text-center">Không có dữ liệu</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="pagination-controls">
                                <!-- First page button -->
                                <a href="<c:url value='/report?page=1${searchParams}'/>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                                
                                <!-- Previous page button -->
                                <c:set var="prevPage" value="1" />
                                <c:if test="${currentPage > 1}">
                                    <c:set var="prevPage" value="${currentPage - 1}" />
                                </c:if>
                                <a href="<c:url value='/report?page=${prevPage}${searchParams}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                                
                                <!-- Page numbers -->
                                <c:choose>
                                    <c:when test="${totalPages <= 5}">
                                        <!-- If total pages <= 5, show all pages -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="<c:url value='/report?page=${i}${searchParams}'/>" 
                                               class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                ${i}
                                            </a>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- If total pages > 5, show current page and surrounding pages -->
                                        <c:choose>
                                            <c:when test="${currentPage <= 3}">
                                                <!-- If near the beginning, show first 5 pages -->
                                                <c:forEach begin="1" end="5" var="i">
                                                    <a href="<c:url value='/report?page=${i}${searchParams}'/>" 
                                                       class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </c:when>
                                            <c:when test="${currentPage + 2 >= totalPages}">
                                                <!-- If near the end, show last 5 pages -->
                                                <c:set var="startPage" value="${totalPages - 4}" />
                                                <c:forEach begin="${startPage}" end="${totalPages}" var="i">
                                                    <a href="<c:url value='/report?page=${i}${searchParams}'/>" 
                                                       class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- If in the middle, show current page and 2 pages before/after -->
                                                <c:set var="startPage" value="${currentPage - 2}" />
                                                <c:set var="endPage" value="${currentPage + 2}" />
                                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                    <a href="<c:url value='/report?page=${i}${searchParams}'/>" 
                                                       class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                                
                                <!-- Next page button -->
                                <c:set var="nextPage" value="${totalPages}" />
                                <c:if test="${currentPage < totalPages}">
                                    <c:set var="nextPage" value="${currentPage + 1}" />
                                </c:if>
                                <a href="<c:url value='/report?page=${nextPage}${searchParams}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                                
                                <!-- Last page button -->
                                <a href="<c:url value='/report?page=${totalPages}${searchParams}'/>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </div>
                            
                            <!-- Pagination info -->
                            <div class="pagination-info">
                                <c:set var="startItem" value="${(currentPage-1) * pageSize + 1}" />
                                <c:set var="endItem" value="${currentPage * pageSize}" />
                                <c:if test="${endItem > totalItems}">
                                    <c:set var="endItem" value="${totalItems}" />
                                </c:if>
                                
                                Hiển thị ${startItem} - ${endItem} trên tổng số ${totalItems} hóa đơn
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-light py-3 mt-5">
        <div class="container text-center">
            <p class="mb-0">© 2023 Hệ thống quản lý. All rights reserved.</p>
        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>