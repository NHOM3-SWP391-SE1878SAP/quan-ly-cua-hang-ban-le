/**
 * Hệ thống quản lý trả hàng - JavaScript
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded'); // Debug log
    // Khởi tạo các chức năng chung
    initializeQuantityControls();
    initializeActionMenus();
    calculateTotals();
    
    // Thêm xử lý nút trả hàng
    initializeReturnButton();
});

// Khởi tạo điều khiển số lượng
function initializeQuantityControls() {
    const minusBtns = document.querySelectorAll('.minus-btn');
    const plusBtns = document.querySelectorAll('.plus-btn');
    const quantityInputs = document.querySelectorAll('.quantity-input');
    const quantityDisplays = document.querySelectorAll('.quantity-display');

    // Thiết lập sự kiện cho nút giảm
    minusBtns.forEach((btn) => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('.quantity-input');
            const productId = input.getAttribute('data-product-id');
            const currentValue = parseInt(input.value);
            if (currentValue > 0) {
                input.value = currentValue - 1;
                updateQuantityDisplay(input);
                updateProductTotal(input);
                calculateTotals(); // Cập nhật tổng tiền
            }
        });
    });

    // Thiết lập sự kiện cho nút tăng
    plusBtns.forEach((btn) => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('.quantity-input');
            const productId = input.getAttribute('data-product-id');
            const currentValue = parseInt(input.value);
            const maxValue = parseInt(input.getAttribute('max') || 9999);
            if (currentValue < maxValue) {
                input.value = currentValue + 1;
                updateQuantityDisplay(input);
                updateProductTotal(input);
                calculateTotals(); // Cập nhật tổng tiền
            }
        });
    });

    // Thiết lập sự kiện cho thay đổi trực tiếp
    quantityInputs.forEach((input) => {
        input.addEventListener('change', function() {
            const maxValue = parseInt(this.getAttribute('max') || 9999);
            let value = parseInt(this.value) || 0;
            
            // Đảm bảo giá trị nằm trong phạm vi hợp lệ
            if (value < 0) value = 0;
            if (value > maxValue) value = maxValue;
            
            this.value = value;
            updateQuantityDisplay(this);
            updateProductTotal(this);
            calculateTotals(); // Cập nhật tổng tiền
        });
    });
}

// Cập nhật hiển thị số lượng
function updateQuantityDisplay(input) {
    const display = input.closest('.quantity-container').querySelector('.quantity-display');
    if (!display) return;
    
    const maxValue = input.getAttribute('max') || '';
    const currentValue = input.value;
    
    display.textContent = `${currentValue} / ${maxValue}`;
}

// Cập nhật thành tiền cho mỗi sản phẩm
function updateProductTotal(input) {
    const productId = input.getAttribute('data-product-id');
    const currentValue = parseInt(input.value);
    const price = parseInt(input.getAttribute('data-price'));
    const total = currentValue * price;
    
    const productTotalElement = document.querySelector(`.product-total[data-product-id="${productId}"]`);
    if (productTotalElement) {
        productTotalElement.textContent = formatCurrency(total);
    }
    
    // Cập nhật input hidden cho form nếu có
    const hiddenInput = document.querySelector(`input[name="returnQuantity_${productId}"]`);
    if (hiddenInput) {
        hiddenInput.value = currentValue;
    }
}

// Khởi tạo menu hành động
function initializeActionMenus() {
    const actionMenuToggles = document.querySelectorAll('.action-menu-toggle');
    const actionMenus = document.querySelectorAll('.action-menu');

    actionMenuToggles.forEach((toggle, index) => {
        toggle.addEventListener('click', function(e) {
            e.stopPropagation();
            
            // Đóng tất cả các menu khác
            actionMenus.forEach((menu) => {
                if (menu !== this.closest('.product-row').querySelector('.action-menu')) {
                    menu.classList.remove('show');
                }
            });
            
            // Chuyển đổi menu hiện tại
            const menu = this.closest('.product-row').querySelector('.action-menu');
            menu.classList.toggle('show');
        });
    });

    // Đóng menu hành động khi nhấp vào nơi khác
    document.addEventListener('click', function() {
        actionMenus.forEach(menu => {
            menu.classList.remove('show');
        });
    });

    // Ngăn menu đóng khi nhấp vào bên trong nó
    actionMenus.forEach(menu => {
        menu.addEventListener('click', function(e) {
            e.stopPropagation();
        });
    });
}

// Tính toán tổng tiền
function calculateTotals() {
    const quantityInputs = document.querySelectorAll('.quantity-input');
    let subtotal = 0;
    
    quantityInputs.forEach((input) => {
        const quantity = parseInt(input.value) || 0;
        const price = parseInt(input.getAttribute('data-price')) || 0;
        
        subtotal += quantity * price;
    });
    
    // Cập nhật hiển thị tổng tiền
    const subtotalElement = document.getElementById('subtotal');
    const totalElement = document.getElementById('total');
    
    if (subtotalElement) {
        subtotalElement.textContent = formatCurrency(subtotal);
    }
    
    if (totalElement) {
        totalElement.textContent = formatCurrency(subtotal);
    }
    
    // Cập nhật input hidden cho form nếu có
    const totalAmountInput = document.querySelector('input[name="totalAmount"]');
    if (totalAmountInput) {
        totalAmountInput.value = subtotal;
    }
}

// Định dạng tiền tệ
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN').format(amount);
}

function initializeReturnButton() {
    const submitReturnBtn = document.getElementById('submitReturnBtn');
    console.log('Submit button:', submitReturnBtn); // Debug log
    
    if (submitReturnBtn) {
        submitReturnBtn.addEventListener('click', function(e) {
            console.log('Button clicked'); // Debug log
            e.preventDefault();
            
            // Kiểm tra xem có sản phẩm nào được chọn để trả không
            const quantityInputs = document.querySelectorAll('.quantity-input');
            let hasItems = false;
            let totalQuantity = 0;
            
            quantityInputs.forEach(input => {
                const quantity = parseInt(input.value) || 0;
                totalQuantity += quantity;
                if (quantity > 0) {
                    hasItems = true;
                }
            });
            
            if (!hasItems) {
                alert('Vui lòng chọn ít nhất một sản phẩm để trả');
                return;
            }

            // Cập nhật tổng tiền lần cuối
            calculateTotals();
            
            // Xác nhận trước khi submit
            if (confirm(`Xác nhận trả ${totalQuantity} sản phẩm?`)) {
                const returnForm = document.getElementById('returnForm');
                console.log('Form:', returnForm); // Debug log
                
                if (returnForm) {
                    returnForm.submit();
                } else {
                    console.error('Form not found!');
                }
            }
        });
    } else {
        console.error('Return button not found!'); // Debug log
    }
}