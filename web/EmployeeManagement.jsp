<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector, entity.Employee, entity.Account"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Slim - Nhân viên</title>
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

</head>

<%@include file="HeaderAdmin.jsp"%>
<main id="main" class="main">
    <div class="pagetitle">
        <h1>Quản Lý Nhân Viên</h1>
    </div>

    <div class="container">
        <div class="d-flex mb-3">
            <div class="me-auto">
                <select id="statusFilter" class="form-select" onchange="filterEmployees()">
                    <option value="">Tất cả</option>
                    <option value="1">Còn làm việc</option>
                    <option value="0">Nghỉ việc</option>
                </select>
            </div>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addEmployeeModal">
                <i class="bi-person-plus-fill"></i> Thêm Nhân Viên
            </button>
        </div>

        <div class="card">
            <div class="card-body">
                <table class="table table-striped datatable" id="employeeTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>CCCD</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th>Chi tiết</th>
                            <th>Hành động</th>
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
                            <td><%= employee.getEmployeeName() %></td>
                            <td><%= employee.getCccd() %></td>
                            <td><%= employee.getAccount().getPhone() %></td>
                            <td>
                                <% if (employee.isIsAvailable()) { %>
                                    <span class="badge bg-success">Còn làm việc</span>
                                <% } else { %>
                                    <span class="badge bg-danger">Nghỉ việc</span>
                                <% } %>
                            </td>
                            <td>
    <button class="btn btn-outline-primary btn-sm" 
            data-bs-toggle="modal" 
            data-bs-target="#employeeDetailModal"
            onclick="showEmployeeDetail('<%= employee.getEmployeeID() %>', 
                                        '<%= employee.getEmployeeName() %>', 
                                        '<%= employee.getCccd() %>', 
                                        '<%= employee.getAvatar() %>',
                                        '<%= employee.getAccount().getUserName() %>',
                                        '<%= employee.getAccount().getPassword() %>',
                                        '<%= employee.getAccount().getEmail() %>',
                                        '<%= employee.getAccount().getPhone() %>',
                                        '<%= employee.getAccount().getAddress() %>',
                                        '<%= employee.isIsAvailable() ? "Còn làm việc" : "Nghỉ việc" %>')">
        Chi tiết
    </button>
</td>
                            <td>
    <button class="btn btn-outline-warning btn-sm"
            data-bs-toggle="modal"
            data-bs-target="#updateEmployeeModal"
            onclick="showUpdateEmployeeModal('<%= employee.getEmployeeID() %>', 
                                             '<%= employee.getEmployeeName().replace("'", "\\'") %>', 
                                             '<%= employee.getAvatar() %>',
                                             '<%= employee.getDob() %>',
                                             '<%= employee.isGender() %>',
                                             '<%= employee.getSalary() %>',
                                             '<%= employee.getCccd() %>',
                                             '<%= employee.isIsAvailable() %>',
                                             '<%= employee.getAccount().getUserName() %>',
                                             '<%= employee.getAccount().getEmail() %>',
                                             '<%= employee.getAccount().getPhone() %>',
                                             '<%= employee.getAccount().getAddress().replace("'", "\\'") %>')">
        Cập nhật
    </button>



                           

    
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
</main>
                    


<!-- Modal for Adding Employee -->
<div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg"> <!-- Tăng kích thước modal -->
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addEmployeeModalLabel">Thêm nhân viên mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addEmployeeForm" onsubmit="return confirmAdd()">
                    <input type="hidden" name="service" value="addEmployee">

                    <div class="row">
                        <!-- Cột trái: Thông tin nhân viên -->
                        <div class="col-md-6">
                            <h5>Thông tin nhân viên</h5>

                            <label>Họ và Tên:</label>
                            <input type="text" name="employeeName" class="form-control" required>

                            <label>Avatar URL:</label>
                            <input type="text" name="avatar" class="form-control">

                            <label>Ngày sinh:</label>
                            <input type="date" name="dob" class="form-control" required>

                            <label>Giới tính:</label>
                            <select name="gender" class="form-control">
                                <option value="Male">Nam</option>
                                <option value="Female">Nữ</option>
                            </select>

                            <label>Lương:</label>
                            <input type="number" name="salary" class="form-control" required>

                            <label>CCCD:</label>
                            <input type="text" name="cccd" class="form-control" required>

                            <label>Trạng thái:</label>
                            <select name="isAvailable" class="form-control">
                                <option value="true">Đang làm</option>
                                <option value="false">Nghỉ</option>
                            </select>
                        </div>

                        <!-- Cột phải: Thông tin tài khoản -->
                        <div class="col-md-6">
                            <h5>Thông tin tài khoản</h5>

                            <label>Tên đăng nhập:</label>
                            <input type="text" name="userName" class="form-control" required>

                            <label>Mật khẩu:</label>
                            <input type="password" name="password" class="form-control" required>

                            <label>Email:</label>
                            <input type="email" name="email" class="form-control" required>

                            <label>Số điện thoại:</label>
                            <input type="number" name="phone" class="form-control" required>

                            <label>Địa chỉ:</label>
                            <input type="text" name="address" class="form-control" required>
                        </div>
                    </div>

                    <div class="text-center mt-3">
                        <button type="submit" class="btn btn-success">Thêm nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Modal Chi Tiết Nhân Viên -->
