<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.Account" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trả hàng - Hệ thống quản lý</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="styleHeaderSale.css">
        <style>
            body {
                background-color: #f5f5f5;
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
        <div class="search-bar d-flex justify-content-end align-items-center ">


            <div class="header-icons">
                <% 
Account account = (Account) session.getAttribute("account");
String phoneNumber = (account != null) ? account.getPhone() : "Chưa đăng nhập";
                %>
                <span class="header-icon"><%= phoneNumber %></span>
                <div class="dropdown d-inline-block">
                    <a href="#" class="header-icon" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-list"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                        <li><a class="dropdown-item" href="/sale"><i class="bi bi-bag"></i> Bán hàng</a></li>
                        <li><a class="dropdown-item" href="/report"><i class="bi bi-clock-history"></i> Xem báo cáo cuối ngày</a></li>
                        <li><a class="dropdown-item" href="/order-return" ><i class="bi bi-arrow-left-right"></i> Chọn hóa đơn trả hàng</a></li>
                         <li>
                    <a class="dropdown-item" href="change-password.jsp">
                        <i class="bi bi-question-circle"></i> Đổi mật khẩu
                    </a>
                </li>
                        <li><a class="dropdown-item" href="/Logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Main Content -->
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
                                <label class="form-label small">Theo khách hàng hoặc ĐT</label>
                                <input type="text" class="form-control form-control-sm" name="customer" placeholder="Nhập tên hoặc SĐT" value="${customerSearch}">
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
                            <input type="hidden" name="page" value="${currentPage}">
                        </form>
                    </div>
                </div>
            </div>

            <!-- Right side with order table -->
            <div class="col-md-9">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Danh sách hóa đơn</h5>
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
                                                        ${employee.employeeName}
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
                                                    <c:otherwise>Khách lẻ</c:otherwise>
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
                        <!-- Pagination Controls -->
                        <div class="pagination-controls">
                            <!-- First page button -->
                            <a href="<c:url value='/order-return?page=1&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>

                            <!-- Previous page button -->
                            <c:set var="prevPage" value="1" />
                            <c:if test="${currentPage > 1}">
                                <c:set var="prevPage" value="${currentPage - 1}" />
                            </c:if>
                            <a href="<c:url value='/order-return?page=${prevPage}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                <i class="bi bi-chevron-left"></i>
                            </a>

                            <!-- Page numbers -->
                            <c:choose>
                                <c:when test="${totalPages <= 5}">
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a href="<c:url value='/order-return?page=${i}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                            ${i}
                                        </a>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${currentPage <= 3}">
                                            <c:forEach begin="1" end="5" var="i">
                                                <a href="<c:url value='/order-return?page=${i}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                    ${i}
                                                </a>
                                            </c:forEach>
                                        </c:when>
                                        <c:when test="${currentPage + 2 >= totalPages}">
                                            <c:set var="startPage" value="${totalPages - 4}" />
                                            <c:forEach begin="${startPage}" end="${totalPages}" var="i">
                                                <a href="<c:url value='/order-return?page=${i}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
                                                    ${i}
                                                </a>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="startPage" value="${currentPage - 2}" />
                                            <c:set var="endPage" value="${currentPage + 2}" />
                                            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                                                <a href="<c:url value='/order-return?page=${i}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm ${i == currentPage ? 'btn-primary' : 'btn-outline-secondary'} me-1">
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
                            <a href="<c:url value='/order-return?page=${nextPage}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm btn-outline-secondary me-1">
                                <i class="bi bi-chevron-right"></i>
                            </a>

                            <!-- Last page button -->
                            <a href="<c:url value='/order-return?page=${totalPages}&orderId=${orderIdSearch}&customer=${customerSearch}&productId=${productIdSearch}&productName=${productNameSearch}&fromDate=${fromDate}&toDate=${toDate}'/>" class="btn btn-sm btn-outline-secondary">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </div>

                        <!-- Pagination Info -->
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

    <!-- Footer -->
    <footer class="bg-light py-3 mt-5">
        <div class="container text-center">

        </div>
    </footer>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="SaleManagement.js"></script>
</body>
</html> 