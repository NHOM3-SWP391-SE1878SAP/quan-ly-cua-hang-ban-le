<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phiếu nhập hàng - SLIM</title>

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
    <link
      href="assets/vendor/bootstrap/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet" />

    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
      }
      .container {
        padding: 20px;
      }
      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
      }
      .title {
        font-size: 20px;
        font-weight: bold;
      }
      .search-bar {
        display: flex;
        position: relative;
        width: 500px;
      }
      .search-input {
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        width: 100%;
      }
      .dropdown-icon {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
      }
      .action-buttons {
        display: flex;
        gap: 10px;
      }
      .btn {
        padding: 8px 16px;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 5px;
      }
      .btn-primary {
        background-color: #4caf50;
        color: white;
      }
      .sidebar {
        width: 250px;
        background-color: white;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
        margin-bottom: 15px;
        padding: 15px;
      }
      .sidebar-title {
        font-weight: bold;
        margin-bottom: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      .sidebar-content {
        margin-top: 10px;
      }
      .sidebar-item {
        margin-bottom: 10px;
      }
      .main-content {
        display: flex;
        gap: 20px;
      }
      .content-area {
        flex-grow: 1;
      }
      .table-container {
        background-color: white;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12);
        overflow-x: auto;
      }
      .data-table {
        width: 100%;
        border-collapse: collapse;
      }
      .data-table th,
      .data-table td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #ddd;
      }
      .data-table th {
        background-color: #f2f7ff;
        color: #333;
        font-weight: normal;
      }
      .data-table tr:hover {
        background-color: #f9f9f9;
        cursor: pointer;
      }
      .data-table tr.selected {
        background-color: #e6f7e6;
      }
      .star-icon {
        color: #ddd;
        cursor: pointer;
      }
      .pagination {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 10px 15px;
        background-color: white;
        border-top: 1px solid #eee;
      }
      .pagination-controls {
        display: flex;
        gap: 5px;
      }
      .page-btn {
        padding: 5px 10px;
        border: 1px solid #ddd;
        background-color: white;
        cursor: pointer;
      }
      .page-btn.active {
        background-color: #4caf50;
        color: white;
        border-color: #4caf50;
      }
      .checkbox-container {
        display: inline-block;
        position: relative;
        padding-left: 25px;
        margin-bottom: 12px;
        cursor: pointer;
        user-select: none;
      }
      .checkbox-container input {
        position: absolute;
        opacity: 0;
        cursor: pointer;
        height: 0;
        width: 0;
      }
      .checkmark {
        position: absolute;
        top: 0;
        left: 0;
        height: 18px;
        width: 18px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 3px;
      }
      .checkbox-container input:checked ~ .checkmark {
        background-color: #4caf50;
        border-color: #4caf50;
      }
      .checkmark:after {
        content: "";
        position: absolute;
        display: none;
      }
      .checkbox-container input:checked ~ .checkmark:after {
        display: block;
        left: 6px;
        top: 2px;
        width: 4px;
        height: 10px;
        border: solid white;
        border-width: 0 2px 2px 0;
        transform: rotate(45deg);
      }
      .radio-container {
        display: block;
        position: relative;
        padding-left: 30px;
        margin-bottom: 15px;
        cursor: pointer;
        user-select: none;
      }
      .radio-container input {
        position: absolute;
        opacity: 0;
        cursor: pointer;
      }
      .radiomark {
        position: absolute;
        top: 0;
        left: 0;
        height: 20px;
        width: 20px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 50%;
      }
      .radio-container input:checked ~ .radiomark {
        background-color: #fff;
        border-color: #4caf50;
      }
      .radiomark:after {
        content: "";
        position: absolute;
        display: none;
      }
      .radio-container input:checked ~ .radiomark:after {
        display: block;
        top: 5px;
        left: 5px;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background: #4caf50;
      }
      .input-control {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
      }
      .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 100;
      }
      .modal-content {
        background-color: white;
        margin: 5% auto;
        padding: 0;
        width: 80%;
        max-width: 1000px;
        border-radius: 5px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        position: relative;
      }
      .tab-container {
        display: flex;
        border-bottom: 1px solid #ddd;
      }
      .tab {
        padding: 10px 20px;
        cursor: pointer;
        border-bottom: 2px solid transparent;
      }
      .tab.active {
        border-bottom: 2px solid #4caf50;
      }
      .tab-content {
        display: none;
        padding: 15px;
      }
      .tab-content.active {
        display: block;
      }
      .form-group {
        margin-bottom: 15px;
      }
      .form-label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
      }
      .form-col {
        flex: 1;
      }
      .modal-footer {
        padding: 15px;
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        border-top: 1px solid #ddd;
      }
      .btn-danger {
        background-color: #f44336;
        color: white;
      }
      .btn-secondary {
        background-color: #6c757d;
        color: white;
      }
      .detail-table {
        width: 100%;
        border-collapse: collapse;
      }
      .detail-table th,
      .detail-table td {
        padding: 8px 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
      }
      .detail-table th {
        background-color: #f9f9f9;
      }
      .badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
      }
      .badge-success {
        background-color: #e6f7e6;
        color: #4caf50;
      }
      .input-search {
        border: none;
        border-bottom: 1px solid #ddd;
        padding: 8px 0;
        width: 100%;
      }
      .summary-row {
        display: flex;
        justify-content: space-between;
        margin-top: 10px;
        font-weight: bold;
      }
      .search-icon {
        position: absolute;
        left: 10px;
        top: 50%;
        transform: translateY(-50%);
      }
      .helper-text {
        position: fixed;
        bottom: 20px;
        right: 20px;
        background-color: #2196f3;
        color: white;
        padding: 10px 15px;
        border-radius: 30px;
        display: flex;
        align-items: center;
        gap: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
      }
    </style>
  </head>
  <body>
    <!-- ======= Header ======= -->
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>Phiếu nhập hàng</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item">Quản lý</li>
            <li class="breadcrumb-item active">Phiếu nhập hàng</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="container">
          <!-- Header -->
          <div class="header">
            <div class="title">Phiếu nhập hàng</div>
