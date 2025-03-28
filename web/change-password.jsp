<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi Mật Khẩu | Hệ Thống Quản Lý</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #f8f9fc;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
            --warning-color: #f6c23e;
        }
        
        body {
            background-color: var(--secondary-color);
            height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .password-container {
            max-width: 500px;
            width: 100%;
            margin: 0 auto;
        }
        
        .password-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            overflow: hidden;
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            text-align: center;
            padding: 1.5rem;
        }
        
        .card-body {
            padding: 2rem;
            background-color: white;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #3a5bd9;
            border-color: #3a5bd9;
        }
        
        .password-strength {
            margin-top: 0.5rem;
        }
        
        .strength-meter {
            height: 5px;
            background-color: #e9ecef;
            border-radius: 3px;
            margin-top: 5px;
            overflow: hidden;
        }
        
        .strength-meter-fill {
            height: 100%;
            width: 0;
            transition: width 0.3s ease;
        }
        
        .requirement-list {
            list-style-type: none;
            padding-left: 0;
            margin-top: 1rem;
        }
        
        .requirement-item {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }
        
        .requirement-icon {
            margin-right: 0.5rem;
            width: 20px;
            text-align: center;
        }
        
        .valid {
            color: var(--success-color);
        }
        
        .invalid {
            color: var(--danger-color);
        }
        
        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
        
        .password-input-group {
            position: relative;
        }
    </style>
