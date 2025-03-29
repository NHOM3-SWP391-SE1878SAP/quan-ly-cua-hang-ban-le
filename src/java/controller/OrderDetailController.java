package controller;

import entity.Product;
import entity.ReportOrderProduct;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import model.DAOOrderDetails;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/OrderDetailControllerURL"})
public class OrderDetailController extends HttpServlet {

    DAOOrderDetails dao = new DAOOrderDetails();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String service = request.getParameter("service");

        if (service == null) {
            service = "listAll";
        }

        switch (service) {
            case "reportProduct":
                getReportProduct(request, response);
                break;
            default:
                response.sendRedirect("ReportOrderProducts.jsp");
        }
    }

    private Date parseDate(String dateStr) throws ParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null; // hoặc trả về ngày mặc định
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.parse(dateStr);
    }

    private String getParameterSafe(HttpServletRequest request, String paramName) {
        String paramValue = request.getParameter(paramName);
        return (paramValue != null) ? paramValue : "";
    }

    private void getReportProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String fromDateStr = getParameterSafe(request, "fromDate");
            String toDateStr = getParameterSafe(request, "toDate");

            // Nếu không có ngày thì mặc định là 30 ngày gần nhất
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fromDate;
            Date toDate;

            if (fromDateStr.isEmpty()) {
                Calendar cal = Calendar.getInstance();
                toDate = new Date(); // Ngày hiện tại
                cal.add(Calendar.DAY_OF_MONTH, -30); // 30 ngày trước
                fromDate = cal.getTime();
            } else {
                fromDate = sdf.parse(fromDateStr);
                toDate = toDateStr.isEmpty() ? new Date() : sdf.parse(toDateStr);
            }

            // Đảm bảo toDate không nhỏ hơn fromDate
            if (toDate.before(fromDate)) {
                toDate = fromDate;
            }

            Vector<ReportOrderProduct> report = dao.getTop5ProductsByRevenue(fromDate, toDate);

            // Format lại để hiển thị trong form
            request.setAttribute("report", report);
            request.setAttribute("fromDate", sdf.format(fromDate));
            request.setAttribute("toDate", sdf.format(toDate));

            RequestDispatcher dispatcher = request.getRequestDispatcher("ReportOrderProducts.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi khi tạo báo cáo: " + e.getMessage());
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
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>


}
