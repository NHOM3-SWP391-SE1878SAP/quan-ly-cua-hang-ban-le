<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhà cung cấp</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .header h1 {
            font-size: 24px;
            color: #333;
        }
        
        .search-bar {
            display: flex;
            width: 500px;
            position: relative;
        }
        
        .search-bar input {
            width: 100%;
            padding: 10px 40px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .search-bar i {
            position: absolute;
            left: 15px;
            top: 12px;
            color: #888;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 5px;
            font-weight: bold;
            color: white;
        }
        
        .btn-primary {
            background-color: #00c853;
        }
        
        .btn-secondary {
            background-color: #03a9f4;
        }
        
        .btn-dropdown {
            background-color: #00c853;
        }
        
        .sidebar {
            width: 250px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-right: 20px;
            float: left;
        }
        
        .sidebar-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .sidebar-title {
            font-weight: bold;
            color: #333;
        }
        
        .sidebar-icon {
            color: #888;
            cursor: pointer;
        }
        
        .sidebar-content {
            padding: 15px;
        }
        
        .sidebar-filter {
            margin-bottom: 20px;
        }
        
        .sidebar-filter-title {
            margin-bottom: 10px;
            font-weight: bold;
            color: #333;
            display: flex;
            justify-content: space-between;
        }
        
        .input-group {
            margin-bottom: 10px;
        }
        
        .input-group label {
            display: block;
            margin-bottom: 5px;
            color: #666;
        }
        
        .input-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .radio-group {
            margin-bottom: 10px;
        }
        
        .content {
            margin-left: 270px;
        }
        
        .main-table {
            width: 100%;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background-color: #f9f9f9;
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
            font-weight: bold;
            color: #333;
        }
        
        .table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        
        .table-row {
            border-left: 5px solid transparent;
        }
        
        .table-row.active {
            border-left: 5px solid #00c853;
            background-color: #f5fff9;
        }
        
        .supplier-detail {
            margin-top: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        
        .tabs {
            display: flex;
            border-bottom: 1px solid #eee;
            margin-bottom: 20px;
        }
        
        .tab {
            padding: 10px 20px;
            cursor: pointer;
            font-weight: bold;
            color: #666;
        }
        
        .tab.active {
            color: #00c853;
            border-bottom: 2px solid #00c853;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .detail-item {
            margin-bottom: 15px;
        }
        
        .detail-label {
            color: #666;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-weight: bold;
            color: #333;
        }
        
        .note-area {
            margin-top: 20px;
        }
        
        .note-area textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            resize: none;
        }
        
        .detail-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-danger {
            background-color: #f44336;
        }
        
        .notification-bar {
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
        
        .checkbox {
            width: 18px;
            height: 18px;
        }
        
        .scroll-to-top {
            position: fixed;
            bottom: 20px;
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
        
        .chat-support {
            position: fixed;
            bottom: 70px;
            right: 20px;
            padding: 10px 15px;
            background-color: #2196f3;
            color: white;
            border-radius: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            gap: 5px;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Nhà cung cấp</h1>
            
            <div class="search-bar">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Theo mã, tên, điện thoại">
            </div>
            
            <div class="action-buttons">
                <button class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    Nhà cung cấp
                </button>
                <button class="btn btn-secondary">
                    <i class="fas fa-file-import"></i>
                    Import
                </button>
                <button class="btn btn-secondary">
                    <i class="fas fa-file-export"></i>
                    Xuất file
                </button>
                <button class="btn btn-dropdown">
                    <i class="fas fa-list"></i>
                </button>
            </div>
        </div>
        
        <div class="sidebar">
            <div class="sidebar-item">
                <div class="sidebar-title">Nhóm NCC</div>
                <div class="sidebar-icon">
                    <i class="fas fa-plus"></i>
                </div>
            </div>
            <div class="sidebar-item">
                <div class="sidebar-title">Tất cả các nhóm</div>
                <div class="sidebar-icon">
                    <i class="fas fa-chevron-down"></i>
                    <i class="fas fa-pencil-alt"></i>
                </div>
            </div>
            
            <div class="sidebar-filter">
                <div class="sidebar-filter-title">
                    <span>Tổng mua</span>
                    <i class="fas fa-chevron-up"></i>
                </div>
                
                <div class="sidebar-content">
                    <div class="input-group">
                        <label>Từ</label>
                        <input type="text" placeholder="Giá trị">
                    </div>
                    <div class="input-group">
                        <label>Tới</label>
                        <input type="text" placeholder="Giá trị">
                    </div>
                    
                    <div class="radio-group">
                        <input type="radio" id="all-time" name="time-period" checked>
                        <label for="all-time">Toàn thời gian</label>
                    </div>
                    <div class="radio-group">
                        <input type="radio" id="custom-time" name="time-period">
                        <label for="custom-time">Lựa chọn khác</label>
                        <i class="fas fa-calendar"></i>
                    </div>
                </div>
            </div>
            
            <div class="sidebar-filter">
                <div class="sidebar-filter-title">
                    <span>Nợ hiện tại</span>
                    <i class="fas fa-chevron-up"></i>
                </div>
                
                <div class="sidebar-content">
                    <div class="input-group">
                        <label>Từ</label>
                        <input type="text" placeholder="Giá trị">
                    </div>
                    <div class="input-group">
                        <label>Tới</label>
                        <input type="text" placeholder="Giá trị">
                    </div>
                </div>
            </div>
            
            <div class="sidebar-filter">
                <div class="sidebar-filter-title">
                    <span>Trạng thái</span>
                    <i class="fas fa-chevron-up"></i>
                </div>
                
                <div class="sidebar-content">
                    <div class="radio-group">
                        <input type="radio" id="all-status" name="status" checked>
                        <label for="all-status">Tất cả</label>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="content">
            <div class="main-table">
                <table class="table">
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
                            <td colspan="7">0</td>
                        </tr>
                        <tr class="table-row active">
                            <td><input type="checkbox" class="checkbox" checked></td>
                            <td>NCC0002</td>
                            <td>Công ty Hoàng Gia</td>
                            <td></td>
                            <td></td>
                            <td>0</td>
                            <td>0</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="supplier-detail">
                <div class="tabs">
                    <div class="tab active">Thông tin</div>
                    <div class="tab">Lịch sử nhập/trả hàng</div>
                    <div class="tab">Nợ cần trả NCC</div>
                </div>
                
                <div class="detail-grid">
                    <div class="detail-item">
                        <div class="detail-label">Mã nhà cung cấp:</div>
                        <div class="detail-value">NCC0002</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Công ty:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Tên nhà cung cấp:</div>
                        <div class="detail-value">Công ty Hoàng Gia</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Mã số thuế:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Địa chỉ:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Nhóm NCC:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Khu vực:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Người tạo:</div>
                        <div class="detail-value">Nguyễn Thành Long</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Phường xã:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Ngày tạo:</div>
                        <div class="detail-value">25/02/2025</div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Điện thoại:</div>
                        <div class="detail-value"></div>
                    </div>
                    <div class="detail-item">
                        <div class="detail-label">Email:</div>
                        <div class="detail-value"></div>
                    </div>
                </div>
                
                <div class="note-area">
                    <textarea placeholder="Ghi chú..."></textarea>
                </div>
                
                <div class="detail-actions">
                    <button class="btn btn-primary">
                        <i class="fas fa-check"></i>
                        Cập nhật
                    </button>
                    <button class="btn btn-danger">
                        <i class="fas fa-ban"></i>
                        Ngưng hoạt động
                    </button>
                    <button class="btn btn-danger">
                        <i class="fas fa-trash"></i>
                        Xóa
                    </button>
                </div>
            </div>
            
            <div class="main-table" style="margin-top: 20px;">
                <table class="table">
                    <tbody>
                        <tr class="table-row">
                            <td><input type="checkbox" class="checkbox"></td>
                            <td>NCC0003</td>
                            <td>Công ty Gia Hưng</td>
                            <td></td>
                            <td></td>
                            <td>0</td>
                            <td>0</td>
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
    
    <div class="scroll-to-top">
        <i class="fas fa-arrow-up"></i>
    </div>
    
    <div class="chat-support">
        <i class="fas fa-headset"></i>
        <span>Hỗ trợ: 1900 6522</span>
    </div>
</body>
</html>