</head>
<body>
    <div class="container password-container">
        <div class="card password-card">
            <div class="card-header">
                <h3><i class="fas fa-key"></i> Đổi Mật Khẩu</h3>
            </div>
            <div class="card-body">
                <%-- Hiển thị thông báo lỗi --%>
                <% if (request.getSession().getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>
                
                <%-- Hiển thị thông báo thành công --%>
                <% if (request.getSession().getAttribute("successMessage") != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <form method="POST" action="change-password" id="passwordForm">
                    <div class="mb-3">
                        <label for="oldPassword" class="form-label">Mật khẩu hiện tại</label>
                        <div class="password-input-group">
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword('oldPassword')"></i>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                        <div class="password-input-group">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required 
                                   oninput="checkPasswordStrength()">
                            <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword')"></i>
                        </div>
                        <div class="password-strength">
                            <small>Độ mạnh mật khẩu:</small>
                            <div class="strength-meter">
                                <div class="strength-meter-fill" id="strengthMeter"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                        <div class="password-input-group">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required
                                   oninput="checkPasswordMatch()">
                            <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword')"></i>
                        </div>
                        <small id="passwordMatchText" class="text-muted"></small>
                    </div>
                    
                    <div class="mb-4">
                        <h6>Yêu cầu mật khẩu:</h6>
                        <ul class="requirement-list">
                            <li class="requirement-item">
                                <span class="requirement-icon"><i class="fas fa-check-circle" id="lengthIcon"></i></span>
                                <span id="lengthText">Ít nhất 8 ký tự</span>
                            </li>
                            <li class="requirement-item">
                                <span class="requirement-icon"><i class="fas fa-check-circle" id="upperIcon"></i></span>
                                <span id="upperText">Chứa ít nhất 1 chữ hoa (A-Z)</span>
                            </li>
                            <li class="requirement-item">
                                <span class="requirement-icon"><i class="fas fa-check-circle" id="lowerIcon"></i></span>
                                <span id="lowerText">Chứa ít nhất 1 chữ thường (a-z)</span>
                            </li>
                            <li class="requirement-item">
                                <span class="requirement-icon"><i class="fas fa-check-circle" id="numberIcon"></i></span>
                                <span id="numberText">Chứa ít nhất 1 số (0-9)</span>
                            </li>
                            <li class="requirement-item">
                                <span class="requirement-icon"><i class="fas fa-check-circle" id="specialIcon"></i></span>
                                <span id="specialText">Chứa ít nhất 1 ký tự đặc biệt (@$!%*?&)</span>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-sync-alt"></i> Đổi Mật Khẩu
                        </button>
                        <a href="SalesReport.jsp" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Hiển thị/ẩn mật khẩu
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling;
            
            if (field.type === "password") {
                field.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                field.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
        
        // Kiểm tra độ mạnh mật khẩu
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const meter = document.getElementById('strengthMeter');
            const icons = {
                length: document.getElementById('lengthIcon'),
                upper: document.getElementById('upperIcon'),
                lower: document.getElementById('lowerIcon'),
                number: document.getElementById('numberIcon'),
                special: document.getElementById('specialIcon')
            };
            const texts = {
                length: document.getElementById('lengthText'),
                upper: document.getElementById('upperText'),
                lower: document.getElementById('lowerText'),
                number: document.getElementById('numberText'),
                special: document.getElementById('specialText')
            };
            
            // Kiểm tra các yêu cầu
            const requirements = {
                length: password.length >= 8,
                upper: /[A-Z]/.test(password),
                lower: /[a-z]/.test(password),
                number: /\d/.test(password),
                special: /[@$!%*?&]/.test(password)
            };
            
            // Cập nhật icon và text
            for (const [key, value] of Object.entries(requirements)) {
                if (value) {
                    icons[key].classList.remove('fa-check-circle');
                    icons[key].classList.add('fa-check-circle', 'valid');
                    texts[key].classList.add('valid');
                    texts[key].classList.remove('invalid');
                } else {
                    icons[key].classList.remove('fa-check-circle', 'valid');
                    icons[key].classList.add('fa-times-circle', 'invalid');
                    texts[key].classList.add('invalid');
                    texts[key].classList.remove('valid');
                }
            }
            
            // Tính điểm độ mạnh
            let strength = 0;
            if (password.length > 0) strength += 1;
            if (password.length >= 8) strength += 1;
            if (requirements.upper) strength += 1;
            if (requirements.lower) strength += 1;
            if (requirements.number) strength += 1;
            if (requirements.special) strength += 1;
            
            // Cập nhật thanh độ mạnh
            const width = (strength / 6) * 100;
            meter.style.width = width + '%';
            
            // Đổi màu thanh độ mạnh
            if (strength <= 2) {
                meter.style.backgroundColor = '#e74a3b'; // Đỏ
            } else if (strength <= 4) {
                meter.style.backgroundColor = '#f6c23e'; // Vàng
            } else {
                meter.style.backgroundColor = '#1cc88a'; // Xanh lá
            }
        }
        
        // Kiểm tra mật khẩu trùng khớp
        function checkPasswordMatch() {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const matchText = document.getElementById('passwordMatchText');
            
            if (confirmPassword.length === 0) {
                matchText.textContent = '';
                matchText.classList.remove('valid', 'invalid');
                return;
            }
            
            if (password === confirmPassword) {
                matchText.textContent = 'Mật khẩu trùng khớp';
                matchText.classList.add('valid');
                matchText.classList.remove('invalid');
            } else {
                matchText.textContent = 'Mật khẩu không trùng khớp';
                matchText.classList.add('invalid');
                matchText.classList.remove('valid');
            }
        }
        
        // Validate form trước khi submit
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const password = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Kiểm tra mật khẩu trùng khớp
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu mới và xác nhận mật khẩu không trùng khớp!');
                return;
            }
            
            // Kiểm tra các yêu cầu mật khẩu
            const requirements = {
                length: password.length >= 8,
                upper: /[A-Z]/.test(password),
                lower: /[a-z]/.test(password),
                number: /\d/.test(password),
                special: /[@$!%*?&]/.test(password)
            };
            
            if (!Object.values(requirements).every(Boolean)) {
                e.preventDefault();
                alert('Mật khẩu mới không đáp ứng tất cả yêu cầu!');
                return;
            }
        });
    </script>
</body>
</html>