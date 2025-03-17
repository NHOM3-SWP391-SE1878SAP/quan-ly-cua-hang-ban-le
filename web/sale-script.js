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
            
            // Lấy giá trị price từ thuộc tính data-product-price và chuyển đổi thành số
            let productPrice = 0;
            try {
                const priceStr = this.getAttribute('data-product-price');
                if (priceStr && priceStr.trim() !== '') {
                    productPrice = parseInt(priceStr);
                    if (isNaN(productPrice)) productPrice = 0;
                }
            } catch (e) {
                console.error('Error parsing price:', e);
                productPrice = 0;
            }
            
            // Lấy số lượng tồn kho
            let productStock = DEFAULT_MAX_QUANTITY;
            try {
                const stockStr = this.getAttribute('data-product-stockquantity');
                console.log(`Raw stock from attribute: "${stockStr}"`);
                productStock = parseInt(stockStr) || DEFAULT_MAX_QUANTITY;
            } catch (e) {
                console.error('Error parsing stock quantity:', e);
                productStock = DEFAULT_MAX_QUANTITY;
            }
            
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
    checkoutBtn.addEventListener('click', function() {
        if (cart.length === 0) {
            alert('Giỏ hàng trống. Vui lòng thêm sản phẩm vào giỏ hàng.');
            return;
        }
        
        // Lấy form
        const form = document.getElementById('checkoutForm');
        
        // Xóa các input cũ (nếu có)
        const oldInputs = form.querySelectorAll('input[name^="product"]');
        oldInputs.forEach(input => input.remove());
        
        // Debug: Kiểm tra các mục trong giỏ hàng
        console.log("Cart items before sending:", cart.length);
        
        // Thêm input cho từng sản phẩm
        cart.forEach(function(item, index) {
            console.log(`Preparing form data - Product: ${item.name}, Price: ${item.price}, Quantity: ${item.quantity}`);
            
            // Tạo input cho từng thuộc tính của sản phẩm
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'productId_' + index;
            idInput.value = item.id;
            form.appendChild(idInput);
            
            const nameInput = document.createElement('input');
            nameInput.type = 'hidden';
            nameInput.name = 'productName_' + index;
            nameInput.value = item.name;
            form.appendChild(nameInput);
            
            const priceInput = document.createElement('input');
            priceInput.type = 'hidden';
            priceInput.name = 'productPrice_' + index;
            priceInput.value = item.price;
            form.appendChild(priceInput);
            
            const quantityInput = document.createElement('input');
            quantityInput.type = 'hidden';
            quantityInput.name = 'productQuantity_' + index;
            quantityInput.value = item.quantity;
            form.appendChild(quantityInput);
        });
        
        // Thêm input cho số lượng sản phẩm
        const countInput = document.createElement('input');
        countInput.type = 'hidden';
        countInput.name = 'productCount';
        countInput.value = cart.length;
        form.appendChild(countInput);
        
        // Lấy thông tin khách hàng
        const customerName = document.getElementById('customerSearchInput').value || 'Khách lẻ';
        const customerId = window.selectedCustomerId || '';
        
        // Đặt giá trị vào form
        document.getElementById('customerNameInput').value = customerName;
        document.getElementById('customerIdInput').value = customerId;
        
        // Debug: Kiểm tra form trước khi gửi
        const formData = new FormData(form);
        console.log("Form data before sending:");
        for (let pair of formData.entries()) {
            console.log(pair[0] + ': ' + pair[1]);
        }
        
        // Submit form
        form.submit();
    });
});
