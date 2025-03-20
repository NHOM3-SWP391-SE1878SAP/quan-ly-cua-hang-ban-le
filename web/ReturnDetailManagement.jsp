<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.Account" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống quản lý trả hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="styleHeaderSale.css">
</head>
<body>
    <!-- Header with search bar -->
    <div class="search-bar d-flex justify-content-end align-items-center">
        
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
                    <li><a class="dropdown-item" href="/Logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                </ul>
            </div>
        </div>
    </div>

    <div class="container-fluid mt-3">
        <div class="row">
            <!-- Product list section -->
            <div class="col-md-8">
                <div class="product-table">
                    <div class="container-fluid">
                        <div class="row py-2 bg-light">
                            <div class="col-1">#</div>
                            <div class="col-2">Mã SP</div>
                            <div class="col-3">Tên sản phẩm</div>
                            <div class="col-2 text-center">Số lượng</div>
                            <div class="col-2 text-end">Đơn giá</div>
                            <div class="col-1 text-end">Thành tiền</div>
                        </div>
                        
                        <c:forEach var="detail" items="${orderDetails}" varStatus="status">
                            <c:set var="product" value="${productMap[detail.productID]}" />
                            <div class="row product-row align-items-center">
                                <div class="col-1">${status.index + 1}</div>
                                <div class="col-2">${product.productCode}</div>
                                <div class="col-3">${product.productName}</div>
                                <div class="col-2 text-center">
                                    <div class="quantity-container">
                                        <span class="quantity-display">0 / ${detail.quantity}</span>
                                        <div class="quantity-controls">
                                            <button class="quantity-btn minus-btn" data-product-id="${detail.productID}">
                                                <i class="bi bi-dash-circle"></i>
                                            </button>
                                            <input type="number" class="quantity-input" 
                                                   value="0" min="0" max="${detail.quantity}" 
                                                   data-product-id="${detail.productID}" 
                                                   data-price="${detail.price}">
                                            <button class="quantity-btn plus-btn" data-product-id="${detail.productID}">
                                                <i class="bi bi-plus-circle"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-2 text-end">
                                    <fmt:formatNumber value="${detail.price}" pattern="#,###" />
                                </div>
                                <div class="col-1 text-end product-total" data-product-id="${detail.productID}">0</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="mt-3 p-3 bg-white rounded">
                    <div class="d-flex align-items-center">
                        <a href="<c:url value='/order-return'/>" class="btn btn-outline-primary">
                            Chọn hóa đơn trả hàng
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Summary section -->
            <div class="col-md-4">  
                <div class="summary-panel">
                 <!-- Thông tin khách hàng -->
                    <div class="customer-info mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <c:set var="employee" value="${accountDAO.getEmployeeByID(selectedOrder.employeeID)}" />
                                <c:choose>
                                    <c:when test="${not empty employee}">${employee.employeeName}</c:when>
                                    <c:otherwise>Nhân viên #${selectedOrder.employeeID}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mt-2">
                            <i class="bi bi-person"></i> 
                            <c:set var="customer" value="${customerDAO.getCustomerById(selectedOrder.customerID)}" />
                            <c:choose>
                                <c:when test="${not empty customer}">${customer.customerName}</c:when>
                                <c:otherwise>Khách lẻ</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Tổng hợp thông tin trả hàng -->
                    <div class="summary-row">
                        <span>Tổng giá gốc hàng mua</span>
                        <span><fmt:formatNumber value="${selectedOrder.totalAmount}" pattern="#,###" /></span>
                    </div>
                                       
                    <div class="summary-row">
                        <span>Tổng tiền hàng trả</span>
                        <span id="subtotal">0</span>
                    </div>                 
                    
                    <div class="summary-row">
                        <span>Cần trả khách</span>
                        <span id="total">0</span>
                    </div>
                    
                    <form action="<c:url value='/order-return'/>" method="post" id="returnForm">
                        <input type="hidden" name="action" value="submitReturn">
                        <input type="hidden" name="orderId" value="${selectedOrder.orderID}">
                        <input type="hidden" name="totalAmount" id="hiddenTotalAmount" value="0">
                        
                        <c:forEach var="detail" items="${orderDetails}">
                            <input type="hidden" name="returnQuantity_${detail.productID}" 
                                   id="returnQuantity_${detail.productID}" value="0">
                        </c:forEach>
                        
                        <button type="submit" class="btn btn-primary w-100" id="submitReturnBtn">
                            <i class="bi bi-arrow-return-left"></i> TRẢ HÀNG
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="SaleManagement.js"></script>
</body>
</html>