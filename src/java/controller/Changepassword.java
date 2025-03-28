/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import model.DAOAccount;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Dell
 */
@WebServlet(name = "Changepassword", urlPatterns = {"/changepassword"})
public class Changepassword extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Changepassword2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Changepassword2 at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private static final String PASSWORD_PATTERN = "^(?=.*[A-Z])(?=.*\\d).{8,}$";

    private boolean isValidPassword(String password) {
        if (password == null) {
            return false;
        }
        Pattern pattern = Pattern.compile(PASSWORD_PATTERN);
        Matcher matcher = pattern.matcher(password);
        return matcher.matches();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPass = request.getParameter("newpassword");
        String confirmPass = request.getParameter("confirmpassword");

        HttpSession session = request.getSession();
         Integer userId = null;

        if (session.getAttribute("userId") != null) {
        try {
            userId = Integer.parseInt(session.getAttribute("userId").toString());  // Chuyển từ String sang Integer
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã người dùng không hợp lệ.");
            request.getRequestDispatcher("changepassword.jsp").forward(request, response);
            return;
        }
    }
    
    if (userId == null) {
        request.setAttribute("error", "Mã người dùng không hợp lệ.");
        request.getRequestDispatcher("changepassword.jsp").forward(request, response);
        return;
    }
//        try {
//            if (request.getAttribute("userId") != null) {
//
//            }
//        } catch (Exception e) {
//            response.sendRedirect("404_error.jsp");
//            System.out.println(e);
//        }

        //if (session.getAttribute("confirmchange") != null) {
        if (newPass == null || confirmPass == null || newPass.equals("") || confirmPass.equals("")) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("changepassword.jsp").forward(request, response);
        } else if (!newPass.equals(confirmPass)) {
            request.setAttribute("error", "Nhập lại mật khẩu không chính xác!");
            request.getRequestDispatcher("changepassword.jsp").forward(request, response);
        } else if (!isValidPassword(newPass)) {
            request.setAttribute("error", "Mật khẩu phải lớn hơn 8 kí tự, bao gồm hoa thường và số!");
            request.getRequestDispatcher("changepassword.jsp").forward(request, response);
        } else {
            DAOAccount acc = new DAOAccount();
                        String hashedPassword = BCrypt.hashpw(newPass, BCrypt.gensalt());

            acc.changePass(userId, hashedPassword);
            request.getSession().setAttribute("confirm", "Đổi mật khẩu thành công, vui lòng đăng nhập lại để tiếp tục!");
            session.removeAttribute("countotp");
            session.removeAttribute("confirmchange");
            session.removeAttribute("userId");
            response.sendRedirect("changepassword.jsp");
        }
        //} else {
        //   request.getRequestDispatcher("verifyemail.jsp").forward(request, response);
        //}//
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
