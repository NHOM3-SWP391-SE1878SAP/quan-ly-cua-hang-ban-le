/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import entity.Account;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOAccount;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ChangePasswordController", urlPatterns = {"/change-password"})

public class ChangePasswordController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    HttpSession session = request.getSession();
    Account account = (Account) session.getAttribute("account");
    
    if (account == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
    
    String oldPassword = request.getParameter("oldPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    
    DAOAccount dao = new DAOAccount();
    String errorMessage = null;
    
    // Validate input
    if (newPassword == null || newPassword.isEmpty()) {
        errorMessage = "Vui lòng nhập mật khẩu mới";
    } else if (!newPassword.equals(confirmPassword)) {
        errorMessage = "Mật khẩu mới không khớp";
    } else if (newPassword.length() < 8) {
        errorMessage = "Mật khẩu phải có ít nhất 8 ký tự";
    } else if (!newPassword.matches(".*[A-Z].*")) {
        errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ hoa";
    } else if (!newPassword.matches(".*[a-z].*")) {
        errorMessage = "Mật khẩu phải chứa ít nhất 1 chữ thường";
    } else if (!newPassword.matches(".*\\d.*")) {
        errorMessage = "Mật khẩu phải chứa ít nhất 1 số";
    } else if (!newPassword.matches(".*[@$!%*?&].*")) {
        errorMessage = "Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (@$!%*?&)";
    } else if (oldPassword == null || oldPassword.isEmpty()) {
        errorMessage = "Vui lòng nhập mật khẩu cũ";
    } else {
        Account currentAccount = dao.checkLogin1(account.getUserName(), oldPassword);
        if (currentAccount == null) {
            errorMessage = "Mật khẩu cũ không đúng";
        } else {
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            boolean success = dao.updatePassword(account.getId(), hashedPassword);
            
            if (success) {
                session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
                account.setPassword(hashedPassword);
                session.setAttribute("account", account);
                response.sendRedirect("SalesReport.jsp");
                return;
            } else {
                errorMessage = "Lỗi hệ thống, vui lòng thử lại";
            }
        }
    }
    
    if (errorMessage != null) {
        session.setAttribute("errorMessage", errorMessage);
    }
    response.sendRedirect("change-password.jsp");
}
}