package controller;

import model.VoucherDAO;
import database.DatabaseConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.Random;


public class GenerateVoucherCodeServlet extends HttpServlet {
    private VoucherDAO voucherDAO;

    public GenerateVoucherCodeServlet() {
        Connection conn = new DatabaseConnection().getConnection();
        this.voucherDAO = new VoucherDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uniqueCode = generateUniqueVoucherCode();
        response.setContentType("text/plain");
        response.getWriter().write(uniqueCode);
    }

    private String generateUniqueVoucherCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random = new Random();
        String code;

        do {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < 10; i++) {
                sb.append(chars.charAt(random.nextInt(chars.length())));
            }
            code = sb.toString();
        } while (voucherDAO.isCodeExists(code)); // Kiểm tra nếu mã đã tồn tại

        return code;
    }
}
