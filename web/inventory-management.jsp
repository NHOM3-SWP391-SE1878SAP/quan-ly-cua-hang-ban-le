<%-- Document : inventory-management Created on : Mar 13, 2025, 4:28:04 PM
Author : tuanngp --%> <%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phiếu nhập hàng</title>
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
    <div class="container">
      <!-- Header -->
      <div class="header">
        <div class="title">Phiếu nhập hàng</div>
        <div class="search-bar">
          <input
            type="text"
            class="search-input"
            placeholder="Theo mã phiếu nhập"
          />
          <span class="dropdown-icon">▼</span>
        </div>
        <div class="action-buttons">
          <button class="btn btn-primary">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              viewBox="0 0 16 16"
            >
              <path
                d="M8 0a1 1 0 0 1 1 1v6h6a1 1 0 1 1 0 2H9v6a1 1 0 1 1-2 0V9H1a1 1 0 0 1 0-2h6V1a1 1 0 0 1 1-1z"
              />
            </svg>
            Nhập hàng
          </button>
          <button class="btn btn-primary">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              viewBox="0 0 16 16"
            >
              <path
                d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"
              />
              <path
                d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"
              />
            </svg>
            Xuất file ▼
          </button>
          <button class="btn btn-primary">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              fill="currentColor"
              viewBox="0 0 16 16"
            >
              <path
                d="M1 2.5A1.5 1.5 0 0 1 2.5 1h3A1.5 1.5 0 0 1 7 2.5v3A1.5 1.5 0 0 1 5.5 7h-3A1.5 1.5 0 0 1 1 5.5v-3zm8 0A1.5 1.5 0 0 1 10.5 1h3A1.5 1.5 0 0 1 15 2.5v3A1.5 1.5 0 0 1 13.5 7h-3A1.5 1.5 0 0 1 9 5.5v-3zm-8 8A1.5 1.5 0 0 1 2.5 9h3A1.5 1.5 0 0 1 7 10.5v3A1.5 1.5 0 0 1 5.5 15h-3A1.5 1.5 0 0 1 1 13.5v-3zm8 0A1.5 1.5 0 0 1 10.5 9h3a1.5 1.5 0 0 1 1.5 1.5v3a1.5 1.5 0 0 1-1.5 1.5h-3A1.5 1.5 0 0 1 9 13.5v-3z"
              />
            </svg>
            ▼
          </button>
        </div>
      </div>

      <!-- Main Content -->
      <div class="main-content">
        <!-- Sidebar -->
        <div class="sidebar-container">
          <!-- Time Filter -->
          <div class="sidebar">
            <div class="sidebar-title">
              Thời gian
              <span class="dropdown-icon">▼</span>
            </div>
            <div class="sidebar-content">
              <label class="radio-container"
                >Tháng này
                <input type="radio" name="time-filter" checked />
                <span class="radiomark"></span>
              </label>
              <label class="radio-container"
                >Lựa chọn khác
                <input type="radio" name="time-filter" />
                <span class="radiomark"></span>
              </label>
            </div>
          </div>

          <!-- Status Filter -->
          <div class="sidebar">
            <div class="sidebar-title">
              Trạng thái
              <span class="dropdown-icon">▼</span>
            </div>
            <div class="sidebar-content">
              <label class="checkbox-container"
                >Phiếu tạm
                <input type="checkbox" checked />
                <span class="checkmark"></span>
              </label>
              <label class="checkbox-container"
                >Đã nhập hàng
                <input type="checkbox" checked />
                <span class="checkmark"></span>
              </label>
              <label class="checkbox-container"
                >Đã hủy
                <input type="checkbox" />
                <span class="checkmark"></span>
              </label>
            </div>
          </div>

          <!-- Creator Filter -->
          <div class="sidebar">
            <div class="sidebar-title">
              Người tạo
              <span class="dropdown-icon">▼</span>
            </div>
            <div class="sidebar-content">
              <input
                type="text"
                class="input-control"
                placeholder="Chọn người tạo"
              />
            </div>
          </div>

          <!-- Input Person Filter -->
          <div class="sidebar">
            <div class="sidebar-title">
              Người nhập
              <span class="dropdown-icon">▼</span>
            </div>
            <div class="sidebar-content">
              <input
                type="text"
                class="input-control"
                placeholder="Chọn người nhập"
              />
            </div>
          </div>
        </div>

        <!-- Content Area -->
        <div class="content-area">
          <div class="table-container">
            <table class="data-table">
              <thead>
                <tr>
                  <th width="30">
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </th>
                  <th width="30">⭐</th>
                  <th>Mã nhập hàng</th>
                  <th>Thời gian</th>
                  <th>Nhà cung cấp</th>
                  <th>Cân trả NCC</th>
                  <th>Trạng thái</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000046</td>
                  <td>11/03/2025 21:40</td>
                  <td>Cửa hàng Đại Việt</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000045</td>
                  <td>10/03/2025 21:39</td>
                  <td>Công ty Pharmedic</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000044</td>
                  <td>09/03/2025 21:38</td>
                  <td>Đại lý Hồng Phúc</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000043</td>
                  <td>08/03/2025 21:37</td>
                  <td>Công ty TNHH Citigo</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000042</td>
                  <td>07/03/2025 21:37</td>
                  <td>Công ty Pharmedic</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000041</td>
                  <td>06/03/2025 21:36</td>
                  <td>Đại lý Hồng Phúc</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000040</td>
                  <td>05/03/2025 21:36</td>
                  <td>Công ty TNHH Citigo</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000039</td>
                  <td>04/03/2025 21:34</td>
                  <td>Cửa hàng Đại Việt</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
                <tr>
                  <td>
                    <label class="checkbox-container" style="margin-bottom: 0">
                      <input type="checkbox" />
                      <span class="checkmark"></span>
                    </label>
                  </td>
                  <td>⭐</td>
                  <td>PN000038</td>
                  <td>03/03/2025 21:32</td>
                  <td>Công ty Hoàng Gia</td>
                  <td>0</td>
                  <td>Đã nhập hàng</td>
                </tr>
              </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination">
              <div class="pagination-controls">
                <button class="page-btn">◀◀</button>
                <button class="page-btn">◀</button>
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">▶</button>
                <button class="page-btn">▶▶</button>
              </div>
              <div>Hiển thị 1 - 10 / Tổng số 11 phiếu nhập hàng</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Order Details View -->
    <div id="orderModal" class="modal">
      <div class="modal-content">
        <div class="table-container" style="margin-bottom: 0">
          <table class="data-table">
            <thead>
              <tr>
                <th width="30">
                  <label class="checkbox-container" style="margin-bottom: 0">
                    <input type="checkbox" />
                    <span class="checkmark"></span>
                  </label>
                </th>
                <th width="30">⭐</th>
                <th>Mã nhập hàng</th>
                <th>Thời gian</th>
                <th>Nhà cung cấp</th>
                <th>Cân trả NCC</th>
                <th>Trạng thái</th>
              </tr>
            </thead>
            <tbody>
              <tr class="selected">
                <td>
                  <label class="checkbox-container" style="margin-bottom: 0">
                    <input type="checkbox" />
                    <span class="checkmark"></span>
                  </label>
                </td>
                <td>⭐</td>
                <td>PN000046</td>
                <td>11/03/2025 21:40</td>
                <td>Cửa hàng Đại Việt</td>
                <td>0</td>
                <td>Đã nhập hàng</td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="tab-container">
          <div class="tab active" data-tab="info">Thông tin</div>
          <div class="tab" data-tab="history">Lịch sử thanh toán</div>
        </div>

        <div class="tab-content active" id="info-tab">
          <div class="form-row">
            <div class="form-col">
              <div class="form-group">
                <label class="form-label">Mã nhập hàng:</label>
                <div>PN000046</div>
              </div>
              <div class="form-group">
                <label class="form-label">Thời gian:</label>
                <div>11/03/2025 21:40</div>
              </div>
              <div class="form-group">
                <label class="form-label">Nhà cung cấp:</label>
                <div>Cửa hàng Đại Việt</div>
              </div>
              <div class="form-group">
                <label class="form-label">Người tạo:</label>
                <div>Hoàng - Kinh Doanh</div>
              </div>
            </div>
            <div class="form-col">
              <div class="form-group">
                <label class="form-label">Trạng thái:</label>
                <div>Đã nhập hàng</div>
              </div>
              <div class="form-group">
                <label class="form-label">Chi nhánh:</label>
                <div>Chi nhánh trung tâm</div>
              </div>
              <div class="form-group">
                <label class="form-label">Người nhập:</label>
                <div>Hoàng - Kinh Doanh</div>
              </div>
            </div>
          </div>

          <table class="detail-table">
            <thead>
              <tr>
                <th>Mã hàng</th>
                <th>Tên hàng</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Giảm giá</th>
                <th>Giá nhập</th>
                <th>Thành tiền</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>SP000005</td>
                <td>Vinataba Slims</td>
                <td>16</td>
                <td>9,500</td>
                <td></td>
                <td>9,500</td>
                <td>152,000</td>
              </tr>
              <tr>
                <td>SP000004</td>
                <td>Thuốc Maat đỏ</td>
                <td>13</td>
                <td>20,000</td>
                <td></td>
                <td>20,000</td>
                <td>260,000</td>
              </tr>
            </tbody>
          </table>

          <div style="margin-top: 20px">
            <div class="summary-row">
              <div>Tổng số lượng:</div>
              <div>29</div>
            </div>
            <div class="summary-row">
              <div>Tổng số mặt hàng:</div>
              <div>2</div>
            </div>
            <div class="summary-row">
              <div>Tổng tiền hàng:</div>
              <div>412,000</div>
            </div>
            <div class="summary-row">
              <div>Giảm giá:</div>
              <div>0</div>
            </div>
            <div class="summary-row">
              <div>Tổng cộng:</div>
              <div>0</div>
            </div>
            <div class="summary-row">
              <div>Tiền đã trả NCC:</div>
              <div>371,000</div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-primary">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                viewBox="0 0 16 16"
              >
                <path
                  d="M5 1a2 2 0 0 0-2 2v1h10V3a2 2 0 0 0-2-2H5zm6 8H5a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1v-3a1 1 0 0 0-1-1z"
                />
              </svg>
              In phiếu
            </button>
            <button class="btn btn-secondary" id="closeModal">Đóng</button>
          </div>
        </div>

        <div class="tab-content" id="history-tab">
          <div style="padding: 15px">
            <div class="form-group">
              <label class="form-label">Lịch sử giao dịch</label>
            </div>

            <table class="detail-table">
              <thead>
                <tr>
                  <th>Thời gian</th>
                  <th>Hình thức</th>
                  <th>Số tiền</th>
                  <th>Người thanh toán</th>
                  <th>Ghi chú</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>11/03/2025 21:40</td>
                  <td>Tiền mặt</td>
                  <td>371,000</td>
                  <td>Hoàng - Kinh Doanh</td>
                  <td>Thanh toán ngay khi nhập hàng</td>
                </tr>
              </tbody>
            </table>

            <div class="summary-row" style="margin-top: 20px">
              <div>Tổng tiền đã thanh toán:</div>
              <div>371,000</div>
            </div>
            <div class="summary-row">
              <div>Còn nợ:</div>
              <div>41,000</div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-primary">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                viewBox="0 0 16 16"
              >
                <path
                  d="M12 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2zM5 4h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1zm0 2h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1zm0 2h6a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1zm0 2h3a.5.5 0 0 1 0 1H5a.5.5 0 0 1 0-1z"
                />
              </svg>
              Thanh toán
            </button>
            <button class="btn btn-secondary" id="closeHistoryModal">
              Đóng
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Import Modal -->
    <div id="importModal" class="modal">
      <div class="modal-content" style="max-width: 800px">
        <div style="padding: 15px; border-bottom: 1px solid #ddd">
          <h3 style="margin: 0">Nhập hàng</h3>
        </div>

        <div style="padding: 15px">
          <div class="form-row">
            <div class="form-col">
              <div class="form-group">
                <label class="form-label">Nhà cung cấp:</label>
                <input
                  type="text"
                  class="input-control"
                  placeholder="Chọn nhà cung cấp"
                />
              </div>
              <div class="form-group">
                <label class="form-label">Chi nhánh:</label>
                <input
                  type="text"
                  class="input-control"
                  value="Chi nhánh trung tâm"
                  readonly
                />
              </div>
            </div>
            <div class="form-col">
              <div class="form-group">
                <label class="form-label">Ngày nhập:</label>
                <input type="date" class="input-control" value="2025-03-13" />
              </div>
              <div class="form-group">
                <label class="form-label">Ghi chú:</label>
                <textarea
                  class="input-control"
                  placeholder="Nhập ghi chú"
                ></textarea>
              </div>
            </div>
          </div>

          <div style="margin-bottom: 15px">
            <label class="form-label">Danh sách sản phẩm:</label>
            <div style="display: flex; gap: 10px; margin-bottom: 10px">
              <input
                type="text"
                class="input-control"
                placeholder="Tìm kiếm sản phẩm..."
                style="flex-grow: 1"
              />
              <button class="btn btn-primary">Thêm</button>
            </div>

            <table class="detail-table">
              <thead>
                <tr>
                  <th width="40">STT</th>
                  <th>Mã hàng</th>
                  <th>Tên hàng</th>
                  <th>Số lượng</th>
                  <th>Đơn giá</th>
                  <th>Giảm giá</th>
                  <th>Thành tiền</th>
                  <th width="40"></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>1</td>
                  <td>SP000001</td>
                  <td>Nước giải khát Coca Cola</td>
                  <td>
                    <input type="number" value="10" style="width: 60px" />
                  </td>
                  <td>
                    <input type="text" value="12,000" style="width: 80px" />
                  </td>
                  <td><input type="text" value="0" style="width: 60px" /></td>
                  <td>120,000</td>
                  <td>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      fill="red"
                      viewBox="0 0 16 16"
                      style="cursor: pointer"
                    >
                      <path
                        d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"
                      />
                      <path
                        fill-rule="evenodd"
                        d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"
                      />
                    </svg>
                  </td>
                </tr>
                <tr>
                  <td>2</td>
                  <td>SP000002</td>
                  <td>Bánh quy Oreo</td>
                  <td>
                    <input type="number" value="15" style="width: 60px" />
                  </td>
                  <td>
                    <input type="text" value="15,500" style="width: 80px" />
                  </td>
                  <td><input type="text" value="0" style="width: 60px" /></td>
                  <td>232,500</td>
                  <td>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      width="16"
                      height="16"
                      fill="red"
                      viewBox="0 0 16 16"
                      style="cursor: pointer"
                    >
                      <path
                        d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"
                      />
                      <path
                        fill-rule="evenodd"
                        d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"
                      />
                    </svg>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div style="margin-top: 20px">
            <div class="summary-row">
              <div>Tổng số lượng:</div>
              <div>25</div>
            </div>
            <div class="summary-row">
              <div>Tổng tiền hàng:</div>
              <div>352,500</div>
            </div>
            <div class="summary-row">
              <div>Giảm giá:</div>
              <div>0</div>
            </div>
            <div class="summary-row">
              <div>Tổng cộng:</div>
              <div>352,500</div>
            </div>
            <div class="form-group" style="margin-top: 15px">
              <label class="form-label">Thanh toán:</label>
              <select class="input-control">
                <option>Tiền mặt</option>
                <option>Chuyển khoản</option>
                <option>Công nợ</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">Số tiền thanh toán:</label>
              <input type="text" class="input-control" value="352,500" />
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-primary">Nhập hàng</button>
          <button class="btn btn-secondary" id="closeImportModal">Đóng</button>
        </div>
      </div>
    </div>

    <!-- Helper Text -->
    <div class="helper-text">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="16"
        height="16"
        fill="currentColor"
        viewBox="0 0 16 16"
      >
        <path
          d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"
        />
        <path
          d="M5.255 5.786a.237.237 0 0 0 .241.247h.825c.138 0 .248-.113.266-.25.09-.656.54-1.134 1.342-1.134.686 0 1.314.343 1.314 1.168 0 .635-.374.927-.965 1.371-.673.489-1.206 1.06-1.168 1.987l.003.217a.25.25 0 0 0 .25.246h.811a.25.25 0 0 0 .25-.25v-.105c0-.718.273-.927 1.01-1.486.609-.463 1.244-.977 1.244-2.056 0-1.511-1.276-2.241-2.673-2.241-1.267 0-2.655.59-2.75 2.286zm1.557 5.763c0 .533.425.927 1.01.927.609 0 1.028-.394 1.028-.927 0-.552-.42-.94-1.029-.94-.584 0-1.009.388-1.009.94z"
        />
      </svg>
      Trợ giúp
    </div>

    <!-- JavaScript -->
    <script>
      // Get modal elements
      const orderModal = document.getElementById("orderModal");
      const importModal = document.getElementById("importModal");

      // Get buttons
      const closeModalBtn = document.getElementById("closeModal");
      const closeHistoryModalBtn = document.getElementById("closeHistoryModal");
      const closeImportModalBtn = document.getElementById("closeImportModal");
      const importBtn = document.querySelector(".btn.btn-primary");

      // Get tabs
      const tabs = document.querySelectorAll(".tab");
      const tabContents = document.querySelectorAll(".tab-content");

      // Get table rows
      const tableRows = document.querySelectorAll(".data-table tbody tr");

      // Open order modal when clicking on table row
      tableRows.forEach((row) => {
        row.addEventListener("click", () => {
          orderModal.style.display = "block";
        });
      });

      // Close modals
      closeModalBtn.addEventListener("click", () => {
        orderModal.style.display = "none";
      });

      closeHistoryModalBtn.addEventListener("click", () => {
        orderModal.style.display = "none";
      });

      closeImportModalBtn.addEventListener("click", () => {
        importModal.style.display = "none";
      });

      // Tab switching
      tabs.forEach((tab) => {
        tab.addEventListener("click", () => {
          // Remove active class from all tabs
          tabs.forEach((t) => t.classList.remove("active"));
          // Add active class to clicked tab
          tab.classList.add("active");

          // Hide all tab contents
          tabContents.forEach((content) => content.classList.remove("active"));
          // Show content related to clicked tab
          document
            .getElementById(`${tab.dataset.tab}-tab`)
            .classList.add("active");
        });
      });

      // Open import modal when clicking import button
      importBtn.addEventListener("click", () => {
        importModal.style.display = "block";
      });

      // Close modal when clicking outside of it
      window.addEventListener("click", (event) => {
        if (event.target === orderModal) {
          orderModal.style.display = "none";
        }
        if (event.target === importModal) {
          importModal.style.display = "none";
        }
      });

      // Star functionality
      const stars = document.querySelectorAll(".star-icon");
      stars.forEach((star) => {
        star.addEventListener("click", (event) => {
          event.stopPropagation();
          star.classList.toggle("active");
          if (star.classList.contains("active")) {
            star.style.color = "#FFD700";
          } else {
            star.style.color = "#ddd";
          }
        });
      });
    </script>
  </body>
</html>
