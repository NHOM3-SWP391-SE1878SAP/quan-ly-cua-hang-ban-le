<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, entity.Employee, entity.Account"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Slim - Quản lý nhân viên</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

    <!-- Vendor CSS Files -->
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet">
    
    <style>
        .password-requirements {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .requirement-item {
            display: flex;
            align-items: center;
            margin-bottom: 2px;
        }
        .requirement-item i {
            margin-right: 5px;
        }
        .password-input-group {
            position: relative;
        }
        .password-input-group .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
        .password-input-group .toggle-password:hover {
            color: #495057;
        }
        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #dee2e6;
            margin-bottom: 15px;
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .action-buttons .btn {
            margin-right: 5px;
        }
        .form-section {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        .form-section h5 {
            color: #4154f1;
            margin-bottom: 15px;
        }
    </style>
</head>

<body>
    <%@include file="HeaderAdmin.jsp"%>
    
    <main id="main" class="main">
        <div class="pagetitle">
            <h1>Quản Lý Nhân Viên</h1>
            <nav>
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="index.html">Trang chủ</a></li>
                    <li class="breadcrumb-item active">Nhân viên</li>
                </ol>
            </nav>
        </div>

        <section class="section">
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <!-- Display messages -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="bi bi-exclamation-octagon me-1"></i>
                                    ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            <c:if test="${not empty message}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="bi bi-check-circle me-1"></i>
                                    ${message}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>

                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="filter-section d-flex">
                                    <select id="statusFilter" class="form-select me-2" style="width: 180px;" onchange="filterEmployees()">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="1">Đang làm việc</option>
                                        <option value="0">Đã nghỉ việc</option>
                                    </select>
                                    <input type="text" id="searchInput" class="form-control" placeholder="Tìm kiếm..." onkeyup="searchEmployees()" style="width: 250px;">
                                </div>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
                                    <i class="bi bi-person-plus-fill me-1"></i>Thêm nhân viên
                                </button>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-hover datatable" id="employeeTable">
                                    <thead class="table-light">
                                        <tr>
                                            <th scope="col">ID</th>
                                            <th scope="col">Tên nhân viên</th>
                                            <th scope="col">CCCD</th>
                                            <th scope="col">Số điện thoại</th>
                                            <th scope="col">Trạng thái</th>
                                            <th scope="col">Chi tiết</th>
                                            <th scope="col">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        Vector<Employee> employees = (Vector<Employee>) request.getAttribute("employees");
                                        if (employees != null) {
                                            for (Employee employee : employees) { 
                                        %>
                                        <tr class="employeeRow" data-status="<%= employee.isIsAvailable() ? "1" : "0" %>">
                                            <td>NV<%= employee.getEmployeeID() %></td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <% if (employee.getAvatar() != null && !employee.getAvatar().isEmpty()) { %>
                                                        <img src="<%= employee.getAvatar() %>" alt="Avatar" class="rounded-circle me-2" style="width: 40px; height: 40px; object-fit: cover;">
                                                    <% } else { %>
                                                        <div class="avatar-placeholder rounded-circle me-2" style="width: 40px; height: 40px; background-color: #f0f0f0; display: flex; align-items: center; justify-content: center;">
                                                            <i class="bi bi-person" style="font-size: 1.2rem; color: #6c757d;"></i>
                                                        </div>
                                                    <% } %>
                                                    <%= employee.getEmployeeName() %>
                                                </div>
                                            </td>
                                            <td><%= employee.getCccd() %></td>
                                            <td><%= employee.getAccount().getPhone() %></td>
                                            <td>
                                                <% if (employee.isIsAvailable()) { %>
                                                    <span class="badge bg-success status-badge">Đang làm việc</span>
                                                <% } else { %>
                                                    <span class="badge bg-danger status-badge">Đã nghỉ việc</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <button class="btn btn-outline-primary btn-sm" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#employeeDetailModal"
                                                        onclick="showEmployeeDetail(
                                                            '<%= employee.getEmployeeID() %>', 
                                                            '<%= employee.getEmployeeName().replace("'", "\\'") %>', 
                                                            '<%= employee.getCccd() %>', 
                                                            '<%= employee.getAvatar() != null ? employee.getAvatar() : "" %>',
                                                            '<%= employee.getAccount().getUserName() %>',
                                                            '<%= employee.getAccount().getPassword() %>',
                                                            '<%= employee.getAccount().getEmail() %>',
                                                            '<%= employee.getAccount().getPhone() %>',
                                                            '<%= employee.getAccount().getAddress().replace("'", "\\'") %>',
                                                            '<%= employee.getDob() %>',
                                                            '<%= employee.isGender() ? "Nam" : "Nữ" %>',
                                                            '<%= employee.getSalary() %>',
                                                            '<%= employee.isIsAvailable() ? "Đang làm việc" : "Đã nghỉ việc" %>')">
                                                    <i class="bi bi-eye"></i> Chi tiết
                                                </button>
                                            </td>
                                            <td class="action-buttons">
                                                <button class="btn btn-outline-warning btn-sm"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#updateEmployeeModal"
                                                        onclick="showUpdateEmployeeModal(
                                                            '<%= employee.getEmployeeID() %>', 
                                                            '<%= employee.getEmployeeName().replace("'", "\\'") %>', 
                                                            '<%= employee.getAvatar() != null ? employee.getAvatar() : "" %>',
                                                            '<%= employee.getDob() %>',
                                                            '<%= employee.isGender() %>',
                                                            '<%= employee.getSalary() %>',
                                                            '<%= employee.getCccd() %>',
                                                            '<%= employee.isIsAvailable() %>',
                                                            '<%= employee.getAccount().getUserName() %>',
                                                            '<%= employee.getAccount().getEmail() %>',
                                                            '<%= employee.getAccount().getPhone() %>',
                                                            '<%= employee.getAccount().getAddress().replace("'", "\\'") %>')">
                                                    <i class="bi bi-pencil"></i> Sửa
                                                </button>
                                                <a href="EmployeeControllerURL?service=deleteEmployee&employeeID=<%= employee.getEmployeeID() %>" 
                                                   class="btn btn-outline-danger btn-sm"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa nhân viên này?')">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </a>
                                            </td>
                                        </tr>
                                        <% 
                                            } 
                                        } 
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <!-- Add Employee Modal -->
    <div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addEmployeeModalLabel">Thêm nhân viên mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addEmployeeForm" action="EmployeeControllerURL" method="POST" onsubmit="return validateAddEmployeeForm()">
                    <input type="hidden" name="service" value="addEmployee">
                    
                    <div class="modal-body">
                        <div class="row">
                            <!-- Employee Information -->
                            <div class="col-md-6">
                                <div class="form-section">
                                    <h5>Thông tin nhân viên</h5>
                                    
                                    <div class="text-center mb-3">
                                        <img id="avatarPreview" src="assets/img/default-avatar.png" class="avatar-preview" alt="Avatar Preview">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" name="employeeName" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Avatar URL</label>
                                        <input type="text" name="avatar" id="avatarInput" class="form-control" onchange="updateAvatarPreview(this.value, 'avatarPreview')">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Ngày sinh <span class="text-danger">*</span></label>
                                        <input type="date" name="dob" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Giới tính <span class="text-danger">*</span></label>
                                        <select name="gender" class="form-select" required>
                                            <option value="true">Nam</option>
                                            <option value="false">Nữ</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-section">
                                    <h5>Thông tin bổ sung</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Lương <span class="text-danger">*</span></label>
                                        <input type="number" name="salary" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">CCCD <span class="text-danger">*</span></label>
                                        <input type="text" name="cccd" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select name="isAvailable" class="form-select" required>
                                            <option value="true">Đang làm việc</option>
                                            <option value="false">Đã nghỉ việc</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <h5>Thông tin tài khoản</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                        <input type="text" name="userName" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                        <div class="password-input-group">
                                            <input type="password" name="password" id="newEmployeePassword" class="form-control" 
                                                   required oninput="checkEmployeePasswordStrength()">
                                            <i class="bi bi-eye-slash toggle-password" onclick="togglePassword('newEmployeePassword')"></i>
                                        </div>
                                        
                                        <div class="password-strength mt-2">
                                            <small>Độ mạnh mật khẩu:</small>
                                            <div class="progress" style="height: 5px;">
                                                <div id="passwordStrengthBar" class="progress-bar" role="progressbar" style="width: 0%"></div>
                                            </div>
                                        </div>
                                        
                                        <div class="password-requirements mt-2">
                                            <small class="text-muted">Yêu cầu mật khẩu:</small>
                                            <ul class="list-unstyled">
                                                <li class="requirement-item" id="reqLength">
                                                    <i class="bi bi-x-circle-fill text-danger"></i>
                                                    <span>Ít nhất 8 ký tự</span>
                                                </li>
                                                <li class="requirement-item" id="reqUpper">
                                                    <i class="bi bi-x-circle-fill text-danger"></i>
                                                    <span>Chứa chữ hoa (A-Z)</span>
                                                </li>
                                                <li class="requirement-item" id="reqLower">
                                                    <i class="bi bi-x-circle-fill text-danger"></i>
                                                    <span>Chứa chữ thường (a-z)</span>
                                                </li>
                                                <li class="requirement-item" id="reqNumber">
                                                    <i class="bi bi-x-circle-fill text-danger"></i>
                                                    <span>Chứa số (0-9)</span>
                                                </li>
                                                <li class="requirement-item" id="reqSpecial">
                                                    <i class="bi bi-x-circle-fill text-danger"></i>
                                                    <span>Chứa ký tự đặc biệt (@$!%*?&)</span>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" name="email" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="tel" name="phone" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                        <input type="text" name="address" class="form-control" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Thêm nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Employee Detail Modal -->
    <div class="modal fade" id="employeeDetailModal" tabindex="-1" aria-labelledby="employeeDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="employeeDetailModalLabel">Thông tin chi tiết nhân viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <img id="empAvatar" src="assets/img/default-avatar.png" class="avatar-preview" alt="Employee Avatar">
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin cá nhân</h6>
                            <p><strong>ID:</strong> NV<span id="empID"></span></p>
                            <p><strong>Tên:</strong> <span id="empName"></span></p>
                            <p><strong>Ngày sinh:</strong> <span id="empDob"></span></p>
                            <p><strong>Giới tính:</strong> <span id="empGender"></span></p>
                            <p><strong>CCCD:</strong> <span id="empCCCD"></span></p>
                            <p><strong>Lương:</strong> <span id="empSalary"></span> VNĐ</p>
                            <p><strong>Trạng thái:</strong> <span id="empStatus" class="badge"></span></p>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin tài khoản</h6>
                            <p><strong>Tên đăng nhập:</strong> <span id="empUsername"></span></p>
                            <p><strong>Mật khẩu:</strong> <span id="empPassword"></span></p>
                            <p><strong>Email:</strong> <span id="empEmail"></span></p>
                            <p><strong>Số điện thoại:</strong> <span id="empPhone"></span></p>
                            <p><strong>Địa chỉ:</strong> <span id="empAddress"></span></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Employee Modal -->
    <div class="modal fade" id="updateEmployeeModal" tabindex="-1" aria-labelledby="updateEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateEmployeeModalLabel">Cập nhật thông tin nhân viên</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="updateEmployeeForm" action="EmployeeControllerURL" method="POST" onsubmit="return validateUpdateEmployeeForm()">
                    <input type="hidden" name="service" value="updateEmployee">
                    <input type="hidden" name="employeeID" id="updateEmployeeID">
                    
                    <div class="modal-body">
                        <div class="row">
                            <!-- Employee Information -->
                            <div class="col-md-6">
                                <div class="form-section">
                                    <h5>Thông tin nhân viên</h5>
                                    
                                    <div class="text-center mb-3">
                                        <img id="updateAvatarPreview" src="assets/img/default-avatar.png" class="avatar-preview" alt="Avatar Preview">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" name="employeeName" id="updateEmployeeName" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Avatar URL</label>
                                        <input type="text" name="avatar" id="updateAvatar" class="form-control" onchange="updateAvatarPreview(this.value, 'updateAvatarPreview')">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Ngày sinh <span class="text-danger">*</span></label>
                                        <input type="date" name="dob" id="updateDob" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Giới tính <span class="text-danger">*</span></label>
                                        <select name="gender" id="updateGender" class="form-select" required>
                                            <option value="true">Nam</option>
                                            <option value="false">Nữ</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-section">
                                    <h5>Thông tin bổ sung</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Lương <span class="text-danger">*</span></label>
                                        <input type="number" name="salary" id="updateSalary" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">CCCD <span class="text-danger">*</span></label>
                                        <input type="text" name="cccd" id="updateCccd" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select name="isAvailable" id="updateIsAvailable" class="form-select" required>
                                            <option value="true">Đang làm việc</option>
                                            <option value="false">Đã nghỉ việc</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-section">
                                    <h5>Thông tin tài khoản</h5>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                        <input type="text" name="userName" id="updateUserName" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Email <span class="text-danger">*</span></label>
                                        <input type="email" name="email" id="updateEmail" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                        <input type="tel" name="phone" id="updatePhone" class="form-control" required>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                        <input type="text" name="address" id="updateAddress" class="form-control" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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

    <script>
        // Filter employees by status
        function filterEmployees() {
            var filterValue = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#employeeTable .employeeRow');
            
            rows.forEach(function(row) {
                var status = row.getAttribute('data-status');
                row.style.display = (filterValue === "" || status === filterValue) ? '' : 'none';
            });
        }
        
        // Search employees
        function searchEmployees() {
            var input = document.getElementById('searchInput').value.toLowerCase();
            var rows = document.querySelectorAll('#employeeTable .employeeRow');
            
            rows.forEach(function(row) {
                var name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                var phone = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                var cccd = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                
                if (name.includes(input) || phone.includes(input) || cccd.includes(input)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Show employee details in modal
        function showEmployeeDetail(id, name, cccd, avatar, username, password, email, phone, address, dob, gender, salary, status) {
            document.getElementById("empID").textContent = id;
            document.getElementById("empName").textContent = name;
            document.getElementById("empCCCD").textContent = cccd;
            document.getElementById("empUsername").textContent = username;
            document.getElementById("empPassword").textContent = password.replace(/./g, '•');
            document.getElementById("empEmail").textContent = email;
            document.getElementById("empPhone").textContent = phone;
            document.getElementById("empAddress").textContent = address;
            document.getElementById("empDob").textContent = formatDate(dob);
            document.getElementById("empGender").textContent = gender;
            document.getElementById("empSalary").textContent = formatCurrency(salary);
            
            // Update status badge
            const statusBadge = document.getElementById("empStatus");
            statusBadge.textContent = status;
            statusBadge.className = "badge " + (status === "Đang làm việc" ? "bg-success" : "bg-danger");
            
            // Update avatar
            const avatarImg = document.getElementById("empAvatar");
            avatarImg.src = avatar && avatar.trim() !== "" ? avatar : "assets/img/default-avatar.png";
        }
        
        // Show update employee modal with data
        function showUpdateEmployeeModal(id, name, avatar, dob, gender, salary, cccd, isAvailable, username, email, phone, address) {
            document.getElementById("updateEmployeeID").value = id;
            document.getElementById("updateEmployeeName").value = name;
            document.getElementById("updateAvatar").value = avatar;
            document.getElementById("updateAvatarPreview").src = avatar && avatar.trim() !== "" ? avatar : "assets/img/default-avatar.png";
            
            // Format date for input
            if (dob) {
                const dateObj = new Date(dob);
                const formattedDate = dateObj.toISOString().split('T')[0];
                document.getElementById("updateDob").value = formattedDate;
            }
            
            document.getElementById("updateGender").value = gender;
            document.getElementById("updateSalary").value = salary;
            document.getElementById("updateCccd").value = cccd;
            document.getElementById("updateIsAvailable").value = isAvailable;
            document.getElementById("updateUserName").value = username;
            document.getElementById("updateEmail").value = email;
            document.getElementById("updatePhone").value = phone;
            document.getElementById("updateAddress").value = address;
        }
        
        // Password strength checker
        function checkEmployeePasswordStrength() {
            const password = document.getElementById('newEmployeePassword').value;
            const strengthBar = document.getElementById('passwordStrengthBar');
            const requirements = {
                length: password.length >= 8,
                upper: /[A-Z]/.test(password),
                lower: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[@$!%*?&]/.test(password)
            };
            
            // Update requirement indicators
            document.getElementById('reqLength').innerHTML = requirements.length ? 
                '<i class="bi bi-check-circle-fill text-success"></i><span> Ít nhất 8 ký tự</span>' : 
                '<i class="bi bi-x-circle-fill text-danger"></i><span> Ít nhất 8 ký tự</span>';
            
            document.getElementById('reqUpper').innerHTML = requirements.upper ? 
                '<i class="bi bi-check-circle-fill text-success"></i><span> Chứa chữ hoa (A-Z)</span>' : 
                '<i class="bi bi-x-circle-fill text-danger"></i><span> Chứa chữ hoa (A-Z)</span>';
            
            document.getElementById('reqLower').innerHTML = requirements.lower ? 
                '<i class="bi bi-check-circle-fill text-success"></i><span> Chứa chữ thường (a-z)</span>' : 
                '<i class="bi bi-x-circle-fill text-danger"></i><span> Chứa chữ thường (a-z)</span>';
            
            document.getElementById('reqNumber').innerHTML = requirements.number ? 
                '<i class="bi bi-check-circle-fill text-success"></i><span> Chứa số (0-9)</span>' : 
                '<i class="bi bi-x-circle-fill text-danger"></i><span> Chứa số (0-9)</span>';
            
            document.getElementById('reqSpecial').innerHTML = requirements.special ? 
                '<i class="bi bi-check-circle-fill text-success"></i><span> Chứa ký tự đặc biệt (@$!%*?&)</span>' : 
                '<i class="bi bi-x-circle-fill text-danger"></i><span> Chứa ký tự đặc biệt (@$!%*?&)</span>';
            
            // Calculate strength score (0-100)
            const metRequirements = Object.values(requirements).filter(Boolean).length;
            const strength = (metRequirements / 5) * 100;
            
            // Update strength bar
            strengthBar.style.width = strength + '%';
            strengthBar.className = 'progress-bar ' + 
                (strength < 40 ? 'bg-danger' : 
                 strength < 70 ? 'bg-warning' : 'bg-success');
        }
        
        // Validate password
        function validatePassword(password) {
            // At least 8 characters, one uppercase, one lowercase, one number, one special character
            const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            return regex.test(password);
        }
        
        // Toggle password visibility
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling;
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        }
        
        // Update avatar preview
        function updateAvatarPreview(url, previewId) {
            const preview = document.getElementById(previewId);
            preview.src = url && url.trim() !== "" ? url : "assets/img/default-avatar.png";
        }
        
        // Format date for display
        function formatDate(dateString) {
            if (!dateString) return "";
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }
        
        // Format currency for display
        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount);
        }
        
        // Validate add employee form
        function validateAddEmployeeForm() {
            // Password validation
            const password = document.getElementById('newEmployeePassword').value;
            if (!validatePassword(password)) {
                alert('Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (@$!%*?&)');
                return false;
            }
            
            // Email format validation
            const email = document.querySelector('input[name="email"]').value;
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Vui lòng nhập địa chỉ email hợp lệ');
                return false;
            }
            
            // Phone number validation (simple check for Vietnam numbers)
            const phone = document.querySelector('input[name="phone"]').value;
            if (!/^(0|\+84)(\d{9,10})$/.test(phone)) {
                alert('Vui lòng nhập số điện thoại hợp lệ (bắt đầu bằng 0 hoặc +84)');
                return false;
            }
            
            return confirmAdd();
        }
        
        // Validate update employee form
        function validateUpdateEmployeeForm() {
            // Email format validation
            const email = document.getElementById('updateEmail').value;
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Vui lòng nhập địa chỉ email hợp lệ');
                return false;
            }
            
            // Phone number validation (simple check for Vietnam numbers)
            const phone = document.getElementById('updatePhone').value;
            if (!/^(0|\+84)(\d{9,10})$/.test(phone)) {
                alert('Vui lòng nhập số điện thoại hợp lệ (bắt đầu bằng 0 hoặc +84)');
                return false;
            }
            
            return confirmUpdate();
        }
        
        // Confirmation dialogs
        function confirmAdd() {
            return confirm("✅ Bạn có chắc chắn muốn thêm nhân viên này?");
        }
        
        function confirmUpdate() {
            return confirm("⚠️ Bạn có chắc chắn muốn cập nhật thông tin nhân viên?");
        }
        
        // Initialize the page
        document.addEventListener('DOMContentLoaded', function() {
            // Set up form validation
            document.getElementById('addEmployeeForm').onsubmit = validateAddEmployeeForm;
            document.getElementById('updateEmployeeForm').onsubmit = validateUpdateEmployeeForm;
            
            // Initialize avatar preview for add form
            document.getElementById('avatarInput').addEventListener('input', function() {
                updateAvatarPreview(this.value, 'avatarPreview');
            });
        });
    </script>
</body>
</html>