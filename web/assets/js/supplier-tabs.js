document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('.tab');
    const supplierId = document.querySelector('input[name="id"]').value;
    
    tabs.forEach((tab, index) => {
        tab.addEventListener('click', () => {
            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('active'));
            // Add active class to clicked tab
            tab.classList.add('active');
            
            // Handle tab switching
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
});