<!--            <div class="search-bar">
              <form action="inventory" method="get">
                <input
                  type="text"
                  class="search-input"
                  placeholder=""
                  name="search"
                  value="${param.search}"
                />
                <button type="submit" style="display: none"></button>
              </form>
              <span class="dropdown-icon">▼</span>
            </div>-->
            <div class="action-buttons">
              <a href="inventory?action=add" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i>
                Nhập hàng
              </a>
              <div class="dropdown d-inline-block">
                <button
                  class="btn btn-primary dropdown-toggle"
                  type="button"
                  id="exportDropdown"
                  data-bs-toggle="dropdown"
                  aria-expanded="false"
                >
                  <i class="bi bi-download"></i>
                  Xuất file
                </button>
                <ul class="dropdown-menu" aria-labelledby="exportDropdown">
                  <li>
                    <a class="dropdown-item" href="ExportInventoryExcelServlet"
                      >Xuất Excel</a
                    >
                  </li>
                  <li>
                    <a
                      class="dropdown-item"
                      href="DownloadInventoryTemplateServlet"
                      >Tải mẫu nhập hàng</a
                    >
                  </li>
                  <li><hr class="dropdown-divider" /></li>
                  <li>
                    <a
                      class="dropdown-item"
                      href="#"
                      data-bs-toggle="modal"
                      data-bs-target="#importExcelModal"
                      >Nhập hàng từ Excel</a
                    >
                  </li>
                </ul>
              </div>
              <button class="btn btn-primary">
                <i class="bi bi-grid"></i>
                ▼
              </button>
            </div>
          </div>

          <!-- Main Content -->
          <div class="main-content">
            <!-- Content Area -->
            <div class="content-area">
              <div class="table-container">
                <table class="table table-hover datatable">
                  <thead>
                    <tr>
<!--                      <th width="30">
                        <label
                          class="checkbox-container"
                          style="margin-bottom: 0"
                        >
                          <input type="checkbox" id="selectAll" />
                          <span class="checkmark"></span>
                        </label>
                      </th>-->
                      <th>Mã nhập hàng</th>
                      <th>Thời gian</th>
                      <th>Nhà cung cấp</th>
                      <th>Tổng tiền</th>
<!--                      <th>Thao tác</th>-->
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="receipt" items="${goodsReceipts}">
                      <tr
                        onclick="viewReceiptDetails(${receipt.goodReceiptID})"
                      >
<!--                        <td>
                          <label
                            class="checkbox-container"
                            style="margin-bottom: 0"
                          >
                            <input
                              type="checkbox"
                              class="receipt-checkbox"
                              value="${receipt.goodReceiptID}"
                              onclick="event.stopPropagation();"
                            />
                            <span class="checkmark"></span>
                          </label>
                        </td>-->
                        <td>
                          PN${String.format("%06d", receipt.goodReceiptID)}
                        </td>
                        <td>
                          <fmt:formatDate
                            value="${receipt.receivedDate}"
                            pattern="dd/MM/yyyy HH:mm"
                          />
                        </td>
                        <td>${receipt.supplier.supplierName}</td>
                        <td>
                          <fmt:formatNumber
                            value="${receipt.totalCost}"
                            type="number"
                            groupingUsed="true"
                          />
                        </td>
                        <td>
                          <div class="d-flex gap-2">
                            <a
                              href="inventory?action=edit&id=${receipt.goodReceiptID}"
                              class="btn btn-sm btn-primary"
                              onclick="event.stopPropagation();"
                            >
                              <i class="bi bi-pencil"></i>
                            </a>
                            <a
                              href="javascript:void(0);"
                              onclick="confirmDelete(${receipt.goodReceiptID}, event);"
                              class="btn btn-sm btn-danger"
                            >
                              <i class="bi bi-trash"></i>
                            </a>
                          </div>
                        </td>
                      </tr>
                    </c:forEach>

                    <c:if test="${empty goodsReceipts}">
                      <tr>
                        <td colspan="7" class="text-center">
                          Không có phiếu nhập hàng nào
                        </td>
                      </tr>
                    </c:if>
                  </tbody>
                </table>

