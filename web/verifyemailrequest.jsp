<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- basic -->
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <!-- mobile metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- site metas -->
        <title> Xác nhận Email</title>
        <meta name="keywords" content="">
        <meta name="description" content="">
        <meta name="author" content="">
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
            .countdown-container {
                font-size: 18px;
                color: #007BFF;
                margin: 10px 0;
            }
            .styled-input {
                width: 100%;
                height: 40px;
                padding: 10px;
                font-size: 16px;
                border: 2px solid #ccc;
                border-radius: 25px;
                outline: none;
                transition: all 0.3s ease;
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
            .success-message {
                color: green;
                margin-top: 20px;
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
            .resend-link {
                color: blue;
                text-decoration: underline;
                cursor: pointer;
            }
            .resend-link:hover {
                text-decoration: none;
            }
        </style>
    </head>
    <body class="inner_page login">
        <div class="full_container">
            <div class="container">
                <div class="login_form">
                    <h2>Xác thực OTP</h2>
                    <form action="verifypasswordotp" method="POST">
                        <div class="field">
                            <h5>Vui lòng nhập mã số chúng tôi đã gửi cho bạn qua email ${email}.<br/> Mã xác thực có giá trị trong 60s</h5>
                            <div class="countdown-container">
                                <span id="countdown">60</span>
                            </div>
                            <input type="text" name="otp" class="styled-input" placeholder="Nhập mã OTP" required/>
                            <input type="hidden" name="email" value="${sessionScope.email}"/>
                            <input type="hidden" name="userId" value="${sessionScope.userId}"/>
                            <input type="hidden" name="idOtp" value="${sessionScope.idOtp}">
                        </div>
                        <div class="error-message">
                            <a>${errorotp}</a>
                        </div>
                        <div class="field">
                            <button type="submit" class="main_bt">Xác nhận</button>
                        </div>
                    </form>
                    <form action="resendemailforgot" method="POST">
                        <div class="field">
                            <h6>Chưa nhận được mã? 
                                <input type="hidden" name="action" value="resend">
                                <input type="hidden" name="email" value="${sessionScope.email}">
                                <input type="hidden" name="userId" value="${sessionScope.userId}"/>
                                <button type="submit" class="resend-link">Gửi lại</button>
                            </h6>
                        </div>
                        <div class="success-message">
                            <h6>${sessionScope.resentSuccess}</h6>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- jQuery -->
        <script src="js/jquery.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script>
            window.onload = function () {
                let countdownNumber = 60;
                const countdownElement = document.getElementById('countdown');

                const countdown = setInterval(() => {
                    countdownNumber--;
                    countdownElement.textContent = countdownNumber;

                    if (countdownNumber <= 0) {
                        clearInterval(countdown);
                        countdownElement.textContent = "Hết giờ!";
                    }
                }, 1000);
            };
        </script>
    </body>
</html>
