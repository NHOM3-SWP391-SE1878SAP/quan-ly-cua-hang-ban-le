<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="sale-css.css">
</head>
<body>

    <div class="container mt-5">
        <div class="payment-modal-content">
            <div class="payment-modal-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5>Khách lẻ</h5>
                    <button type="button" class="btn-close" onclick="goBackToSale()"></button>
                </div>
            </div>
            <form id="checkoutForm" action="sale" method="post">
                <input type="hidden" name="action" value="checkout">
                <input type="hidden" name="totalPayable" id="totalPayableInput">
                <input type="hidden" name="customerPaid" id="customerPaidInput">
                
                <div class="payment-modal-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Tổng tiền hàng</span>
                            <span id="modalCartTotal">0</span> VND
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Giảm giá</span>
                            <span id="modalDiscount">0</span> VND
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Khách cần trả</span>
                            <span id="modalTotalPayable" class="text-primary fw-bold">0</span> VND
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Khách thanh toán</span>
                            <input type="number" id="customerPaid" class="form-control w-50" placeholder="Nhập số tiền khách đưa" required>
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
                </div>
                <div class="payment-modal-footer">
                    <button type="button" class="btn btn-primary w-100 py-3" id="confirmPaymentBtn">THANH TOÁN</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Overlay -->
    <div class="modal-overlay"></div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // Lấy tổng tiền hàng từ localStorage
            const totalPayable = localStorage.getItem("totalPayable") || 0;

            // Hiển thị tổng tiền hàng
            document.getElementById("modalCartTotal").textContent = totalPayable;
            document.getElementById("modalTotalPayable").textContent = totalPayable;

            document.getElementById("confirmPaymentBtn").addEventListener("click", function () {
                const customerPaid = document.getElementById("customerPaid").value;
                const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                if (parseInt(customerPaid) < parseInt(totalPayable)) {
                    alert("Số tiền khách trả không đủ!");
                    return;
                }

                alert("Thanh toán thành công!");
                localStorage.removeItem("cart"); // Xóa giỏ hàng sau khi thanh toán
                localStorage.removeItem("totalPayable");
                window.location.href = "sale.jsp"; // Quay lại trang bán hàng
            });
        });

        function goBackToSale() {
            window.location.href = "sale.jsp";
        }
    </script>

</body>
</html>
