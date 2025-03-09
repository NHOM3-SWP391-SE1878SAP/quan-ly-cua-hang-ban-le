document.addEventListener('DOMContentLoaded', function() {
    // Khởi tạo giỏ hàng
    let cart = [];
    
    // Giới hạn số lượng sản phẩm
    const MIN_QUANTITY = 1;
    const DEFAULT_MAX_QUANTITY = 999; // Giá trị mặc định nếu không có thông tin tồn kho
    
    // Xử lý khi click vào sản phẩm
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(card => {
        card.addEventListener('click', function() {
            // Lấy thông tin sản phẩm từ data attributes
            const productId = parseInt(this.getAttribute('data-product-id'));
            const productCode = this.getAttribute('data-product-code');
            const productName = this.getAttribute('data-product-name');
            const productPrice = parseInt(this.getAttribute('data-product-price'));
            const productStock = parseInt(this.getAttribute('data-product-stockquantity') || DEFAULT_MAX_QUANTITY);
            
            // Debug: In thông tin sản phẩm ra console
            console.log("Clicked product:", {
                id: productId,
                code: productCode,
                name: productName,
                price: productPrice,
                stock: productStock
            });
            
            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            const existingItem = cart.find(item => item.id === productId);
            
            if (existingItem) {
                // Nếu đã có, tăng số lượng nếu chưa đạt giới hạn tồn kho
                if (existingItem.quantity < productStock) {
                    existingItem.quantity += 1;
                } else {
                    alert(`Số lượng sản phẩm "${productName}" trong kho chỉ còn ${productStock}`);
                }
            } else {
                // Nếu chưa có, thêm mới vào giỏ hàng
                cart.push({
                    id: productId,
                    code: productCode,
                    name: productName,
                    price: productPrice,
                    quantity: 1,
                    stock: productStock
                });
            }
            
            // Cập nhật hiển thị giỏ hàng
            localStorage.setItem("cart", JSON.stringify(cart));
            updateCartDisplay();
        });
    });
    
    // Hàm cập nhật hiển thị giỏ hàng
    function updateCartDisplay() {
        const cartItemsContainer = document.getElementById('cartItems');
        cartItemsContainer.innerHTML = '';
        
        let totalAmount = 0;
        let totalQuantity = 0;
        
        cart.forEach(item => {
            const li = document.createElement('li');
            li.className = 'product-item';
            
            const totalItemPrice = item.price * item.quantity;
            totalAmount += totalItemPrice;
            totalQuantity += item.quantity;
            
            li.innerHTML = `
                <div class="product-info">
                    <div class="product-name">${item.name}</div>
                    <div class="product-price">${item.price.toLocaleString('vi-VN')}</div>
                </div>
                <div class="product-quantity">
                    <button class="quantity-btn quantity-decrease" data-product-id="${item.id}" data-product-stockquantity="${item.stock}">-</button>
                    <input type="text" value="${item.quantity}" data-product-id="${item.id}" data-product-stockquantity="${item.stock}">
                    <button class="quantity-btn quantity-increase" data-product-id="${item.id}" data-product-stockquantity="${item.stock}">+</button>
                </div>
                <div class="product-total">${totalItemPrice.toLocaleString('vi-VN')}</div>
                <button class="remove-btn" data-product-id="${item.id}">×</button>
            `;
            
            cartItemsContainer.appendChild(li);
        });
        
        // Cập nhật tổng tiền và số lượng
        document.getElementById('cartTotal').textContent = totalAmount.toLocaleString('vi-VN');
        document.getElementById('cartQuantity').textContent = totalQuantity;
        
        // Thêm sự kiện cho các nút tăng/giảm số lượng
        const decreaseButtons = document.querySelectorAll('.quantity-decrease');
        const increaseButtons = document.querySelectorAll('.quantity-increase');
        const quantityInputs = document.querySelectorAll('.product-quantity input');
        const removeButtons = document.querySelectorAll('.remove-btn');
        
        decreaseButtons.forEach(button => {
            button.addEventListener('click', function() {
                const productId = parseInt(this.getAttribute('data-product-id'));
                const item = cart.find(item => item.id === productId);
                
                if (item && item.quantity > MIN_QUANTITY) {
                    item.quantity -= 1;
                    updateCartDisplay();
                }
            });
        });
        
        increaseButtons.forEach(button => {
            button.addEventListener('click', function() {
                const productId = parseInt(this.getAttribute('data-product-id'));
                const productStock = parseInt(this.getAttribute('data-product-stockquantity') || DEFAULT_MAX_QUANTITY);
                const item = cart.find(item => item.id === productId);
                
                if (item && item.quantity < productStock) {
                    item.quantity += 1;
                    updateCartDisplay();
                } else if (item) {
                    alert(`Số lượng sản phẩm "${item.name}" trong kho chỉ còn ${productStock}`);
                }
            });
        });
        
        quantityInputs.forEach(input => {
            input.addEventListener('change', function() {
                const productId = parseInt(this.getAttribute('data-product-id'));
                const productStock = parseInt(this.getAttribute('data-product-stockquantity') || DEFAULT_MAX_QUANTITY);
                const newQuantity = parseInt(this.value);
                const item = cart.find(item => item.id === productId);
                
                if (item) {
                    if (newQuantity >= MIN_QUANTITY && newQuantity <= productStock) {
                        item.quantity = newQuantity;
                    } else if (newQuantity < MIN_QUANTITY) {
                        item.quantity = MIN_QUANTITY;
                        alert(`Số lượng sản phẩm tối thiểu là ${MIN_QUANTITY}`);
                    } else {
                        item.quantity = productStock;
                        alert(`Số lượng sản phẩm "${item.name}" trong kho chỉ còn ${productStock}`);
                    }
                    updateCartDisplay();
                }
            });
        });
        
        removeButtons.forEach(button => {
            button.addEventListener('click', function() {
                const productId = parseInt(this.getAttribute('data-product-id'));
                cart = cart.filter(item => item.id !== productId);
                updateCartDisplay();
            });
        });
    }
    
    // Xử lý nút thanh toán
    const checkoutBtn = document.getElementById('checkoutBtn');
    const paymentModal = document.getElementById('paymentModal');
    const modalOverlay = document.getElementById('modalOverlay');
    const closePaymentModal = document.getElementById('closePaymentModal');
    
    checkoutBtn.addEventListener('click', function() {
        if (cart.length === 0) {
            alert('Giỏ hàng trống. Vui lòng thêm sản phẩm vào giỏ hàng.');
            return;
        }
        
        // Cập nhật thông tin trong modal thanh toán
        const totalAmount = cart.reduce((total, item) => total + (item.price * item.quantity), 0);
        const discount = 0; // Giả sử không có giảm giá
        const totalPayable = totalAmount - discount;
        
        document.getElementById('modalCartTotal').textContent = totalAmount.toLocaleString('vi-VN');
        document.getElementById('modalDiscount').textContent = discount.toLocaleString('vi-VN');
        document.getElementById('modalTotalPayable').textContent = totalPayable.toLocaleString('vi-VN');
        document.getElementById('modalCustomerPaid').textContent = totalPayable.toLocaleString('vi-VN');
        
        // Hiển thị modal
        paymentModal.classList.add('show');
        modalOverlay.classList.add('show');
    });
    
    closePaymentModal.addEventListener('click', function() {
        paymentModal.classList.remove('show');
        modalOverlay.classList.remove('show');
    });
    
    // Xử lý các nút số tiền thanh toán
    const paymentAmountButtons = document.querySelectorAll('.payment-amount-btn');
    paymentAmountButtons.forEach(button => {
        button.addEventListener('click', function() {
            const amount = parseInt(this.getAttribute('data-amount'));
            document.getElementById('modalCustomerPaid').textContent = amount.toLocaleString('vi-VN');
        });
    });
    
    // Xử lý form thanh toán
    const checkoutForm = document.getElementById('checkoutForm');
    checkoutForm.addEventListener('submit', function(e) {
        // Ngăn chặn hành vi mặc định của form
        e.preventDefault();
        
        // Lấy phương thức thanh toán
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
        
        // Lấy số tiền khách trả
        const customerPaid = parseInt(document.getElementById('modalCustomerPaid').textContent.replace(/\D/g, ''));
        
        // Lấy tổng tiền cần trả
        const totalPayable = parseInt(document.getElementById('modalTotalPayable').textContent.replace(/\D/g, ''));
        
        // Kiểm tra số tiền khách trả
        if (customerPaid < totalPayable) {
            alert('Số tiền khách trả không đủ!');
            return;
        }
        
        // Cập nhật các input hidden
        document.getElementById('cartItemsInput').value = JSON.stringify(cart);
        document.getElementById('totalPayableInput').value = totalPayable;
        document.getElementById('customerPaidInput').value = customerPaid;
        
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
    e.preventDefault(); // Ngăn chặn hành vi mặc định của form

    if (cart.length === 0) {
        alert('Giỏ hàng trống. Vui lòng thêm sản phẩm.');
        return;
    }

    const totalPayable = cart.reduce((total, item) => total + (item.price * item.quantity), 0);

    // Lưu tổng tiền hàng vào Local Storage trước khi chuyển hướng
    localStorage.setItem("totalPayable", totalPayable);

    // Chuyển hướng sang trang thanh toán
    window.location.href = `payment.jsp`;
});

        
        // Hiển thị thông báo đang xử lý
        const loadingMessage = document.createElement('div');
        loadingMessage.className = 'loading-message';
        loadingMessage.textContent = 'Đang xử lý thanh toán...';
        document.body.appendChild(loadingMessage);
        
        // Submit form
        this.submit();
    });
}); 
