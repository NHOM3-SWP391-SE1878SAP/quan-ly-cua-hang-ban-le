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
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                // Lấy dữ liệu từ form
                String code = request.getParameter("code");
                int minOrder = Integer.parseInt(request.getParameter("minOrder"));
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                int maxValue = Integer.parseInt(request.getParameter("maxValue"));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                // Kiểm tra ngày hợp lệ
                if (startDate.isAfter(endDate)) {
                    session.setAttribute("message", "Lỗi: Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    response.sendRedirect("vouchers.jsp");
                    return;
                } else if (minOrder < 1 || discountRate < 1 || maxValue < 1) {
                    session.setAttribute("message", "❌ Lỗi: Giá trị phải lớn hơn hoặc bằng 1!");
                    response.sendRedirect("vouchers.jsp");
                    return;
                }

                Voucher voucher = new Voucher(code, minOrder, discountRate, maxValue, startDate, endDate);
                voucherDAO.addVoucher(voucher);
                session.setAttribute("message", "✅ Thêm voucher thành công!");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                int minOrder = Integer.parseInt(request.getParameter("minOrder"));
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                int maxValue = Integer.parseInt(request.getParameter("maxValue"));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                // Kiểm tra ngày hợp lệ
                if (startDate.isAfter(endDate)) {
                    session.setAttribute("message", "Lỗi: Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    response.sendRedirect("vouchers.jsp");
                    return;
                }else if (minOrder < 1 || discountRate < 1 || maxValue < 1) {
                    session.setAttribute("message", "❌ Lỗi: Giá trị phải lớn hơn hoặc bằng 1!");
                    response.sendRedirect("vouchers.jsp");
                    return;
                }

                Voucher voucher = new Voucher(id, code, minOrder, discountRate, maxValue, startDate, endDate);
                voucherDAO.updateVoucher(voucher);
                session.setAttribute("message", "✅ Cập nhật voucher thành công!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                voucherDAO.deleteVoucher(id);
                session.setAttribute("message", "🗑️ Xóa voucher thành công!");
            }

            // Cập nhật danh sách voucher
            session.setAttribute("vouchers", voucherDAO.getAllVouchers());
        } catch (Exception e) {
            session.setAttribute("message", "❌ Lỗi xử lý dữ liệu: " + e.getMessage());
        }

        response.sendRedirect("vouchers.jsp");
    }
}
