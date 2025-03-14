<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${empty goodReceipt ? 'Thêm mới' : 'Chỉnh sửa'} phiếu nhập hàng - SLIM</title>
    
    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon" />
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon" />

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
      rel="stylesheet"
    />

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet" />
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet" />
    
    <style>
      .form-card {
        margin-bottom: 20px;
      }
      
      .form-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
      }
      
      .form-title {
        font-size: 1.2rem;
        font-weight: bold;
      }
      
      .form-actions {
        display: flex;
        gap: 10px;
      }
      
      .product-table th {
        background-color: #f8f9fa;
      }
      
      .summary-section {
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #dee2e6;
      }
      
      .summary-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
      }
      
      .summary-label {
        font-weight: bold;
      }
      
      .summary-value {
        font-weight: bold;
      }
      
      .summary-total {
        font-size: 1.2rem;
        color: #198754;
      }
      
      .product-search-container {
        position: relative;
        margin-bottom: 20px;
      }
      
      .product-search-results {
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background-color: white;
        border: 1px solid #ddd;
        border-radius: 0 0 4px 4px;
        max-height: 300px;
        overflow-y: auto;
        z-index: 1000;
        display: none;
      }
      
      .product-search-item {
        padding: 10px;
        border-bottom: 1px solid #eee;
        cursor: pointer;
      }
      
      .product-search-item:hover {
        background-color: #f5f5f5;
      }
      
      .required-field::after {
        content: " *";
        color: red;
      }
    </style>
  </head>
  <body>
    <!-- ======= Header ======= -->
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>${empty goodReceipt ? 'Thêm mới' : 'Chỉnh sửa'} phiếu nhập hàng</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item"><a href="inventory">Phiếu nhập hàng</a></li>
            <li class="breadcrumb-item active">${empty goodReceipt ? 'Thêm mới' : 'Chỉnh sửa'}</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="row">
          <div class="col-lg-12">
            <form action="inventory" method="post" id="receiptForm">
              <input type="hidden" name="action" value="save">
              <c:if test="${not empty goodReceipt}">
                <input type="hidden" name="id" value="${goodReceipt.goodReceiptID}">
              </c:if>
              
              <!-- Thông tin phiếu nhập -->
              <div class="card form-card">
                <div class="card-body">
                  <div class="form-header">
                    <div class="form-title">
                      ${empty goodReceipt ? 'Thêm mới' : 'Chỉnh sửa'} phiếu nhập hàng
                    </div>
                    <div class="form-actions">
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save"></i> Lưu
                      </button>
                      <a href="inventory" class="btn btn-secondary">
                        <i class="bi bi-x-circle"></i> Hủy
                      </a>
                    </div>
                  </div>
                  
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="mb-3">
                        <label for="supplierId" class="form-label required-field">Nhà cung cấp</label>
                        <select class="form-select" id="supplierId" name="supplierId" required>
                          <option value="">-- Chọn nhà cung cấp --</option>
                          <c:forEach var="supplier" items="${suppliers}">
                            <option value="${supplier.id}" ${goodReceipt.supplier.id == supplier.id ? 'selected' : ''}>${supplier.supplierName}</option>
                          </c:forEach>
                        </select>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="mb-3">
                        <label for="receivedDate" class="form-label required-field">Ngày nhập</label>
                        <input type="date" class="form-control" id="receivedDate" name="receivedDate" 
                               value="<fmt:formatDate value='${goodReceipt.receivedDate}' pattern='yyyy-MM-dd' />" 
                               required>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Danh sách sản phẩm -->
                  <div class="mt-4">
                    <h5>Danh sách sản phẩm</h5>
                    
                    <div class="product-search-container">
                      <div class="input-group mb-3">
                        <input type="text" class="form-control" id="productSearch" placeholder="Tìm kiếm sản phẩm...">
                        <button class="btn btn-primary" type="button" id="searchButton">
                          <i class="bi bi-search"></i> Tìm kiếm
                        </button>
                      </div>
                      <div class="product-search-results" id="searchResults">
                        <c:forEach var="product" items="${products}">
                          <div class="product-search-item" 
                               data-id="${product.productID}"
                               data-code="${product.productCode}"
                               data-name="${product.productName}"
                               data-price="${product.unitPrice}">
                            <strong>${product.productCode}</strong> - ${product.productName}
                          </div>
                        </c:forEach>
                      </div>
                    </div>
                    
                    <div class="table-responsive">
                      <table class="table table-bordered product-table" id="productTable">
                        <thead>
                          <tr>
                            <th width="50">STT</th>
                            <th>Mã sản phẩm</th>
                            <th>Tên sản phẩm</th>
                            <th>Số lô</th>
                            <th>Hạn sử dụng</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                            <th width="50">Xóa</th>
                          </tr>
                        </thead>
                        <tbody id="productTableBody">
                          <c:if test="${not empty goodReceiptDetails}">
                            <c:forEach var="detail" items="${goodReceiptDetails}" varStatus="status">
                              <tr>
                                <td>${status.index + 1}</td>
                                <td>
                                  ${detail.product.productCode}
                                  <input type="hidden" name="productId" value="${detail.product.productID}">
                                  <input type="hidden" name="detailId" value="${detail.goodReceiptDetailID}">
                                </td>
                                <td>${detail.product.productName}</td>
                                <td>
                                  <input type="text" class="form-control" name="batchNumber" value="${detail.batchNumber}" required>
                                </td>
                                <td>
                                  <input type="date" class="form-control" name="expirationDate" 
                                         value="<fmt:formatDate value='${detail.expirationDate}' pattern='yyyy-MM-dd' />" required>
                                </td>
                                <td>
                                  <input type="number" class="form-control quantity-input" name="quantity" 
                                         value="${detail.quantityReceived}" min="1" required onchange="calculateTotal(this)">
                                </td>
                                <td>
                                  <input type="number" class="form-control price-input" name="unitCost" 
                                         value="${detail.unitCost}" min="0" required onchange="calculateTotal(this)">
                                </td>
                                <td class="item-total">
                                  <fmt:formatNumber value="${detail.quantityReceived * detail.unitCost}" type="number" groupingUsed="true" />
                                </td>
                                <td>
                                  <button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">
                                    <i class="bi bi-trash"></i>
                                  </button>
                                </td>
                              </tr>
                            </c:forEach>
                          </c:if>
                          <c:if test="${empty goodReceiptDetails}">
                            <tr id="emptyRow">
                              <td colspan="9" class="text-center">Chưa có sản phẩm nào được thêm</td>
                            </tr>
                          </c:if>
                        </tbody>
                      </table>
                    </div>
                    
                    <!-- Tổng kết -->
                    <div class="summary-section">
                      <div class="row">
                        <div class="col-md-6">
                          <div class="summary-row">
                            <div class="summary-label">Tổng số sản phẩm:</div>
                            <div class="summary-value" id="totalProducts">
                              <c:choose>
                                <c:when test="${not empty goodReceiptDetails}">${goodReceiptDetails.size()}</c:when>
                                <c:otherwise>0</c:otherwise>
                              </c:choose>
                            </div>
                          </div>
                          <div class="summary-row">
                            <div class="summary-label">Tổng số lượng:</div>
                            <div class="summary-value" id="totalQuantity">
                              <c:choose>
                                <c:when test="${not empty goodReceiptDetails}">
                                  <c:set var="totalQuantity" value="0" />
                                  <c:forEach var="detail" items="${goodReceiptDetails}">
                                    <c:set var="totalQuantity" value="${totalQuantity + detail.quantityReceived}" />
                                  </c:forEach>
                                  ${totalQuantity}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                              </c:choose>
                            </div>
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="summary-row">
                            <div class="summary-label summary-total">Tổng cộng:</div>
                            <div class="summary-value summary-total" id="totalCost">
                              <c:choose>
                                <c:when test="${not empty goodReceipt}">
                                  <fmt:formatNumber value="${goodReceipt.totalCost}" type="number" groupingUsed="true" />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                              </c:choose>
                            </div>
                            <input type="hidden" name="totalCost" id="totalCostInput" 
                                   value="${not empty goodReceipt ? goodReceipt.totalCost : 0}">
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </section>
    </main>

    <!-- Vendor JS Files -->
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>
    
    <!-- Khởi tạo danh sách sản phẩm -->
    <script>
      // Khởi tạo danh sách sản phẩm
      var products = [];
      <c:forEach var="product" items="${products}" varStatus="status">
        products.push({
          id: ${product.productID},
          code: "${product.productCode}",
          name: "${product.productName}",
          price: ${product.unitPrice}
        });
      </c:forEach>

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
        row.innerHTML = 
    "<td>" + (tableBody.children.length + 1) + "</td>" +
    "<td>" +
      product.code +
      "<input type='hidden' name='productId' value='" + product.id + "'>" +
    "</td>" +
    "<td>" + product.name + "</td>" +
    "<td>" +
      "<input type='text' class='form-control' name='batchNumber' required>" +
    "</td>" +
    "<td>" +
      "<input type='date' class='form-control' name='expirationDate' value='" + nextYear.toISOString().split('T')[0] + "' required>" +
    "</td>" +
    "<td>" +
      "<input type='number' class='form-control quantity-input' name='quantity' " +
             "value='1' min='1' required onchange='calculateTotal(this)'>" +
    "</td>" +
    "<td>" +
      "<input type='number' class='form-control price-input' name='unitCost' " +
             "value='" + product.price + "' min='0' required onchange='calculateTotal(this)'>" +
    "</td>" +
    "<td class='item-total'>" + product.price + "</td>" +
    "<td>" +
      "<button type='button' class='btn btn-danger btn-sm' onclick='removeRow(this)'>" +
        "<i class='bi bi-trash'></i>" +
      "</button>" +
    "</td>";
        
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
    </script>
  </body>
</html> 