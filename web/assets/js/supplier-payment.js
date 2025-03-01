// Show payment modal
function showPaymentModal() {
    const modal = new bootstrap.Modal(document.getElementById('paymentModal'));
    modal.show();
}

// Show adjustment modal
function showAdjustmentModal() {
    // To be implemented
    alert('Tính năng đang được phát triển');
}

// Show discount modal
function showDiscountModal() {
    // To be implemented
    alert('Tính năng đang được phát triển');
}

// Export debt report
function exportDebtReport() {
    const supplierId = document.querySelector('input[name="supplierId"]').value;
    window.location.href = `supplier?action=exportDebt&id=${supplierId}`;
}

// Export transactions
function exportTransactions() {
    const supplierId = document.querySelector('input[name="supplierId"]').value;
    window.location.href = `supplier?action=exportTransactions&id=${supplierId}`;
}

// Handle tab switching
document.querySelectorAll('.tab-item').forEach((tab, index) => {
    tab.addEventListener('click', () => {
        // Remove active class from all tabs
        document.querySelectorAll('.tab-item').forEach(t => t.classList.remove('active'));
        // Add active class to clicked tab
        tab.classList.add('active');
        
        const supplierId = document.querySelector('input[name="supplierId"]').value;
        
        // Load content based on tab index
        switch(index) {
            case 0: // Thông tin
                window.location.href = `supplier?action=view&id=${supplierId}`;
                break;
            case 1: // Lịch sử nhập/trả hàng
                window.location.href = `supplier?action=history&id=${supplierId}`;
                break;
            case 2: // Nợ cần trả NCC
                window.location.href = `supplier?action=debt&id=${supplierId}`;
                break;
        }
    });
});

// Filter form submit handler
document.querySelector('form#filterForm')?.addEventListener('submit', (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    const params = new URLSearchParams(formData);
    window.location.href = `supplier?action=filter&${params.toString()}`;
});

// Payment form submit handler
document.querySelector('form#paymentForm')?.addEventListener('submit', (e) => {
    e.preventDefault();
    if (confirm('Xác nhận thanh toán?')) {
        e.target.submit();
    }
});
