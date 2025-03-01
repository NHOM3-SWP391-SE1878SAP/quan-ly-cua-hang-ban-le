// Show payment modal
function showPaymentModal() {
    const modal = new bootstrap.Modal(document.getElementById('paymentModal'));
    modal.show();
}

// Show adjustment modal
function showAdjustmentModal() {
    alert('Tính năng điều chỉnh đang được phát triển');
}

// Show discount modal
function showDiscountModal() {
    alert('Tính năng chiết khấu thanh toán đang được phát triển');
}

// Export debt report
function exportDebtReport() {
    const params = new URLSearchParams(window.location.search);
    const supplierId = params.get('id');
    const fromDate = document.querySelector('input[name="fromDate"]').value;
    const toDate = document.querySelector('input[name="toDate"]').value;
    
    window.location.href = `supplier?action=exportDebt&id=${supplierId}&fromDate=${fromDate}&toDate=${toDate}`;
}

// Export transactions
function exportTransactions() {
    const params = new URLSearchParams(window.location.search);
    const supplierId = params.get('id');
    const fromDate = document.querySelector('input[name="fromDate"]').value;
    const toDate = document.querySelector('input[name="toDate"]').value;
    
    window.location.href = `supplier?action=exportTransactions&id=${supplierId}&fromDate=${fromDate}&toDate=${toDate}`;
}

// Handle payment form submission
document.getElementById('paymentForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    
    const amount = this.querySelector('input[name="amount"]').value;
    const maxAmount = this.querySelector('input[name="amount"]').getAttribute('max');
    
    if (parseFloat(amount) > parseFloat(maxAmount)) {
        alert('Số tiền thanh toán không thể lớn hơn số nợ hiện tại');
        return;
    }
    
    if (confirm('Xác nhận thanh toán?')) {
        this.submit();
    }
});

// Initialize date filters with current values from URL
document.addEventListener('DOMContentLoaded', function() {
    const params = new URLSearchParams(window.location.search);
    const fromDate = params.get('fromDate');
    const toDate = params.get('toDate');
    
    if (fromDate) {
        document.querySelector('input[name="fromDate"]').value = fromDate;
    }
    if (toDate) {
        document.querySelector('input[name="toDate"]').value = toDate;
    }
    
    // Format currency values
    document.querySelectorAll('.currency').forEach(element => {
        const value = parseFloat(element.textContent);
        element.textContent = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value);
    });
});
