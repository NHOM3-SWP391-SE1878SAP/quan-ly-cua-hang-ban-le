package controller;

import model.VoucherDAO;
import database.DatabaseConnection;
import entity.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/VoucherServlet"})
public class VoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    public VoucherServlet() {
        Connection conn = new DatabaseConnection().getConnection();
        this.voucherDAO = new VoucherDAO(conn);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String keyword = request.getParameter("search");

        int page = 1;
        int recordsPerPage = 10;

        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        paginateVouchers(request, keyword, page, recordsPerPage);
        request.getRequestDispatcher("vouchers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int page = 1;
        int recordsPerPage = 10;
        HttpSession session = request.getSession();

        try {
            if ("add".equals(action)) {
                // Đọc các tham số và xử lý số
                String minOrderParam = request.getParameter("minOrder").replaceAll("[.,]", "");
                int minOrder = Integer.parseInt(minOrderParam);
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                String maxValueParam = request.getParameter("maxValue").replaceAll("[.,]", "");
                int maxValue = Integer.parseInt(maxValueParam);
                Date startDate = parseDate(request.getParameter("startDate"));
                Date endDate = parseDate(request.getParameter("endDate"));
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                // Kiểm tra hợp lệ
                if (startDate.after(endDate)) {
                    session.setAttribute("message", "❌ Ngày bắt đầu phải trước ngày kết thúc!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                } else if (minOrder < 1 || discountRate < 1 || maxValue < 1 || usageLimit < 0) {
                    session.setAttribute("message", "❌ Giá trị phải lớn hơn 0!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                }

                // Tạo voucher mới (không cần code, DAO tự sinh)
                Voucher voucher = new Voucher(0,"", minOrder, discountRate, maxValue, usageLimit, 0, status, startDate, endDate);
                voucherDAO.addVoucher(voucher);
                session.setAttribute("message", "✅ Thêm voucher thành công!");

            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String code = request.getParameter("code");
                String minOrderParam = request.getParameter("minOrder").replaceAll("[.,]", "");
                int minOrder = Integer.parseInt(minOrderParam);
                int discountRate = Integer.parseInt(request.getParameter("discountRate"));
                String maxValueParam = request.getParameter("maxValue").replaceAll("[.,]", "");
                int maxValue = Integer.parseInt(maxValueParam);
                Date startDate = parseDate(request.getParameter("startDate"));
                Date endDate = parseDate(request.getParameter("endDate"));
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                int usageCount = Integer.parseInt(request.getParameter("usageCount"));
                boolean status = Boolean.parseBoolean(request.getParameter("status"));

                // Kiểm tra mã trùng
                if (voucherDAO.isCodeExistsForOtherVoucher(code, id)) {
                    session.setAttribute("message", "❌ Mã voucher đã tồn tại!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                }

                // Kiểm tra ngày
                if (startDate.after(endDate)) {
                    session.setAttribute("message", "❌ Ngày bắt đầu phải trước ngày kết thúc!");
                    response.sendRedirect("VoucherServlet?page=1");
                    return;
                }

                // Cập nhật voucher
                Voucher voucher = new Voucher(id, code, minOrder, discountRate, maxValue, usageLimit, usageCount, status, startDate, endDate);
                voucherDAO.updateVoucher(voucher);
                session.setAttribute("message", "✅ Cập nhật voucher thành công!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                voucherDAO.deleteVoucher(id);
                session.setAttribute("message", "🗑️ Đã xóa voucher!");
            }

            paginateVouchers(request, null, page, recordsPerPage);

        } catch (NumberFormatException e) {
            session.setAttribute("message", "❌ Sai định dạng số: " + e.getMessage());
        } catch (ParseException e) {
            session.setAttribute("message", "❌ Sai định dạng ngày (yyyy-MM-dd)!");
        } catch (Exception e) {
            session.setAttribute("message", "❌ Lỗi: " + e.getMessage());
        }

        response.sendRedirect("VoucherServlet?page=1");
    }

    private void paginateVouchers(HttpServletRequest request, String keyword, int page, int recordsPerPage) {
        List<Voucher> vouchers;
        int totalRecords;

        if (keyword == null || keyword.trim().isEmpty()) {
            totalRecords = voucherDAO.getTotalVoucherCount();
            vouchers = voucherDAO.getVouchersByPage(page, recordsPerPage);
        } else {
            vouchers = voucherDAO.searchVouchers(keyword);
            totalRecords = vouchers.size();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        request.setAttribute("vouchers", vouchers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
    }

    private Date parseDate(String dateString) throws ParseException {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date parsedDate = format.parse(dateString);
        return new Date(parsedDate.getTime());
    }
}