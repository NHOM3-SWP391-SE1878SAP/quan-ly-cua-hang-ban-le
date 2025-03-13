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
        HttpSession session = request.getSession();
        String keyword = request.getParameter("search");

        int page = 1; // Trang mặc định là 1
        int recordsPerPage = 10; // Hiển thị 10 vouchers mỗi trang

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1; // Nếu lỗi, quay về trang đầu
            }
        }

        // Gọi hàm phân trang
        paginateVouchers(request, keyword, page, recordsPerPage);

        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }

   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int page = 1; // Luôn lấy trang đầu tiên sau khi thêm/sửa/xóa
        int recordsPerPage = 10; // Mỗi trang có 10 vouchers
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                String code = request.getParameter("code");
                int minOrder = Integer.parseInt(request.getParameter("minOrder").replace(".", ""));
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                int maxValue = Integer.parseInt(request.getParameter("maxValue").replace(".", ""));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                if (startDate.isAfter(endDate)) {
                    session.setAttribute("message", "❌ Lỗi: Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                } else if (minOrder < 1 || discountRate < 1 || maxValue < 1) {
                    session.setAttribute("message", "❌ Lỗi: Giá trị phải lớn hơn hoặc bằng 1!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                }

                Voucher voucher = new Voucher(code, minOrder, discountRate, maxValue, startDate, endDate);
                voucherDAO.addVoucher(voucher);
                session.setAttribute("message", "✅ Thêm voucher thành công!");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                int minOrder = Integer.parseInt(request.getParameter("minOrder").replace(".", ""));
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                int maxValue = Integer.parseInt(request.getParameter("maxValue").replace(".", ""));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));

                if (startDate.isAfter(endDate)) {
                    session.setAttribute("message", "❌ Lỗi: Ngày bắt đầu phải nhỏ hơn ngày kết thúc!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                } else if (minOrder < 1 || discountRate < 1 || maxValue < 1) {
                    session.setAttribute("message", "❌ Lỗi: Giá trị phải lớn hơn hoặc bằng 1!");
                    response.sendRedirect("VoucherServlet?page=1");
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

            // ✅ Cập nhật danh sách voucher ngay sau CRUD
            paginateVouchers(request, null, page, recordsPerPage);

        } catch (Exception e) {
            session.setAttribute("message", "❌ Lỗi xử lý dữ liệu: " + e.getMessage());
        }

        response.sendRedirect("VoucherServlet?page=1"); // Điều hướng về trang đầu tiên
    }

    private void paginateVouchers(HttpServletRequest request, String keyword, int page, int recordsPerPage) {
        List<Voucher> vouchers;
        int totalRecords;

        if (keyword == null || keyword.trim().isEmpty()) {
            totalRecords = voucherDAO.getTotalVoucherCount(); // Tổng số vouchers
            vouchers = voucherDAO.getVouchersByPage(page, recordsPerPage); // Lấy dữ liệu theo trang
        } else {
            vouchers = voucherDAO.searchVouchers(keyword);
            totalRecords = vouchers.size();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
    }
}
