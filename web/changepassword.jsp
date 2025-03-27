<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>The Card Shop - Đổi mật khẩu</title>
        <link rel="icon" href="images/logo/logo_icon.png" type="image/x-icon">
        <link rel="stylesheet" href="css/bootstrap.min.css" />
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f7fc;
                margin: 0;
                padding: 0;
            }
            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }
            .login_form {
                width: 100%;
                max-width: 400px;
                padding: 40px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .login_form h2 {
                font-size: 24px;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
            }
            .field {
                margin-bottom: 20px;
                text-align: left;
            }
            .label_field {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                color: #333;
            }
            .styled-input {
                width: 100%;
                padding: 12px;
                font-size: 16px;
                border: 2px solid #ccc;
                border-radius: 5px;
                outline: none;
                transition: border-color 0.3s ease;
            }
            .styled-input:focus {
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
            }
            .styled-input::placeholder {
                color: #aaa;
            }
            .btn-primary {
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            .btn-primary:hover {
                background-color: #0056b3;
            }
            .forgot {
                display: block;
                text-align: center;
                color: #007bff;
                font-size: 14px;
                margin-top: 15px;
                text-decoration: none;
            }
            .forgot:hover {
                text-decoration: underline;
            }
            .error-message, .success-message {
                color: red;
                font-size: 14px;
                margin-top: 10px;
                text-align: center;
            }
            .success-message {
                color: green;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="login_form">
                <h2>Đặt lại mật khẩu</h2>
                <form action="changepassword" method="POST">
                    <div class="field">
                        <label class="label_field">Mật khẩu mới</label>
                        <input type="password" name="newpassword" class="styled-input" placeholder="Nhập mật khẩu mới" required />
                    </div>
                    <div class="field">
                        <label class="label_field">Xác nhận mật khẩu</label>
                        <input type="password" name="confirmpassword" class="styled-input" placeholder="Nhập lại mật khẩu mới" required />
                    </div>
                    <div class="field">
                        <button type="submit" class="btn-primary">Đổi mật khẩu</button>
                    </div>
                    <div class="field">
                        <a class="forgot" href="Login.jsp">Quay về trang đăng nhập</a>
                    </div>

                    <!-- Displaying Success message -->
                    <div class="success-message">
                        <c:if test="${not empty sessionScope.confirm}">
                            ${sessionScope.confirm}
                        </c:if>
                        <c:remove var="confirm" />
                    </div>

                    <!-- Displaying Error message -->
                    <div class="error-message">
                        <c:if test="${not empty requestScope.error}">
                            ${requestScope.error}
                        </c:if>
                    </div>
                </form>
            </div>
        </div>
        <div id="successPopup">
            <p>${sessionScope.confirm}</p>
            <button onclick="closePopup()">OK</button>
        </div>     
        <script>
            function closePopup() {
                document.getElementById("successPopup").style.display = "none";
                window.location.href = "login.jsp"; // Quay lại trang login
            }

            // Kiểm tra nếu có thông báo từ session, hiển thị popup
            window.onload = function () {
                var successMessage = "${sessionScope.confirm}";
                if (successMessage && successMessage !== "null" && successMessage !== "") {
                    document.getElementById("successPopup").style.display = "block";
                }
            };
        </script>
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>
