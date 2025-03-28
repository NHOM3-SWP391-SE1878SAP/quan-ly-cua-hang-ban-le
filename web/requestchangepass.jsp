<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- mobile metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="viewport" content="initial-scale=1, maximum-scale=1">
        <!-- site metas -->
        <title>Đổi mật khẩu</title>
        <link rel="icon" href="images/logo/logo_icon.png" type="image/x-icon">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="css/bootstrap.min.css" />
        <!-- Custom Styles -->
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f7f7f7;
            }
            .container {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
            }
            .login_form {
                background-color: #fff;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 400px;
                text-align: center;
            }
            h2 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #333;
            }
            .styled-input {
                width: 100%;
                height: 40px;
                padding: 10px;
                font-size: 16px;
                border: 2px solid #ccc;
                border-radius: 25px;
                outline: none;
                margin-top: 10px;
            }
            .styled-input:focus {
                border-color: #007BFF;
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.5);
            }
            .error-message {
                color: red;
                margin-top: 10px;
            }
            .forgot {
                color: #007BFF;
                text-decoration: none;
            }
            .forgot:hover {
                text-decoration: underline;
            }
            .main_bt {
                background-color: #007BFF;
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 25px;
                font-size: 16px;
                cursor: pointer;
                margin-top: 20px;
            }
            .main_bt:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body class="inner_page login">
        <div class="full_container">
            <div class="container">
                <div class="login_form">
                    <h2>Yêu cầu đặt lại mật khẩu</h2>
                    <form action="sendcodetoemail" method="POST">
                        <fieldset>
                            <div class="field">
                                <label class="label_field">Email</label>
                                <input type="text" name="email" class="styled-input" required/>
                            </div>
                            <div class="field">
                                <a class="forgot" href="login.jsp">Đăng nhập</a>
                            </div>
                            <div class="field">
                                <a style="color: orangered">${error}</a>
                            </div>
                            <div class="field margin_0">
                                <button class="main_bt" type="submit">Yêu cầu đặt lại mật khẩu</button>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </div>
        </div>
        <!-- jQuery -->
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script>
            // You can add any additional JavaScript here if needed
        </script>
    </body>
</html>
