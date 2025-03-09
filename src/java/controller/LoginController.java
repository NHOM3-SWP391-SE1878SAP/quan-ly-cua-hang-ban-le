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
            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            
            Role role = account.getRole();
            if (role != null) {
                String roleName = role.getRoleName();
                if ("Admin".equalsIgnoreCase(roleName)) {
                    response.sendRedirect("HeaderAdmin.jsp"); 
                } else if ("Employee".equalsIgnoreCase(roleName)) {
                    session.setAttribute("employee", dao.getEmployeeByAccountID(account.getId()));  // Lưu Employee vào session
                    response.sendRedirect("attendance.jsp");  
                } else {
                    response.sendRedirect("Login.jsp"); 
                }
            } else {
                response.sendRedirect("Login.jsp"); 
            }
        } else {
            request.setAttribute("errorMessage", "Invalid username or password");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}
