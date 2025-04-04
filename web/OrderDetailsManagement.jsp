<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý hóa đơn</title>
        <link rel="stylesheet" href="assets/vendor/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/vendor/bootstrap-icons/bootstrap-icons.css">
        <link rel="stylesheet" href="assets/css/style.css">
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
            .main-content {
                margin-left: 300px; /* Adjust according to the sidebar width */
                margin-top: 40px;  /* Adjust this value based on the header height */
            }
        </style>
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>
        <!-- Main Content -->
        <div class="main-content">
           <div class="container py-4 mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <c:choose>
                        <c:when test="${detailType eq 'SALE'}">
                            Chi tiết đơn hàng #${order.orderID}
                        </c:when>
                        <c:otherwise>
                            Chi tiết đơn trả hàng #${returnOrder.returnID}
                        </c:otherwise>
                    </c:choose>
                </h2>
                <a href="order" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>

            <!-- Thông tin chung -->
            <div class="row mb-4">
                <div class="col-md-6">
                    <div class="card mb-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Thông tin chung</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${detailType eq 'SALE'}">
                                    <p><strong>Mã đơn hàng:</strong> #${order.orderID}</p>
                                    <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                                    <p><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></p>
                                    <c:if test="${voucher != null}">
                                        <p>
                                            <strong>Voucher:</strong> 
                                            <span class="badge bg-info">${voucher.code}</span>
                                            <span class="text-muted">
                                                (Giảm ${voucher.discountRate}%, tối đa <fmt:formatNumber value="${voucher.maxValue}" type="currency" currencySymbol="₫" maxFractionDigits="0" />)
                                            </span>
                                        </p>
                                    </c:if>
                                    <c:if test="${returnIds != null && !empty returnIds}">
    <p><strong>Mã trả hàng:</strong></p>
    <ul>
        <c:forEach var="returnId" items="${returnIds}">
            <li>#${returnId}</li>
        </c:forEach>
    </ul>
</c:if>
                                </c:when>
                                <c:otherwise>
                                    <p><strong>Mã đơn trả:</strong> #${returnOrder.returnID}</p>
                                    <p><strong>Ngày trả:</strong> <fmt:formatDate value="${returnOrder.returnDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                                    <p><strong>Số tiền hoàn trả:</strong> <fmt:formatNumber value="${returnOrder.refundAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></p>
                                    <p><strong>Đơn hàng gốc:</strong> #${returnOrder.orderId}</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card mb-3">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Thông tin khách hàng & nhân viên</h5>
                        </div>
                        <div class="card-body">
                            <p><strong>Khách hàng:</strong> ${customer != null ? customer.customerName : 'Khách lẻ'}</p>
                            <c:if test="${customer != null && not empty customer.phone}">
                                <p><strong>Số điện thoại:</strong> ${customer.phone}</p>
                            </c:if>
                            <c:if test="${customer != null && not empty customer.address}">
                                <p><strong>Địa chỉ:</strong> ${customer.address}</p>
                            </c:if>
                            <p><strong>Nhân viên:</strong> ${employee != null ? employee.employeeName : 'Không có'}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chi tiết sản phẩm -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-0">Chi tiết sản phẩm</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th class="text-center">Số lượng</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-end">Thành tiền</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${detailType eq 'SALE'}">
                                        <c:set var="totalAmount" value="0" />
                                        <c:forEach var="detail" items="${orderDetails}" varStatus="status">
                                            <c:set var="product" value="${daoProduct.getProductById(detail.productID)}" />
                                            <c:set var="subtotal" value="${detail.price * detail.quantity}" />
                                            <c:set var="totalAmount" value="${totalAmount + subtotal}" />
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>${product != null ? product.productCode : 'Sản phẩm không tồn tại'}</td>
                                                <td>${product != null ? product.productName : 'Sản phẩm không tồn tại'}</td>
                                                <td class="text-center">${detail.quantity}</td>
                                                <td class="text-end"><fmt:formatNumber value="${detail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                                <td class="text-end"><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="totalAmount" value="0" />
                                        <c:forEach var="detail" items="${returnDetails}" varStatus="status">
                                            <c:set var="orderDetail" value="${daoOrderDetails.getOrderDetailById(detail.orderDetailsId)}" />
                                            <c:set var="product" value="${orderDetail != null ? daoProduct.getProductById(orderDetail.productID) : null}" />
                                            <c:set var="price" value="${orderDetail != null ? orderDetail.price : 0}" />
                                            <c:set var="subtotal" value="${price * detail.quantity}" />
                                            <c:set var="totalAmount" value="${totalAmount + subtotal}" />
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td>${product != null ? product.productCode : 'Sản phẩm không tồn tại'}</td>
                                                <td>${product != null ? product.productName : 'Sản phẩm không tồn tại'}</td>
                                                <td class="text-center">${detail.quantity}</td>
                                                <td class="text-end"><fmt:formatNumber value="${price}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                                <td class="text-end"><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                            <tfoot class="table-light">
                                <tr>
                                    <td colspan="5" class="text-end"><strong>Tổng cộng:</strong></td>
                                    <td class="text-end">
                                        <strong>
                                            <c:choose>
                                                <c:when test="${detailType eq 'SALE'}">
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${returnOrder.refundAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>