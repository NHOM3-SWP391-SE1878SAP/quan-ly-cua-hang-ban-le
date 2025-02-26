package controller;

import dao.VoucherDAO;
import database.DatabaseConnection;
import model.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class VoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    public VoucherServlet() {
        // ✅ Khởi tạo DAO ngay khi Servlet được tạo
        Connection conn = new DatabaseConnection().getConnection();
        this.voucherDAO = new VoucherDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(); // Lấy session
        String keyword = request.getParameter("search");
        List<Voucher> vouchers;

        // Nếu keyword không tồn tại hoặc bị rỗng → Lấy toàn bộ danh sách
        if (keyword == null || keyword.trim().isEmpty()) {
            vouchers = voucherDAO.getAllVouchers();
        } else {
            vouchers = voucherDAO.searchVouchers(keyword);
        }

        session.setAttribute("vouchers", vouchers); // Cập nhật danh sách vouchers vào session
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String code = request.getParameter("code");
            int minOrder = Integer.parseInt(request.getParameter("minOrder"));
            int discountRate = Integer.parseInt(request.getParameter("discountRate"));
            int maxValue = Integer.parseInt(request.getParameter("maxValue"));

            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");

            // ✅ Kiểm tra và chuyển đổi ngày một cách an toàn
            LocalDate startDate = startDateStr != null && !startDateStr.isEmpty() ? LocalDate.parse(startDateStr) : null;
            LocalDate endDate = endDateStr != null && !endDateStr.isEmpty() ? LocalDate.parse(endDateStr) : null;

            if (startDate == null || endDate == null) {
                request.setAttribute("error", "Start Date và End Date không được để trống.");
                request.getRequestDispatcher("vouchers.jsp").forward(request, response);
                return;
            }

            // Thêm voucher vào DB
            Voucher voucher = new Voucher(code, minOrder, discountRate, maxValue, startDate, endDate);
            voucherDAO.addVoucher(voucher);
        } else if ("update".equals(action)) {
            // Lấy dữ liệu từ form update
            int id = Integer.parseInt(request.getParameter("id"));
            String code = request.getParameter("code");
            int minOrder = Integer.parseInt(request.getParameter("minOrder"));
            int discountRate = Integer.parseInt(request.getParameter("discountRate"));
            int maxValue = Integer.parseInt(request.getParameter("maxValue"));

            // Kiểm tra nếu ngày bị null hoặc sai định dạng
            LocalDate startDate = null;
            LocalDate endDate = null;
            try {
                startDate = LocalDate.parse(request.getParameter("startDate"));
                endDate = LocalDate.parse(request.getParameter("endDate"));
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "❌ Lỗi khi cập nhật: Ngày không hợp lệ!");
                response.sendRedirect("vouchers.jsp");
                return;
            }

            // Cập nhật voucher
            Voucher voucher = new Voucher(id, code, minOrder, discountRate, maxValue, startDate, endDate);
            voucherDAO.updateVoucher(voucher);
            request.getSession().setAttribute("message", "✅ Cập nhật voucher thành công!");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            voucherDAO.deleteVoucher(id);
        }

        // Cập nhật danh sách voucher sau khi CRUD
        HttpSession session = request.getSession();
        session.setAttribute("vouchers", voucherDAO.getAllVouchers());

        response.sendRedirect("vouchers.jsp"); // Quay về trang JSP
    }
}
