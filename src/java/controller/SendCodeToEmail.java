/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import entity.Account;
import model.EmailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import model.DAOAccount;
/**
 *
 * @author Dell
 */
@WebServlet(name="SendCodeToEmail", urlPatterns={"/sendcodetoemail"})
public class SendCodeToEmail extends HttpServlet {
   
     public static ConcurrentHashMap<String, String> otpHash = new ConcurrentHashMap<String, String>();
    private ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    public String getOtpById(String idOtp) {
        String otp = otpHash.get(idOtp);
        return otp;
    }

    public static void removeOtpCode(String idOtp) {
        otpHash.remove(idOtp);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SendCodeToEmail2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendCodeToEmail2 at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");


        HttpSession session = request.getSession();

        // check rỗng
        if (email == null || email.equals("") ) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.getRequestDispatcher("requestchangepass.jsp").forward(request, response);
        }

        DAOAccount dao = new DAOAccount();
        Account useremail = dao.getUserByEmail(email);


        int count = 0;
        session.setAttribute("countotp", count);
        // check email tồn tại
        if (useremail == null) {
            request.setAttribute("error", "Email không tồn tại");
            request.getRequestDispatcher("requestchangepass.jsp").forward(request, response);
        } else{
            int userid = useremail.getId();
            String otprequest = EmailDAO.generateRandomString();
            String otpId = EmailDAO.generateRandomString();
            //scheduler.schedule(() -> session.removeAttribute());
            //scheduler.schedule(() -> session.removeAttribute("otprequest"), 60, TimeUnit.SECONDS);


            otpHash.put(otpId, otprequest);
            
             session.setAttribute("userId", userid);
            session.setAttribute("email", email);
            session.setAttribute("idOtp", otpId);
            session.setAttribute("otprequest", otprequest);  // Lưu mã OTP
            session.setAttribute("countotp", 0); 
            EmailDAO.sendEmail(email, "Mã xác nhận đặt lại mật khẩu" + "", "Chào bạn, mã OTP xác thực tài khoản của bạn là: " + "<b>" + otprequest + "</b>" + ". Mã có giá trị trong 60s.");
            request.getRequestDispatcher("verifyemailrequest.jsp").forward(request, response);
        }
    }


    @Override
    public String getServletInfo() {
        return "Short description";
    }

   

}
