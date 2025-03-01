<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử nhập/trả hàng</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }
        
        body {
            background-color: #f0f0f0;
        }
        
        .container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 10px;
            padding-bottom: 20px;
        }
        
        .sidebar-header {
            padding: 15px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }
        
        .sidebar-header-title {
            font-size: 14px;
        }
        
        .add-icon {
            width: 20px;
            height: 20px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            border: 1px solid #ddd;
        }
        
        .sidebar-item {
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }
        
        .sidebar-item-left {
            display: flex;
            align-items: center;
        }
        
        .sidebar-item-dropdown {
            margin-left: 10px;
            color: #777;
            cursor: pointer;
        }
        
        .sidebar-item-edit {
            color: #777;
            cursor: pointer;
            margin-left: 10px;
        }
        
        .filter-section {
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .filter-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-weight: bold;
            color: #333;
        }
        
        .filter-toggle {
            color: #777;
            cursor: pointer;
        }
        
        .filter-content {
            margin-top: 10px;
        }
        
        .filter-input-group {
            margin-bottom: 10px;
        }
        
        .filter-input-group label {
            display: block;
            margin-bottom: 5px;
            color: #666;
            font-size: 14px;
        }
        
        .filter-input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .filter-radio-group {
            margin-top: 5px;
            display: flex;
            align-items: center;
        }
        
        .filter-radio {
            margin-right: 5px;
        }
        
        .calendar-icon {
            margin-left: auto;
            color: #777;
            cursor: pointer;
        }
        
        .main-content {
            flex: 1;
            margin: 10px;
            display: flex;
            flex-direction: column;
        }
        
        .main-table {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 10px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background-color: #f9f9f9;
            padding: 12px 15px;
            text-align: left;
            font-weight: bold;
            border-bottom: 1px solid #eee;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        .selected-row {
            background-color: #f5fff9;
            border-left: 4px solid #00c853;
        }
        
        .highlight-row {
            border-left: 4px solid transparent;
        }
        
        .tab-container {
            display: flex;
            background-color: white;
            margin-top: -1px;
        }
        
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            font-weight: bold;
            border-bottom: 2px solid transparent;
        }
        
        .tab.active {
            color: #00c853;
            border-bottom: 2px solid #00c853;
        }
        
        .history-table {
            background-color: white;
            border-radius: 0 0 5px 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            flex-grow: 1;
        }
        
        .history-table table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .history-table th {
            background-color: #e8f4ff;
            padding: 12px 15px;
            text-align: left;
            font-weight: bold;
            border-bottom: 1px solid #eee;
        }
        
        .history-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        .history-table tr:hover {
            background-color: #f5f5f5;
        }
        
        .status-cell {
            color: #009688;
        }
        
        .document-link {
            color: #1976d2;
            text-decoration: none;
        }
        
        .text-right {
            text-align: right;
        }
        
        .export-button {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 8px 15px;
            background-color: #546e7a;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-left: auto;
            margin-bottom: 10px;
        }
        
        .notification-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background-color: #fffde7;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-top: 1px solid #eee;
        }
        
        .notification-text {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .notification-link {
            color: #f44336;
            text-decoration: none;
        }
        
        .scroll-top-button {
            position: fixed;
            bottom: 70px;
            right: 20px;
            width: 40px;
            height: 40px;
            background-color: #2196f3;
            color: white;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .support-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 8px 15px;
            background-color: #2196f3;
            color: white;
            border-radius: 30px;
            display: flex;
            align-items: center;
            gap: 5px;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        
        .checkbox {
            width: 18px;
            height: 18px;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-header-title">Nhóm NCC</div>
                <div class="add-icon">
                    <i class="fas fa-plus"></i>
                </div>
            </div>
            
            <div class="sidebar-item">
                <div class="sidebar-item-left">
                    <span>Tất cả các nhóm</span>
                </div>
                <div>
                    <i class="fas fa-chevron-down sidebar-item-dropdown"></i>
                    <i class="fas fa-pencil-alt sidebar-item-edit"></i>
                </div>
            </div>
            
            <div class="filter-section">
                <div class="filter-header">
                    <span>Tổng mua</span>
                    <i class="fas fa-chevron-up filter-toggle"></i>
                </div>
                
                <div class="filter-content">
                    <div class="filter-input-group">
                        <label>Từ</label>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    
                    <div class="filter-input-group">
                        <label>Tới</label>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    
                    <div class="filter-radio-group">
                        <input type="radio" id="all-time" name="time-filter" class="filter-radio" checked>
                        <label for="all-time">Toàn thời gian</label>
                    </div>
                    
                    <div class="filter-radio-group">
                        <input type="radio" id="custom-time" name="time-filter" class="filter-radio">
                        <label for="custom-time">Lựa chọn khác</label>
                        <i class="fas fa-calendar calendar-icon"></i>
                    </div>
                </div>
            </div>
            
            <div class="filter-section">
                <div class="filter-header">
                    <span>Nợ hiện tại</span>
                    <i class="fas fa-chevron-up filter-toggle"></i>
                </div>
                
                <div class="filter-content">
                    <div class="filter-input-group">
                        <label>Từ</label>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                    
                    <div class="filter-input-group">
                        <label>Tới</label>
                        <input type="text" class="filter-input" placeholder="Giá trị">
                    </div>
                </div>
            </div>
            
            <div class="filter-section">
                <div class="filter-header">
                    <span>Trạng thái</span>
                    <i class="fas fa-chevron-up filter-toggle"></i>
                </div>
                
                <div class="filter-content">
                    <div class="filter-radio-group">
                        <input type="radio" id="all-status" name="status-filter" class="filter-radio" checked>
                        <label for="all-status">Tất cả</label>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="main-content">
            <div class="main-table">
                <table>
                    <thead>
                        <tr>
                            <th><input type="checkbox" class="checkbox"></th>
                            <th>Mã nhà cung cấp</th>
                            <th>Tên nhà cung cấp</th>
                            <th>Điện thoại</th>
                            <th>Email</th>
                            <th>Nợ cần trả hiện tại</th>
                            <th>Tổng mua</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="7" class="text-right">0</td>
                        </tr>
                        <tr class="selected-row">
                            <td><input type="checkbox" class="checkbox" checked></td>
                            <td>NCC0002</td>
                            <td>Công ty Hoàng Gia</td>
                            <td></td>
                            <td></td>
                            <td class="text-right">0</td>
                            <td class="text-right">0</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="tab-container">
                <div class="tab" onclick="window.location.href='supplier-infor.jsp?id=${param.id}'">
                    Thông tin
                </div>
                <div class="tab active">
                    Lịch sử nhập/trả hàng
                </div>
                <div class="tab" onclick="window.location.href='supplier-payment.jsp?id=${param.id}'">
                    Nợ cần trả NCC
                </div>
            </div>
            
            <button class="export-button">
                <i class="fas fa-file-export"></i>
                Xuất file
            </button>
            
            <div class="history-table">
                <table>
                    <thead>
                        <tr>
                            <th>Mã phiếu</th>
                            <th>Thời gian</th>
                            <th>Người tạo</th>
                            <th>Tổng cộng</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><a href="#" class="document-link">PN000038</a></td>
                            <td>17/02/2025 10:49</td>
                            <td>Hương - Kế Toán</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                        <tr>
                            <td><a href="#" class="document-link">PN000036</a></td>
                            <td>15/02/2025 10:47</td>
                            <td>Nguyễn Thành Long</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                        <tr>
                            <td><a href="#" class="document-link">PN000035</a></td>
                            <td>14/02/2025 10:46</td>
                            <td>Hương - Kế Toán</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                        <tr>
                            <td><a href="#" class="document-link">PN000016</a></td>
                            <td>26/01/2025 10:30</td>
                            <td>Hương - Kế Toán</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                        <tr>
                            <td><a href="#" class="document-link">PN000014</a></td>
                            <td>24/01/2025 10:27</td>
                            <td>Hương - Kế Toán</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                        <tr>
                            <td><a href="#" class="document-link">PN00006</a></td>
                            <td>16/01/2025 10:22</td>
                            <td>Nguyễn Thành Long</td>
                            <td class="text-right">0</td>
                            <td class="status-cell">Đã nhập hàng</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <div class="notification-bar">
        <div class="notification-text">
            <i class="fas fa-info-circle"></i>
            <span>Bạn đang dùng thử KiotViet bản không giới hạn tính năng.</span>
            <a href="#" class="notification-link">Xem chi tiết</a>
        </div>
    </div>
    
    <div class="scroll-top-button">
        <i class="fas fa-arrow-up"></i>
    </div>
    
    <div class="support-button">
        <i class="fas fa-headset"></i>
        <span>Hỗ trợ: 1900 6522</span>
    </div>
</body>
</html>