<div class="modal fade" id="employeeDetailModal" tabindex="-1" aria-labelledby="employeeDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="employeeDetailModalLabel">Thông Tin Nhân Viên</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body d-flex align-items-center">
                <!-- Hiển thị Avatar -->
                <div class="avatar-container" style="flex-shrink: 0;">
                    <img src="assets/img/default-avatar.png" class="img-fluid rounded-circle mb-3" alt="Avatar" style="width: 150px; height: 150px; object-fit: cover;">
                </div>
                <div class="info-container ms-4">
                    <p><strong>ID:</strong> NV00<span id="empID"></span></p>
                    <p><strong>Tên:</strong> <span id="empName"></span></p>
                    <p><strong>CCCD:</strong> <span id="empCCCD"></span></p>
                    <p><strong>Tên tài khoản:</strong> <span id="empUsername"></span></p>
                    <p><strong>Mật khẩu:</strong> <span id="empPassword"></span></p>
                    <p><strong>Email:</strong> <span id="empEmail"></span></p>
                    <p><strong>Số điện thoại:</strong> <span id="empPhone"></span></p>
                    <p><strong>Địa chỉ:</strong> <span id="empAddress"></span></p>
                    <p><strong>Trạng thái:</strong> <span id="empStatus"></span></p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>


<!-- Modal Cập nhật Nhân Viên -->
<div class="modal fade" id="updateEmployeeModal" tabindex="-1" aria-labelledby="updateEmployeeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateEmployeeModalLabel">Cập nhật nhân viên</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>

            </div>
            <div class="modal-body">
                <form id="updateEmployeeForm" action="EmployeeControllerURL" method="POST"  onsubmit="return confirmUpdate()">
                    <input type="hidden" name="service" value="updateEmployee">
                    <input type="hidden" name="employeeID" id="updateEmployeeID">

                    <div class="row">
                        <div class="col-md-6">
                            <h5>Thông tin nhân viên</h5>
                            <label>Họ và Tên:</label>
                            <input type="text" name="employeeName" id="updateEmployeeName" class="form-control" required>

                            <label>Avatar URL:</label>
                            <input type="text" name="avatar" id="updateAvatar" class="form-control">

                            <label>Ngày sinh:</label>
                            <input type="date" name="dob" id="updateDob" class="form-control" required>

                            <label>Giới tính:</label>
                            <select name="gender" id="updateGender" class="form-control">
                                <option value="true">Nam</option>
                                <option value="false">Nữ</option>
                            </select>

                            <label>Lương:</label>
                            <input type="number" name="salary" id="updateSalary" class="form-control" required>

                            <label>CCCD:</label>
                            <input type="text" name="cccd" id="updateCccd" class="form-control" required>

                            <label>Trạng thái:</label>
                            <select name="isAvailable" id="updateIsAvailable" class="form-control">
                                <option value="true">Đang làm</option>
                                <option value="false">Nghỉ</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <h5>Thông tin tài khoản</h5>
                            <label>Tên đăng nhập:</label>
                            <input type="text" name="userName" id="updateUserName" class="form-control" required>

                            <label>Email:</label>
                            <input type="email" name="email" id="updateEmail" class="form-control" required>

                            <label>Số điện thoại:</label>
                            <input type="text" name="phone" id="updatePhone" class="form-control" required>

                            <label>Địa chỉ:</label>
                            <input type="text" name="address" id="updateAddress" class="form-control" required>
                        </div>
                    </div>

                    <div class="text-center mt-3">
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


<script>
    function filterEmployees() {
        var filterValue = document.getElementById('statusFilter').value;
        var rows = document.querySelectorAll('#employeeTable .employeeRow');

        rows.forEach(function(row) {
            var status = row.getAttribute('data-status');
            row.style.display = (filterValue === "" || status === filterValue) ? '' : 'none';
        });
    }

    function showEmployeeDetail(id, name, cccd, avatar, username, password, email, phone, address, status) {
        document.getElementById("empID").innerText = id;
        document.getElementById("empName").innerText = name;
        document.getElementById("empCCCD").innerText = cccd;
        document.getElementById("empUsername").innerText = username;
        document.getElementById("empPassword").innerText = password;
        document.getElementById("empEmail").innerText = email;
        document.getElementById("empPhone").innerText = phone;
        document.getElementById("empAddress").innerText = address;
        document.getElementById("empStatus").innerText = status;

        // Cập nhật avatar (nếu không có thì hiển thị ảnh mặc định)
        document.getElementById("empAvatar").src = avatar && avatar.trim() !== "" ? avatar : "assets/img/default-avatar.png";
    }

    
</script>
<script>
    function showUpdateEmployeeModal(id, name, avatar, dob, gender, salary, cccd, isAvailable, username, email, phone, address) {
        document.getElementById("updateEmployeeID").value = id;
        document.getElementById("updateEmployeeName").value = name;
        document.getElementById("updateAvatar").value = avatar;
        
        // Chuyển đổi ngày về định dạng YYYY-MM-DD để input date hiển thị đúng
        if (dob) {
            let dateObj = new Date(dob);
            let formattedDate = dateObj.toISOString().split('T')[0]; // YYYY-MM-DD
            document.getElementById("updateDob").value = formattedDate;
        } else {
            document.getElementById("updateDob").value = "";
        }

        document.getElementById("updateGender").value = gender === "true" ? "true" : "false";
        document.getElementById("updateSalary").value = salary;
        document.getElementById("updateCccd").value = cccd;
        document.getElementById("updateIsAvailable").value = isAvailable === "true" ? "true" : "false";
        document.getElementById("updateUserName").value = username;
        document.getElementById("updateEmail").value = email;
        document.getElementById("updatePhone").value = phone;
        document.getElementById("updateAddress").value = address;

        // Hiển thị modal cập nhật
    }


        function confirmAdd() {
            return confirm("✅ Xác nhận thêm nhân viên?");
        }

        function confirmUpdate() {
            return confirm("⚠️ Bạn có chắc chắn muốn cập nhật nhân viên?");
        }
</script>

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

</body>
</html>
