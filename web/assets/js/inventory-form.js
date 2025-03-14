// Khởi tạo danh sách sản phẩm
const products = window.products || [];

// Thêm sự kiện click cho các sản phẩm trong danh sách
document.addEventListener('DOMContentLoaded', function() {
  const searchResults = document.getElementById('searchResults');
  const searchItems = searchResults.querySelectorAll('.product-search-item');
  
  searchItems.forEach(item => {
    item.addEventListener('click', function() {
      const product = {
        id: parseInt(this.dataset.id),
        code: this.dataset.code,
        name: this.dataset.name,
        price: parseInt(this.dataset.price)
      };
      addProduct(product);
      searchResults.style.display = 'none';
      document.getElementById('productSearch').value = '';
    });
  });
});

// Tìm kiếm sản phẩm
document.getElementById('productSearch').addEventListener('input', function() {
  const searchTerm = this.value.toLowerCase();
  const resultsContainer = document.getElementById('searchResults');
  const searchItems = resultsContainer.querySelectorAll('.product-search-item');
  
  if (searchTerm.length < 2) {
    resultsContainer.style.display = 'none';
    return;
  }
  
  let hasVisibleItems = false;
  searchItems.forEach(item => {
    const code = item.dataset.code.toLowerCase();
    const name = item.dataset.name.toLowerCase();
    if (code.includes(searchTerm) || name.includes(searchTerm)) {
      item.style.display = 'block';
      hasVisibleItems = true;
    } else {
      item.style.display = 'none';
    }
  });
  
  resultsContainer.style.display = hasVisibleItems ? 'block' : 'none';
});

document.getElementById('searchButton').addEventListener('click', function() {
  const searchTerm = document.getElementById('productSearch').value;
  if (searchTerm.length > 0) {
    const resultsContainer = document.getElementById('searchResults');
    resultsContainer.style.display = resultsContainer.style.display === 'none' ? 'block' : 'none';
  }
});

// Thêm sản phẩm vào bảng
function addProduct(product) {
  const tableBody = document.getElementById('productTableBody');
  const emptyRow = document.getElementById('emptyRow');
  
  if (emptyRow) {
    tableBody.removeChild(emptyRow);
  }
  
  // Kiểm tra sản phẩm đã tồn tại trong bảng chưa
  const existingRows = tableBody.querySelectorAll('tr');
  for (let i = 0; i < existingRows.length; i++) {
    const productIdInput = existingRows[i].querySelector('input[name="productId"]');
    if (productIdInput && parseInt(productIdInput.value) === product.id) {
      alert('Sản phẩm này đã được thêm vào phiếu nhập!');
      return;
    }
  }
  
  const today = new Date();
  const nextYear = new Date(today);
  nextYear.setFullYear(today.getFullYear() + 1);
  
  const row = document.createElement('tr');
  row.innerHTML = `
    <td>${tableBody.children.length + 1}</td>
    <td>
      ${product.code}
      <input type="hidden" name="productId" value="${product.id}">
    </td>
    <td>${product.name}</td>
    <td>
      <input type="text" class="form-control" name="batchNumber" required>
    </td>
    <td>
      <input type="date" class="form-control" name="expirationDate" 
             value="${nextYear.toISOString().split('T')[0]}" required>
    </td>
    <td>
      <input type="number" class="form-control quantity-input" name="quantity" 
             value="1" min="1" required onchange="calculateTotal(this)">
    </td>
    <td>
      <input type="number" class="form-control price-input" name="unitCost" 
             value="${product.price}" min="0" required onchange="calculateTotal(this)">
    </td>
    <td class="item-total">${product.price}</td>
    <td>
      <button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">
        <i class="bi bi-trash"></i>
      </button>
    </td>
  `;
  
  tableBody.appendChild(row);
  updateRowNumbers();
  updateSummary();
}

// Xóa hàng
function removeRow(button) {
  const row = button.closest('tr');
  const tableBody = document.getElementById('productTableBody');
  
  tableBody.removeChild(row);
  
  if (tableBody.children.length === 0) {
    const emptyRow = document.createElement('tr');
    emptyRow.id = 'emptyRow';
    emptyRow.innerHTML = '<td colspan="9" class="text-center">Chưa có sản phẩm nào được thêm</td>';
    tableBody.appendChild(emptyRow);
  }
  
  updateRowNumbers();
  updateSummary();
}

// Cập nhật số thứ tự
function updateRowNumbers() {
  const rows = document.getElementById('productTableBody').querySelectorAll('tr:not(#emptyRow)');
  rows.forEach((row, index) => {
    row.cells[0].textContent = index + 1;
  });
}

// Tính tổng tiền của một hàng
function calculateTotal(input) {
  const row = input.closest('tr');
  const quantity = parseInt(row.querySelector('.quantity-input').value) || 0;
  const price = parseInt(row.querySelector('.price-input').value) || 0;
  const total = quantity * price;
  
  row.querySelector('.item-total').textContent = total.toLocaleString('vi-VN');
  
  updateSummary();
}

// Cập nhật tổng kết
function updateSummary() {
  const rows = document.getElementById('productTableBody').querySelectorAll('tr:not(#emptyRow)');
  let totalProducts = rows.length;
  let totalQuantity = 0;
  let totalCost = 0;
  
  rows.forEach(row => {
    const quantity = parseInt(row.querySelector('.quantity-input').value) || 0;
    const price = parseInt(row.querySelector('.price-input').value) || 0;
    
    totalQuantity += quantity;
    totalCost += quantity * price;
  });
  
  document.getElementById('totalProducts').textContent = totalProducts;
  document.getElementById('totalQuantity').textContent = totalQuantity;
  document.getElementById('totalCost').textContent = totalCost.toLocaleString('vi-VN');
  document.getElementById('totalCostInput').value = totalCost;
}

// Kiểm tra form trước khi submit
document.getElementById('receiptForm').addEventListener('submit', function(e) {
  const tableBody = document.getElementById('productTableBody');
  const emptyRow = document.getElementById('emptyRow');
  
  if (emptyRow || tableBody.children.length === 0) {
    e.preventDefault();
    alert('Vui lòng thêm ít nhất một sản phẩm vào phiếu nhập!');
  }
});

// Khởi tạo
document.addEventListener('DOMContentLoaded', function() {
  // Ẩn kết quả tìm kiếm khi click ra ngoài
  document.addEventListener('click', function(e) {
    if (!e.target.closest('.product-search-container')) {
      document.getElementById('searchResults').style.display = 'none';
    }
  });
  
  // Cập nhật tổng kết khi trang được tải
  updateSummary();
}); 