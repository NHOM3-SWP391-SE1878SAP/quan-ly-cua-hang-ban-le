<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trả hàng - Hệ thống quản lý</title>
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
                        <a class="nav-link active" href="order-return">Trả hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="customers">Khách hàng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports">Báo cáo</a>
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
                <h2 class="mb-0">Trả hàng</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="dashboard">Trang chủ</a></li>
                        <li class="breadcrumb-item active">Trả hàng</li>
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
                        
                        <form action="<c:url value='/order-return'/>" method="get" id="searchForm">
                            <div class="mb-3">
                                <label class="form-label small">Theo mã hóa đơn</label>
                                <input type="text" class="form-control form-control-sm" name="orderId" placeholder="Nhập mã hóa đơn" value="${orderIdSearch}">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Theo mã vận đơn bán</label>
                                <input type="text" class="form-control form-control-sm" name="orderCode" placeholder="Nhập mã vận đơn" value="${orderCodeSearch}">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Theo khách hàng hoặc ĐT</label>
                                <input type="text" class="form-control form-control-sm" name="customer" placeholder="Nhập tên hoặc SĐT" value="${customerSearch}">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Theo mã hàng</label>
                                <input type="text" class="form-control form-control-sm" name="productId" placeholder="Nhập mã hàng" value="${productIdSearch}">
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Theo tên hàng</label>
                                <input type="text" class="form-control form-control-sm" name="productName" placeholder="Nhập tên hàng" value="${productNameSearch}">
                            </div>
                            
                            <h6 class="mb-3 mt-4">Thời gian</h6>
                            
                            <div class="mb-3">
                                <label class="form-label small">Từ ngày</label>
                                <div class="input-group">
                                    <input type="date" class="form-control form-control-sm" name="fromDate" value="${fromDate}">
                                    <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small">Đến ngày</label>
                                <div class="input-group">
                                    <input type="date" class="form-control form-control-sm" name="toDate" value="${toDate}">
                                    <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-sm w-100">Tìm kiếm</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Right side with order table -->
            <div class="col-md-9">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Danh sách hóa đơn</h5>
                        <button type="button" class="btn btn-primary btn-sm">
                            <i class="bi bi-arrow-repeat"></i> Trả nhanh
                        </button>
                    </div>
                    <div class="card-body">
                        <div id="orderTableContainer" class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>Mã hóa đơn <i class="bi bi-arrow-down-up text-primary"></i></th>
                                        <th>Thời gian <i class="bi bi-arrow-down text-primary"></i></th>
                                        <th>Nhân viên</th>
                                        <th>Khách hàng</th>
                                        <th class="text-end">Tổng cộng</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="order">
                                        <tr>
                                            <td><a href="#" class="text-primary">${order.orderID}</a></td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                            <td>
                                                <c:set var="employee" value="${accountDAO.getEmployeeByID(order.employeeID)}" />
                                                <c:choose>
                                                    <c:when test="${not empty employee and not empty employee.account}">
                                                        ${employee.account.userName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Nhân viên #${order.employeeID}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:set var="customer" value="${customerDAO.getCustomerById(order.customerID)}" />
                                                <c:choose>
                                                    <c:when test="${not empty customer}">${customer.customerName}</c:when>
                                                    <c:otherwise>Khách hàng #${order.customerID}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###" /></td>
                                            <td>
                                                <form action="<c:url value='/order-return'/>" method="post">
                                                    <input type="hidden" name="action" value="selectOrder">
                                                    <input type="hidden" name="orderId" value="${order.orderID}">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary">Chọn</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    
                                    <c:if test="${empty orders}">
                                        <tr>
                                            <td colspan="6" class="text-center">Không có đơn hàng nào</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Pagination -->
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="pagination-controls">
                                <!-- First page button -->
                                <a href="<c:url value='/order-return?page=1'/>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                                
                                <!-- Previous page button -->
                                <c:set var="prevPage" value="1" />
                                <c:if test="${currentPage > 1}">
                                    <c:set var="prevPage" value="${currentPage - 1}" />
                                </c:if>
                                <a href="<c:url value='/order-return?page=${prevPage}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                                
                                <!-- Page numbers -->
                                <c:choose>
                                    <c:when test="${totalPages <= 5}">
                                        <!-- If total pages <= 5, show all pages -->
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <a href="<c:url value='/order-return?page=${i}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
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
                                                    <a href="<c:url value='/order-return?page=${i}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </c:when>
                                            <c:when test="${currentPage + 2 >= totalPages}">
                                                <!-- If near the end, show last 5 pages -->
                                                <c:set var="startPage" value="${totalPages - 4}" />
                                                <c:forEach begin="${startPage}" end="${totalPages}" var="i">
                                                    <a href="<c:url value='/order-return?page=${i}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- If in the middle, show current page and 2 pages before/after -->
                                                <c:set var="startPage" value="${currentPage - 2}" />
                                                <c:set var="endPage" value="${currentPage + 2}" />
                                                <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                    <a href="<c:url value='/order-return?page=${i}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
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
                                <a href="<c:url value='/order-return?page=${nextPage}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                                
                                <!-- Last page button -->
                                <a href="<c:url value='/order-return?page=${totalPages}'/>" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </div>
                            
                            <!-- Pagination info -->
                            <div class="pagination-info">
                                <c:set var="startItem" value="${(currentPage-1) * ordersPerPage + 1}" />
                                <c:set var="endItem" value="${currentPage * ordersPerPage}" />
                                <c:if test="${endItem > totalOrders}">
                                    <c:set var="endItem" value="${totalOrders}" />
                                </c:if>
                                
                                Hiển thị ${startItem} - ${endItem} trên tổng số ${totalOrders} hóa đơn
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
    <script src="script.js"></script>
</body>
</html> 