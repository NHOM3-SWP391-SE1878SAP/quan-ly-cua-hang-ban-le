package controller;

import entity.*;
import model.DAOOrder;
import model.DAOOrderDetails;
import model.DAOReturn;
import model.DAOReturnDetails;
import model.DAOAccount;
import model.DAOCustomer;
import model.DAOVoucher;
import model.DAOProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderController", urlPatterns = { "/order" })
public class OrderController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReportController.class.getName());
    private static final int REPORTS_PER_PAGE = 10; // Số lượng báo cáo trên mỗi trang

    private DAOOrder daoOrder;
    private DAOOrderDetails daoOrderDetails;
    private DAOReturn daoReturn;
    private DAOReturnDetails daoReturnDetails;
    private DAOAccount daoAccount;
    private DAOCustomer daoCustomer;
    private DAOVoucher daoVoucher;
    private DAOProduct daoProduct;

    @Override
    public void init() throws ServletException {
        super.init();
        daoOrder = new DAOOrder();
        daoOrderDetails = new DAOOrderDetails();
        daoReturn = new DAOReturn();
        daoReturnDetails = new DAOReturnDetails();
        daoAccount = new DAOAccount();
        daoCustomer = new DAOCustomer();
        daoVoucher = new DAOVoucher();
        daoProduct = new DAOProduct();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            
            // Xử lý action xem chi tiết
            if ("viewDetails".equals(action)) {
                String type = request.getParameter("type");
                int id = Integer.parseInt(request.getParameter("id"));
                
                // Xử lý chi tiết đơn hàng
                if ("SALE".equals(type)) {
                    viewOrderDetails(request, response, id);
                    return;
                } else if ("RETURN".equals(type)) {
                    // Xử lý chi tiết đơn trả hàng
                    viewReturnDetails(request, response, id);
                    return;
                }
            }
            
            // Xử lý báo cáo thông thường
            String period = request.getParameter("period");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");
            String orderIdSearch = request.getParameter("orderId");
            String customerSearch = request.getParameter("customer");
            String employeeSearch = request.getParameter("employee");
            String orderType = request.getParameter("orderType");
            String pageStr = request.getParameter("page");
            
            // Xử lý số trang
            int currentPage = processPageNumber(pageStr);
            
            // Lấy khoảng thời gian
            Date[] dateRange = getDateRange(period, fromDateStr, toDateStr);
            Date fromDate = dateRange[0];
            Date toDate = dateRange[1];
            
            // Lấy danh sách báo cáo đã lọc
            List<Map<String, Object>> reportItems = getFilteredReportItems(
                    fromDate, toDate, orderType, orderIdSearch, customerSearch, employeeSearch, request);
            
            // Tính toán phân trang
            int totalItems = reportItems.size();
            int totalPages = calculateTotalPages(totalItems);
            
            // Lấy danh sách báo cáo cho trang hiện tại
            List<Map<String, Object>> itemsForCurrentPage = getItemsForPage(reportItems, currentPage);
            
            // Tính toán tổng doanh thu, số đơn bán và số đơn trả
            float totalRevenue = 0;
            int totalSales = 0;
            int totalReturns = 0;
            
            for (Map<String, Object> item : reportItems) {
                String type = (String) item.get("orderType");
                Number amount = (Number) item.get("totalAmount");
                float value = amount != null ? amount.floatValue() : 0;
                
                if ("SALE".equals(type)) {
                    totalRevenue += value;
                    totalSales++;
                } else if ("RETURN".equals(type)) {
                    totalRevenue -= value;
                    totalReturns++;
                }
            }
            
            // Xây dựng chuỗi tham số tìm kiếm để giữ lại khi phân trang
            StringBuilder searchParams = new StringBuilder();
            if (period != null && !period.isEmpty()) {
                searchParams.append("&period=").append(period);
            }
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                searchParams.append("&fromDate=").append(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                searchParams.append("&toDate=").append(toDateStr);
            }
            if (orderIdSearch != null && !orderIdSearch.isEmpty()) {
                searchParams.append("&orderId=").append(orderIdSearch);
            }
            if (customerSearch != null && !customerSearch.isEmpty()) {
                searchParams.append("&customer=").append(customerSearch);
            }
            if (employeeSearch != null && !employeeSearch.isEmpty()) {
                searchParams.append("&employee=").append(employeeSearch);
            }
            if (orderType != null && !orderType.isEmpty()) {
                searchParams.append("&orderType=").append(orderType);
            }
            
            // Đặt các thuộc tính vào request
            request.setAttribute("orders", itemsForCurrentPage);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("totalReturns", totalReturns);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("searchParams", searchParams.toString());
            request.setAttribute("pageSize", REPORTS_PER_PAGE);
            request.setAttribute("accountDAO", daoAccount);
            request.setAttribute("voucherDAO", daoVoucher);
            
            // Chuyển hướng đến trang báo cáo
            request.getRequestDispatcher("/OrdersManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing report request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Xem chi tiết đơn hàng
     */
    private void viewOrderDetails(HttpServletRequest request, HttpServletResponse response, int orderId) 
            throws ServletException, IOException {
        try {
            // Lấy thông tin đơn hàng
            Order order = daoOrder.getOrderById(orderId);
            if (order == null) {
                response.sendRedirect("order?error=OrderNotFound");
                return;
            }
            
            // Lấy chi tiết đơn hàng
            List<OrderDetail> orderDetails = daoOrderDetails.getOrderDetailsByOrderId(orderId);
            
            // Lấy thông tin khách hàng
            Customer customer = daoCustomer.getCustomerById(order.getCustomerID());
            
            // Lấy thông tin nhân viên
            Employee employee = null;
            if (order.getEmployeeID() > 0) {
                employee = daoAccount.getEmployeeByID(order.getEmployeeID());
            }
            
            // Lấy thông tin voucher nếu có
            Voucher voucher = null;
            if (order.getVoucherID() != null && order.getVoucherID() > 0) {
                voucher = daoVoucher.getVoucherById(order.getVoucherID());
            }
            
            // Đặt các thuộc tính vào request
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("customer", customer);
            request.setAttribute("employee", employee);
            request.setAttribute("voucher", voucher);
            request.setAttribute("detailType", "SALE");
            request.setAttribute("daoProduct", daoProduct);
            
            // Chuyển hướng đến trang chi tiết
            request.getRequestDispatcher("/OrderDetailsManagement.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing order details", e);
            response.sendRedirect("report?error=ErrorViewingOrderDetails");
        }
    }

    /**
     * Xem chi tiết đơn trả hàng
     */
    private void viewReturnDetails(HttpServletRequest request, HttpServletResponse response, int returnId) 
            throws ServletException, IOException {
        try {
            // Lấy thông tin đơn trả hàng
            Return returnOrder = daoReturn.getReturnById(returnId);
            if (returnOrder == null) {
                response.sendRedirect("order?error=ReturnNotFound");
                return;
            }
            
            // Lấy chi tiết đơn trả hàng
            List<ReturnDetails> returnDetails = daoReturnDetails.getReturnDetailsByReturnId(returnId);
            
            // Lấy thông tin đơn hàng gốc
            Order originalOrder = daoOrder.getOrderById(returnOrder.getOrderId());
            
            // Lấy thông tin khách hàng từ đơn hàng gốc
            Customer customer = null;
            if (originalOrder != null) {
                customer = daoCustomer.getCustomerById(originalOrder.getCustomerID());
            }
            
            // Lấy thông tin nhân viên
            Employee employee = null;
            if (returnOrder.getEmployeeId() > 0) {
                employee = daoAccount.getEmployeeByID(returnOrder.getEmployeeId());
            }
            
            // Đặt các thuộc tính vào request
            request.setAttribute("returnOrder", returnOrder);
            request.setAttribute("returnDetails", returnDetails);
            request.setAttribute("originalOrder", originalOrder);
            request.setAttribute("customer", customer);
            request.setAttribute("employee", employee);
            request.setAttribute("detailType", "RETURN");
            request.setAttribute("daoProduct", daoProduct);
            request.setAttribute("daoOrderDetails", daoOrderDetails);
            
            // Chuyển hướng đến trang chi tiết
            request.getRequestDispatcher("/OrderDetailsManagement.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error viewing return details", e);
            response.sendRedirect("report?error=ErrorViewingReturnDetails");
        }
    }

    /**
     * Xử lý số trang từ tham số request
     */
    private int processPageNumber(String pageStr) {
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid page number: {0}", pageStr);
            }
        }
        return currentPage;
    }

    /**
     * Lấy khoảng thời gian dựa trên period hoặc fromDate/toDate
     */
    private Date[] getDateRange(String period, String fromDateStr, String toDateStr) {
        Date fromDate = null;
        Date toDate = new Date(); // Mặc định đến ngày hiện tại
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        
        try {
            if (period != null && !period.isEmpty()) {
                switch (period) {
                    case "day":
                        // Hôm nay
                        cal.set(Calendar.HOUR_OF_DAY, 0);
                        cal.set(Calendar.MINUTE, 0);
                        cal.set(Calendar.SECOND, 0);
                        cal.set(Calendar.MILLISECOND, 0);
                        fromDate = cal.getTime();
                        break;
                    case "week":
                        // Tuần này
                        cal.set(Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek());
                        cal.set(Calendar.HOUR_OF_DAY, 0);
                        cal.set(Calendar.MINUTE, 0);
                        cal.set(Calendar.SECOND, 0);
                        cal.set(Calendar.MILLISECOND, 0);
                        fromDate = cal.getTime();
                        break;
                    case "month":
                        // Tháng này
                        cal.set(Calendar.DAY_OF_MONTH, 1);
                        cal.set(Calendar.HOUR_OF_DAY, 0);
                        cal.set(Calendar.MINUTE, 0);
                        cal.set(Calendar.SECOND, 0);
                        cal.set(Calendar.MILLISECOND, 0);
                        fromDate = cal.getTime();
                        break;
                    case "year":
                        // Năm nay
                        cal.set(Calendar.DAY_OF_YEAR, 1);
                        cal.set(Calendar.HOUR_OF_DAY, 0);
                        cal.set(Calendar.MINUTE, 0);
                        cal.set(Calendar.SECOND, 0);
                        cal.set(Calendar.MILLISECOND, 0);
                        fromDate = cal.getTime();
                        break;
                    case "all":
                    default:
                        // Tất cả (không giới hạn thời gian)
                        fromDate = null;
                        break;
                }
            } else if (fromDateStr != null && !fromDateStr.isEmpty()) {
                // Sử dụng khoảng thời gian từ form
                fromDate = sdf.parse(fromDateStr);
                
                if (toDateStr != null && !toDateStr.isEmpty()) {
                    toDate = sdf.parse(toDateStr);
                    // Đặt thời gian kết thúc là cuối ngày
                    cal.setTime(toDate);
                    cal.set(Calendar.HOUR_OF_DAY, 23);
                    cal.set(Calendar.MINUTE, 59);
                    cal.set(Calendar.SECOND, 59);
                    cal.set(Calendar.MILLISECOND, 999);
                    toDate = cal.getTime();
                }
            }
        } catch (ParseException e) {
            LOGGER.log(Level.WARNING, "Error parsing date: {0}", e.getMessage());
        }
        
        return new Date[] { fromDate, toDate };
    }

    /**
     * Lấy danh sách báo cáo đã lọc
     */
    private List<Map<String, Object>> getFilteredReportItems(
            Date fromDate, Date toDate, String reportType, 
            String orderIdSearch, String customerSearch, String employeeSearch,
            HttpServletRequest request) {
        
        List<Map<String, Object>> result = new ArrayList<>();
        
        try {
            // Lấy danh sách đơn hàng và đơn trả hàng
            List<Order> orders = daoOrder.getAllOrders();
            List<Return> returns = daoReturn.getAllReturns();
            
            // Lọc theo loại báo cáo
            if (reportType != null && !reportType.isEmpty()) {
                if ("SALE".equals(reportType)) {
                    // Chỉ giữ lại đơn bán hàng
                    returns = new ArrayList<>();
                } else if ("RETURN".equals(reportType)) {
                    // Chỉ giữ lại đơn trả hàng
                    orders = new ArrayList<>();
                }
            }
            
            // Lọc theo nhân viên nếu có
            if (employeeSearch != null && !employeeSearch.isEmpty()) {
                // Lọc đơn hàng
                List<Order> filteredOrders = new ArrayList<>();
                for (Order order : orders) {
                    Employee employee = daoAccount.getEmployeeByAccountID(order.getEmployeeID());
                    if (employee != null && 
                        employee.getEmployeeName().toLowerCase().contains(employeeSearch.toLowerCase())) {
                        filteredOrders.add(order);
                    }
                }
                orders = filteredOrders;
                
                // Lọc đơn trả hàng
                List<Return> filteredReturns = new ArrayList<>();
                for (Return returnOrder : returns) {
                    Employee employee = daoAccount.getEmployeeByAccountID(returnOrder.getEmployeeId());
                    if (employee != null && 
                        employee.getEmployeeName().toLowerCase().contains(employeeSearch.toLowerCase())) {
                        filteredReturns.add(returnOrder);
                    }
                }
                returns = filteredReturns;
            }
            
            // Lọc theo thời gian
            if (fromDate != null || toDate != null) {
                // Lọc đơn hàng theo thời gian
                List<Order> filteredOrders = new ArrayList<>();
                for (Order order : orders) {
                    Date orderDate = order.getOrderDate();
                    boolean includeOrder = true;
                    
                    if (fromDate != null && orderDate.before(fromDate)) {
                        includeOrder = false;
                    }
                    
                    if (toDate != null && orderDate.after(toDate)) {
                        includeOrder = false;
                    }
                    
                    if (includeOrder) {
                        filteredOrders.add(order);
                    }
                }
                orders = filteredOrders;
                
                // Lọc đơn trả hàng theo thời gian
                List<Return> filteredReturns = new ArrayList<>();
                for (Return returnOrder : returns) {
                    Date returnDate = returnOrder.getReturnDate();
                    boolean includeReturn = true;
                    
                    if (fromDate != null && returnDate.before(fromDate)) {
                        includeReturn = false;
                    }
                    
                    if (toDate != null && returnDate.after(toDate)) {
                        includeReturn = false;
                    }
                    
                    if (includeReturn) {
                        filteredReturns.add(returnOrder);
                    }
                }
                returns = filteredReturns;
            }
            
            // Lọc theo mã đơn hàng
            if (orderIdSearch != null && !orderIdSearch.isEmpty()) {
                // Lọc đơn hàng theo mã
                List<Order> filteredOrders = new ArrayList<>();
                for (Order order : orders) {
                    if (String.valueOf(order.getOrderID()).contains(orderIdSearch)) {
                        filteredOrders.add(order);
                    }
                }
                orders = filteredOrders;
                
                // Lọc đơn trả hàng theo mã đơn hàng gốc
                List<Return> filteredReturns = new ArrayList<>();
                for (Return returnOrder : returns) {
                    if (String.valueOf(returnOrder.getOrderId()).contains(orderIdSearch) ||
                        String.valueOf(returnOrder.getOrderId()).contains(orderIdSearch)) {
                        filteredReturns.add(returnOrder);
                    }
                }
                returns = filteredReturns;
            }
            
            // Lọc theo khách hàng
            if (customerSearch != null && !customerSearch.isEmpty()) {
                // Lọc đơn hàng theo khách hàng
                List<Order> filteredOrders = new ArrayList<>();
                for (Order order : orders) {
                    Customer customer = daoCustomer.getCustomerById(order.getCustomerID());
                    if (customer != null && 
                        (customer.getCustomerName().toLowerCase().contains(customerSearch.toLowerCase()) ||
                         customer.getPhone().contains(customerSearch))) {
                        filteredOrders.add(order);
                    }
                }
                orders = filteredOrders;
                
                // Lọc đơn trả hàng theo khách hàng của đơn hàng gốc
                List<Return> filteredReturns = new ArrayList<>();
                for (Return returnOrder : returns) {
                    Order originalOrder = daoOrder.getOrderById(returnOrder.getOrderId());
                    if (originalOrder != null) {
                        Customer customer = daoCustomer.getCustomerById(originalOrder.getCustomerID());
                        if (customer != null && 
                            (customer.getCustomerName().toLowerCase().contains(customerSearch.toLowerCase()) ||
                             customer.getPhone().contains(customerSearch))) {
                            filteredReturns.add(returnOrder);
                        }
                    }
                }
                returns = filteredReturns;
            }
            
            // Xử lý đơn hàng bán
            for (Order order : orders) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", order.getOrderID());
                item.put("date", order.getOrderDate());
                item.put("totalAmount", order.getTotalAmount());
                item.put("orderType", "SALE");
                
                // Đảm bảo employeeID không null trước khi thêm vào map
                if (order.getEmployeeID() > 0) {
                    item.put("employeeID", order.getEmployeeID());
                }
                
                // Add voucher ID if exists
                if (order.getVoucherID() != null) {
                    item.put("voucherId", order.getVoucherID());
                }
                
                // Lấy thông tin khách hàng
                Customer customer = daoCustomer.getCustomerById(order.getCustomerID());
                item.put("customerName", customer != null ? customer.getCustomerName() : "Khách Lẻ");
                
                result.add(item);
            }
            
            // Xử lý đơn trả hàng
            for (Return returnOrder : returns) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", returnOrder.getReturnID());
                item.put("date", returnOrder.getReturnDate());
                item.put("totalAmount", returnOrder.getRefundAmount());
                item.put("orderType", "RETURN");
                
                // Đảm bảo employeeID không null trước khi thêm vào map
                if (returnOrder.getEmployeeId() > 0) {
                    item.put("employeeID", returnOrder.getEmployeeId());
                }
                
                // Lấy thông tin khách hàng từ đơn hàng gốc
                Order originalOrder = daoOrder.getOrderById(returnOrder.getOrderId());
                Customer customer = originalOrder != null ? 
                    daoCustomer.getCustomerById(originalOrder.getCustomerID()) : null;
                item.put("customerName", customer != null ? customer.getCustomerName() : "Khách Lẻ");
                
                result.add(item);
            }
            
            // Sắp xếp danh sách theo thời gian giảm dần (mới nhất lên đầu)
            result.sort((a, b) -> {
                Date dateA = (Date) a.get("date");
                Date dateB = (Date) b.get("date");
                if (dateA == null) return 1;
                if (dateB == null) return -1;
                return dateB.compareTo(dateA); // Sắp xếp giảm dần
            });
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error filtering report items", e);
        }
        
        return result;
    }

    /**
     * Tính tổng số trang dựa trên tổng số mục và số mục trên mỗi trang
     */
    private int calculateTotalPages(int totalItems) {
        return (int) Math.ceil((double) totalItems / REPORTS_PER_PAGE);
    }

    /**
     * Lấy danh sách mục cho trang hiện tại
     */
    private List<Map<String, Object>> getItemsForPage(List<Map<String, Object>> allItems, int currentPage) {
        int startIndex = (currentPage - 1) * REPORTS_PER_PAGE;
        int endIndex = Math.min(startIndex + REPORTS_PER_PAGE, allItems.size());
        
        if (startIndex >= allItems.size()) {
            return new ArrayList<>();
        }
        
        return allItems.subList(startIndex, endIndex);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý các yêu cầu POST (nếu cần)
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Order Controller";
    }
}