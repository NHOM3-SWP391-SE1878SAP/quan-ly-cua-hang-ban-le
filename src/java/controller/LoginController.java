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
import entity.Role;

/**
 * Servlet xử lý đăng nhập người dùng với phân quyền Admin và Employee.
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
            
            // Phân quyền dựa trên Role
            Role role = account.getRole();
            if (role != null) {
                String roleName = role.getRoleName();
                if ("Admin".equalsIgnoreCase(roleName)) {
                    response.sendRedirect("admin-dashboard.jsp");  // Điều hướng đến trang Admin
                } else if ("Employee".equalsIgnoreCase(roleName)) {
                    response.sendRedirect("ProductController");  // Điều hướng đến trang Employee
                } else {
                    response.sendRedirect("home.jsp");  // Mặc định nếu không có role cụ thể
                }
            } else {
                response.sendRedirect("home.jsp"); // Nếu không có role, về trang chủ
            }
        } else {
            // Nếu đăng nhập thất bại
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}
