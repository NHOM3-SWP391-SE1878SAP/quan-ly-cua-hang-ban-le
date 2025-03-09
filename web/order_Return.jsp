<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống quản lý trả hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Header with search bar -->
    <div class="search-bar d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center" style="width: 30%;">
            <i class="bi bi-search me-2"></i>
            <input type="text" class="search-input" placeholder="Tìm hàng trả (F3)">
        </div>
        
        <div class="header-icons">
            <a href="#" class="header-icon"><i class="bi bi-circle"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-arrow-left"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-arrow-clockwise"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-printer"></i></a>
            <span class="header-icon">0912345678</span>
            <div class="dropdown d-inline-block">
                <a href="#" class="header-icon" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-list"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                    <li><a class="dropdown-item" href="#"><i class="bi bi-clock-history"></i> Xem báo cáo cuối ngày</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-bag"></i> Xử lý đặt hàng</a></li>
                    <li><a class="dropdown-item" href="#" data-bs-toggle="modal" data-bs-target="#orderSelectionModal"><i class="bi bi-arrow-left-right"></i> Chọn hóa đơn trả hàng</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-receipt"></i> Lập phiếu thu</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-file-earmark-arrow-up"></i> Import file</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-eye"></i> Tùy chọn hiển thị</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-keyboard"></i> Phím tắt</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-grid-3x3-gap"></i> Quản lý</a></li>
                    <li><a class="dropdown-item" href="#"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
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
                            <div class="col-1 text-end">
                                <i class="bi bi-three-dots-vertical"></i>
                            </div>
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
                                <div class="col-1 text-end">
                                    <i class="bi bi-three-dots-vertical action-menu-toggle"></i>
                                </div>
                                <div class="action-menu">
                                    <div class="action-menu-item">
                                        <i class="bi bi-pencil"></i> Ghi chú
                                    </div>
                                    <div class="action-menu-item">
                                        <i class="bi bi-info-circle"></i> Xem chi tiết
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <div class="mt-3 p-3 bg-white rounded">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-receipt me-2"></i>
                        <a href="<c:url value='/order-return'/>" class="btn btn-outline-primary">
                            Chọn hóa đơn trả hàng
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Summary section -->
            <div class="col-md-4">
                <div class="customer-info mb-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>Nguyễn Hoàng <i class="bi bi-chevron-down"></i></div>
                        <div>
                            <i class="bi bi-arrow-up"></i>
                            <i class="bi bi-chevron-right"></i>
                        </div>
                    </div>
                    <div class="mt-2">
                        <i class="bi bi-person"></i> Anh Giang - Kím Mã
                    </div>
                </div>
                
                <div class="summary-panel">
                    <div class="return-title">
                        <span>Trả hàng / HD${String.format("%06d", selectedOrder.orderID)} - 
                            <c:choose>
                                <c:when test="${selectedOrder.employeeID == 1}">Hương - Kế Toán</c:when>
                                <c:when test="${selectedOrder.employeeID == 2}">Nguyễn Hoàng</c:when>
                                <c:when test="${selectedOrder.employeeID == 3}">Hoàng - Kinh Doanh</c:when>
                                <c:otherwise>Nhân viên #${selectedOrder.employeeID}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    
                    <!-- Thông tin khách hàng -->
                    <div class="customer-info mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <c:choose>
                                    <c:when test="${selectedOrder.employeeID == 1}">Hương - Kế Toán</c:when>
                                    <c:when test="${selectedOrder.employeeID == 2}">Nguyễn Hoàng</c:when>
                                    <c:when test="${selectedOrder.employeeID == 3}">Hoàng - Kinh Doanh</c:when>
                                    <c:otherwise>Nhân viên #${selectedOrder.employeeID}</c:otherwise>
                                </c:choose>
                                <i class="bi bi-chevron-down"></i>
                            </div>
                            <div>
                                <i class="bi bi-arrow-up"></i>
                                <i class="bi bi-chevron-right"></i>
                            </div>
                        </div>
                        <div class="mt-2">
                            <i class="bi bi-person"></i> 
                            <c:choose>
                                <c:when test="${selectedOrder.customerID == 1}">Anh Giang - Kim Mã</c:when>
                                <c:when test="${selectedOrder.customerID == 2}">Phạm Thu Hương</c:when>
                                <c:when test="${selectedOrder.customerID == 3}">Anh Hoàng - Sài Gòn</c:when>
                                <c:otherwise>Khách hàng #${selectedOrder.customerID}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Tổng hợp thông tin trả hàng -->
                    <div class="summary-row">
                        <span>Tổng giá gốc hàng mua</span>
                        <span><fmt:formatNumber value="${selectedOrder.totalAmount}" pattern="#,###" /></span>
                    </div>
                    
                    <div class="summary-row">
                        <span></span>
                        <span>0</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Tổng tiền hàng trả</span>
                        <span id="subtotal">0</span>
                    </div>
                    
                    <div class="summary-row">
                        <span></span>
                        <span>0</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Giảm giá</span>
                        <span>0</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>Phí trả hàng</span>
                        <span>0</span>
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
    <script src="script.js"></script>
</body>
</html>