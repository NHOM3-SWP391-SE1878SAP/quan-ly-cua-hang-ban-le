<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.Account" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hệ thống quản lý bán hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
        <link rel="stylesheet" href="SaleManagement.css">
        <link rel="stylesheet" href="styleHeaderSale.css">
        <style>
            .product-search {
                position: relative;
            }

            #customerSearchResults, #productSearchResults {
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                z-index: 1050;
                max-height: 400px;
                overflow-y: auto;
                background: white;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                display: none;
                margin-top: 2px;
                width: 100%;
            }

            #customerSearchResults.show, #productSearchResults.show {
                display: block !important;
            }

            .customer-item, .product-item {
                border-bottom: 1px solid #eee;
                cursor: pointer;
            }

            .customer-item:hover, .product-item:hover {
                background-color: #f0f8ff;
            }

            .customer-item:last-child, .product-item:last-child {
                border-bottom: none;
            }

            .customer-name, .product-name {
                color: #000;
                font-weight: 500;
            }

            .customer-phone, .product-code {
                color: #6c757d;
                font-size: 0.9em;
            }

            .product-price {
                color: #0d6efd;
                min-width: 70px;
                text-align: right;
            }

            .product-stock {
                color: #28a745;
                font-size: 0.85em;
            }

            .product-image img {
                object-fit: contain;
                background-color: #f8f9fa;
                border-radius: 4px;
            }

            /* Styles cho giỏ hàng */
            #cartItems li {
                padding: 10px 15px;
                border-bottom: 1px solid #eee;
                display: flex;
                flex-direction: column;
            }
            .cart-item-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 8px;
            }
            .cart-item-name {
                font-weight: 500;
                color: #000;
            }
            .cart-item-price {
                color: #0d6efd;
            }
            .cart-item-controls {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .quantity-control {
                display: flex;
                align-items: center;
            }
            .quantity-control button {
                width: 30px;
                height: 30px;
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 16px;
                cursor: pointer;
            }
            .quantity-control button:first-child {
                border-radius: 4px 0 0 4px;
            }
            .quantity-control button:last-child {
                border-radius: 0 4px 4px 0;
            }
            .quantity-control input {
                width: 40px;
                height: 30px;
                border: 1px solid #dee2e6;
                border-left: none;
                border-right: none;
                text-align: center;
            }
            .remove-item {
                color: #dc3545;
                background: none;
                border: none;
                cursor: pointer;
                font-size: 18px;
            }
        </style>
    </head>
    <body>
        <!-- Header with search bar -->
        <div class="search-bar d-flex justify-content-between align-items-center">
            <div class="search-container" style="width: 30%;">
                <i class="bi bi-search"></i>
                <input type="text" placeholder="Tìm hàng hóa" id="productSearchInput">
                <div id="productSearchResults"></div>
            </div>

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
                        <li><a class="dropdown-item" href="/order-return"><i class="bi bi-arrow-left-right"></i> Chọn hóa đơn trả hàng</a></li>
                        <li><a class="dropdown-item" href="/Logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a></li>
                    </ul>
                </div>
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
                    <button class="btn btn-primary me-2 d-flex align-items-center" id="checkoutBtn2">
                        <i class="bi bi-bag me-1"></i> Thanh toán
                    </button>          
                    <!-- Thêm form ẩn để gửi dữ liệu thanh toán -->
                    <form id="checkoutForm2" action="sale" method="post" style="display: none;">
                        <input type="hidden" name="action" value="showPayment">
                        <input type="hidden" name="cartItems" id="cartItemsData">
                        <input type="hidden" name="customerName" id="customerNameData">
                        <input type="hidden" name="customerPhone" id="customerPhoneData">
                        <input type="hidden" name="customerId" id="customerIdData">
                        <input type="hidden" name="total" id="totalData">
                    </form>
                </div>
            </div>

            <!-- Right panel - Product selection -->
            <div class="right-panel">
                <div class="product-search position-relative">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-0">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" 
                               class="form-control" 
                               placeholder="Tìm khách hàng" 
                               id="customerSearchInput" 
                               autocomplete="off">
                        <div id="customerSearchResults"></div>
                        <button class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#customerModal">
                            <i class="bi bi-plus"></i>
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
                            <div class="product-card-price">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </c:forEach>
                </div>           
            </div>
        </div>

        <!-- Modal for adding a new customer -->
        <div class="modal fade" id="customerModal" tabindex="-1" aria-labelledby="customerModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="customerModalLabel">Thêm khách hàng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="addCustomerForm">
                            <div class="mb-3">
                                <label for="customerName" class="form-label">Tên khách hàng</label>
                                <input type="text" class="form-control" id="customerName" required>
                            </div>
                            <div class="mb-3">
                                <label for="customerPhone" class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="customerPhone" required>
                            </div>
                            <div class="mb-3">
                                <label for="customerAddress" class="form-label">Địa chỉ</label>
                                <input type="text" class="form-control" id="customerAddress">
                            </div>
                            <div class="mb-3">
                                <label for="customerPoints" class="form-label">Điểm</label>
                                <input type="number" class="form-control" id="customerPoints" value="0">
                            </div>
                            <button type="submit" class="btn btn-primary">Lưu khách hàng</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>



        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="SaleManagement.js"></script>
        <script>
            document.getElementById('addCustomerForm').addEventListener('submit', function (event) {
                event.preventDefault(); // Ngừng hành động gửi form mặc định

                // Lấy thông tin từ form
                const customerName = document.getElementById('customerName').value;
                const customerPhone = document.getElementById('customerPhone').value;
                const customerAddress = document.getElementById('customerAddress').value || "";
                const customerPoints = document.getElementById('customerPoints').value;

                const customerData = {
                    customerName: customerName,
                    phone: customerPhone,
                    address: customerAddress,
                    points: customerPoints
                };

                // Gửi dữ liệu lên server
                fetch('CustomerControllerURL?service=addCustomerInSale', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(customerData)
                })
                        .then(response => response.json()) // Chuyển đổi phản hồi thành JSON
                        .then(data => {
                            if (data.success) {
                                alert('Khách hàng đã được thêm thành công!');

                                // Đóng modal đúng cách
                                var customerModalEl = document.getElementById('customerModal');
                                var customerModal = bootstrap.Modal.getInstance(customerModalEl);
                                customerModal.hide();

                                // Lấy thông tin khách hàng từ phản hồi của server
                                const customerId = data.customer.id;
                                const customerName = data.customer.customerName;
                                const customerPhone = data.customer.phone;

                                // Cập nhật thông tin ẩn nếu có
                                document.getElementById('customerIdData').value = customerId;
                                document.getElementById('customerNameData').value = customerName;
                                document.getElementById('customerPhoneData').value = customerPhone;

                                // Xóa dữ liệu form sau khi thêm thành công
                                document.getElementById('addCustomerForm').reset();
                            } else {
                                alert('Lỗi khi thêm khách hàng!');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Lỗi khi thêm khách hàng.');
                        });
            });

        </script>
    </body>
</html>