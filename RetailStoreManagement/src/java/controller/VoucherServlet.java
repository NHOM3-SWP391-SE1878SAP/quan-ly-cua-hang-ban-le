package controller;

import dao.VoucherDAO;
import model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;


public class VoucherServlet extends HttpServlet {
    private VoucherDAO voucherDAO = new VoucherDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Voucher> vouchers = voucherDAO.getAllVouchers();
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            String uniqueCode = generateUniqueVoucherCode();
            double minOrder = Double.parseDouble(request.getParameter("minOrder"));
            float discountRate = Float.parseFloat(request.getParameter("discountRate"));
            double maxValue = Double.parseDouble(request.getParameter("maxValue"));
            LocalDateTime startDate = LocalDateTime.now();
            LocalDateTime endDate = LocalDateTime.now().plusDays(30);
            
            Voucher voucher = new Voucher(0, uniqueCode, minOrder, discountRate, maxValue, startDate, endDate);
            voucherDAO.addVoucher(voucher);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            voucherDAO.deleteVoucher(id);
        }
        response.sendRedirect("VoucherServlet");
    }

    private String generateUniqueVoucherCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code;
        Random rand = new Random();
        do {
            code = new StringBuilder();
            for (int i = 0; i < 10; i++) {
                code.append(chars.charAt(rand.nextInt(chars.length())));
            }
        } while (voucherDAO.checkIfCodeExists(code.toString())); // Kiểm tra trùng
        return code.toString();
    }
}
