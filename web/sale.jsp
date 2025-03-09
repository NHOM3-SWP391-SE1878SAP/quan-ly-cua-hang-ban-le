<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống quản lý bán hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="sale-css.css">
</head>
<body>
    <!-- Header with search bar -->
    <div class="top-header">
        <div class="search-container">
            <i class="bi bi-search"></i>
            <input type="text" placeholder="Tìm hàng hóa (F3)" id="productSearchInput">
        </div>
        
        <div class="tab-container">
            <span>Hóa đơn 1</span>
            <span class="tab-close">×</span>
        </div>
        
        <div class="header-icons">
            <a href="#" class="header-icon"><i class="bi bi-cart"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-arrow-left"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-arrow-clockwise"></i></a>
            <a href="#" class="header-icon"><i class="bi bi-printer"></i></a>
            <span class="header-icon">0912345678</span>
            <a href="#" class="header-icon"><i class="bi bi-list"></i></a>
        </div>
    </div>

    <div class="main-container">
        <!-- Left panel - Cart -->
        <div class="left-panel">
            <ul class="product-list" id="cartItems">
                <!-- Cart items will be dynamically added here -->
            </ul>
            
            <div class="cart-summary">
                <div class="summary-row">
                    <span>Tổng tiền hàng</span>
                    <span id="cartTotal">0</span>
                </div>
                
                <div class="summary-row">
                    <span>Số lượng</span>
                    <span id="cartQuantity">0</span>
                </div>
            </div>
            
            <div class="cart-actions">
                <button class="btn btn-secondary me-2 d-flex align-items-center">
                    <i class="bi bi-lightning me-1"></i> Bán nhanh
                </button>
                
                <button class="btn btn-primary me-2 d-flex align-items-center">
                    <i class="bi bi-bag me-1"></i> Bán thường
                </button>
                
                <button class="btn btn-outline-secondary d-flex align-items-center">
                    <i class="bi bi-truck me-1"></i> Bán giao hàng
                </button>
            </div>
        </div>
        
        <!-- Right panel - Product selection -->
        <div class="right-panel">
            <div class="product-search">
                <div class="input-group">
                    <span class="input-group-text bg-light border-0">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" class="form-control" placeholder="Tìm khách hàng (F4)">
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-plus"></i>
                    </button>
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-list"></i>
                    </button>
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-funnel"></i>
                    </button>
                    <button class="btn btn-outline-secondary">
                        <i class="bi bi-grid"></i>
                    </button>
                </div>
            </div>
            
            <div class="product-grid">
                <c:forEach var="product" items="${products}">
                    <div class="product-card" 
                         data-product-id="${product.id}" 
                         data-product-code="${product.productCode}" 
                         data-product-name="${product.productName}" 
                         data-product-price="${product.price}"
                         data-product-stockquantity="${product.stockQuantity}">
                        <img src="${not empty product.imageURL ? product.imageURL : 'https://via.placeholder.com/60'}" 
                             alt="${product.productName}">
                        <div class="product-card-name">${product.productName}</div>
                        <div class="product-card-price">${product.price}</div>
                    </div>
                </c:forEach>
            </div>
            
            <form id="checkoutForm" action="payment.jsp" method="GET">
    <input type="hidden" name="cartItems" id="cartItemsInput">
    <input type="hidden" name="totalPayable" id="totalPayableInput">
    <button type="submit" class="checkout-btn">Thanh Toán</button>
</form>

            
            <div class="d-flex justify-content-between mt-3">
                <div class="d-flex align-items-center">
                    <i class="bi bi-telephone me-2"></i>
                    <span>1900 6522</span>
                </div>
                <div>
                    <i class="bi bi-question-circle me-2"></i>
                    <i class="bi bi-chat"></i>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Thanh Toán -->
    <div class="payment-modal" id="paymentModal">
        <div class="payment-modal-content">
            <div class="payment-modal-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5>Khách lẻ</h5>
                    <button type="button" class="btn-close" id="closePaymentModal"></button>
                </div>
            </div>
            <form id="checkoutForm" action="sale" method="post">
                <input type="hidden" name="action" value="checkout">
                <input type="hidden" name="cartItems" id="cartItemsInput">
                <input type="hidden" name="totalPayable" id="totalPayableInput">
                <input type="hidden" name="customerPaid" id="customerPaidInput">
                
                <div class="payment-modal-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Tổng tiền hàng</span>
                            <span id="modalCartTotal">0</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Giảm giá</span>
                            <span id="modalDiscount">0</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Khách cần trả</span>
                            <span id="modalTotalPayable" class="text-primary fw-bold">0</span>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Khách thanh toán</span>
                            <span id="modalCustomerPaid" class="fw-bold">0</span>
                        </div>
                    </div>
                    
                    <div class="payment-methods mb-3">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="cashPayment" value="cash" checked>
                            <label class="form-check-label" for="cashPayment">Tiền mặt</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="transferPayment" value="transfer">
                            <label class="form-check-label" for="transferPayment">Chuyển khoản</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="cardPayment" value="card">
                            <label class="form-check-label" for="cardPayment">Thẻ</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="paymentMethod" id="vnpayPayment" value="vnpay">
                            <label class="form-check-label" for="vnpayPayment">VNPay</label>
                        </div>
                    </div>
                    
                    <div class="payment-amounts">
                        <div class="row">
                            <div class="col-3 mb-2">
                                <button type="button" class="btn btn-outline-secondary w-100 payment-amount-btn" data-amount="95000">95,000</button>
                            </div>
                            <div class="col-3 mb-2">
                                <button type="button" class="btn btn-outline-secondary w-100 payment-amount-btn" data-amount="96000">96,000</button>
                            </div>
                            <div class="col-3 mb-2">
                                <button type="button" class="btn btn-outline-secondary w-100 payment-amount-btn" data-amount="100000">100,000</button>
                            </div>
                            <div class="col-3 mb-2">
                                <button type="button" class="btn btn-outline-secondary w-100 payment-amount-btn" data-amount="200000">200,000</button>
                            </div>
                            <div class="col-3 mb-2">
                                <button type="button" class="btn btn-outline-secondary w-100 payment-amount-btn" data-amount="500000">500,000</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="payment-modal-footer">
                    <button type="submit" class="btn btn-primary w-100 py-3" id="confirmPaymentBtn">THANH TOÁN</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Modal Overlay -->
    <div class="modal-overlay" id="modalOverlay"></div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="sale-script.js"></script>
</body>
</html>