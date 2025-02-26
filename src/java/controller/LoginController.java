package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOAccount;
import entity.Account;

/**
 * Servlet xử lý đăng nhập người dùng.
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        
        DAOAccount dao = new DAOAccount();
        Account account = dao.checkLogin(userName, password);
        
        if (account != null) {
            // Lưu thông tin tài khoản vào session
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            response.sendRedirect("HeaderAdmin.jsp");  // Chuyển hướng đến trang chính sau khi đăng nhập thành công
        } else {
            // Nếu đăng nhập không thành công
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}