<!--                 Pagination 
                <div class="pagination">
                  <div class="pagination-controls">
                    <button class="page-btn" onclick="goToPage(1)">◀◀</button>
                    <button
                      class="page-btn"
                      onclick="goToPage(${currentPage > 1 ? currentPage - 1 : 1})"
                    >
                      ◀
                    </button>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                      <button
                        class="page-btn ${currentPage == i ? 'active' : ''}"
                        onclick="goToPage(${i})"
                      >
                        ${i}
                      </button>
                    </c:forEach>

                    <button
                      class="page-btn"
                      onclick="goToPage(${currentPage < totalPages ? currentPage + 1 : totalPages})"
                    >
                      ▶
                    </button>
                    <button class="page-btn" onclick="goToPage(${totalPages})">
                      ▶▶
                    </button>
                  </div>
                  <div>
                    Hiển thị ${(currentPage-1)*10 + 1} -
                    ${Math.min(currentPage*10, totalItems.longValue())} / Tổng
                    số ${totalItems} phiếu nhập hàng
                  </div>
                </div>-->
              </div>
            </div>
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

    <!-- Helper Text -->
    <div class="helper-text">
      <i class="bi bi-question-circle"></i>
      Trợ giúp
    </div>

    <!-- JavaScript -->
    <script>
      document
        .getElementById("exportDropdown")
        .addEventListener("click", function () {
          const menu = this.nextElementSibling;
          menu.style.display =
            menu.style.display === "block" ? "none" : "block";
        });

      // Hide dropdown when clicking outside
      document.addEventListener("click", function (event) {
        if (
          !event.target.matches("#exportDropdown") &&
          !event.target.closest("#exportDropdown")
        ) {
          document.querySelector(".dropdown-menu").style.display = "none";
        }
      });
      // Chọn tất cả checkbox
      document
        .getElementById("selectAll")
        .addEventListener("change", function () {
          const checkboxes = document.querySelectorAll(".receipt-checkbox");
          checkboxes.forEach((checkbox) => {
            checkbox.checked = this.checked;
          });
        });

      // Xem chi tiết phiếu nhập hàng
      function viewReceiptDetails(id) {
window.location.href = "inventory?action=view&id=" + id;      }

      // Xác nhận xóa phiếu nhập hàng
      function confirmDelete(id, event) {
        event.stopPropagation();
        if (confirm("Bạn có chắc chắn muốn xóa phiếu nhập hàng này không?")) {
          window.location.href = "inventory?action=delete&id=" + id;
        }
      }

      // Chuyển trang
      function goToPage(page) {
        const url = new URL(window.location.href);
        url.searchParams.set("page", page);
        window.location.href = url.toString();
      }

      // Đánh dấu yêu thích
      function toggleFavorite(id, event) {
        event.stopPropagation();
        // Gửi yêu cầu AJAX để cập nhật trạng thái yêu thích
        fetch("inventory?action=toggleFavorite&id=" + id)
          .then((response) => response.json())
          .then((data) => {
            if (data.success) {
              const icon = event.target;
              if (data.favorite) {
                icon.classList.remove("bi-star");
                icon.classList.add("bi-star-fill");
                icon.style.color = "#FFD700";
              } else {
                icon.classList.remove("bi-star-fill");
                icon.classList.add("bi-star");
                icon.style.color = "#ddd";
              }
            }
          });
      }
    </script>

    <!-- Modal Import Excel -->
    <div
      class="modal fade"
      id="importExcelModal"
      tabindex="-1"
      aria-labelledby="importExcelModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="importExcelModalLabel">
              Nhập hàng từ Excel
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form
              action="ImportInventoryExcelServlet"
              method="post"
              enctype="multipart/form-data"
            >
              <div class="mb-3">
                <label for="supplierSelect" class="form-label"
                  >Nhà cung cấp</label
                >
                <select
                  class="form-select"
                  id="supplierSelect"
                  name="supplierID"
                  required
                >
                  <option value="">-- Chọn nhà cung cấp --</option>
                  <c:forEach var="supplier" items="${suppliers}">
                    <option value="${supplier.id}">
                      ${supplier.supplierName}
                    </option>
                  </c:forEach>
                </select>
              </div>
              <div class="mb-3">
                <label for="excelFile" class="form-label"
                  >Chọn file Excel</label
                >
                <input
                  class="form-control"
                  type="file"
                  id="excelFile"
                  name="excelFile"
                  accept=".xls,.xlsx"
                  required
                />
                <div class="form-text">
                  Chỉ chấp nhận file Excel (.xls, .xlsx)
                </div>
              </div>
              <div class="mb-3">
                <a
                  href="DownloadInventoryTemplateServlet"
                  class="text-decoration-none"
                >
                  <i class="bi bi-download"></i> Tải mẫu nhập hàng
                </a>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-secondary"
                  data-bs-dismiss="modal"
                >
                  Đóng
                </button>
                <button type="submit" class="btn btn-primary">Nhập hàng</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
