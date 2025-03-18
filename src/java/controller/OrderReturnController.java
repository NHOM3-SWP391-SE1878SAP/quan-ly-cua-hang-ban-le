package controller;

import entity.Order;
import entity.OrderDetail;
import entity.Product;
import entity.Return;
import entity.ReturnDetails;
import entity.Employee;
import model.DAOOrder;
import model.DAOOrderDetails;
import model.DAOReturn;
import model.DAOProduct;
import model.DAOReturnDetails;
import model.DAOAccount;
import model.DAOCustomer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/order-return")
public class OrderReturnController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OrderReturnController.class.getName());
    private static final int ORDERS_PER_PAGE = 7; // Số lượng đơn hàng trên mỗi trang

    private DAOOrder daoOrder;
    private DAOOrderDetails daoOrderDetails;
    private DAOProduct daoProduct;
    private DAOReturn daoReturn;
    private DAOReturnDetails daoReturnDetails;
    private DAOCustomer daoCustomer;
    

    @Override
    public void init() throws ServletException {
        super.init();
        daoOrder = new DAOOrder();
        daoOrderDetails = new DAOOrderDetails();
        daoProduct = new DAOProduct();
        daoReturn = new DAOReturn();
        daoReturnDetails = new DAOReturnDetails();
        daoCustomer = new DAOCustomer();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            if (action == null) {
                // Nếu không có action, mặc định hiển thị trang chọn đơn hàng
                showOrderSelectionPage(req, resp);
            } else {
                switch (action) {
                    case "viewOrder":
                        viewOrderDetails(req, resp);
                        break;
                    case "returnOrder":
                        showReturnOrderPage(req, resp);
                        break;
                    case "searchOrders":
                        searchOrders(req, resp);
                        break;
                    default:
                        showOrderSelectionPage(req, resp);
                        break;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing order return request", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi khi xử lý yêu cầu trả hàng: " + e.getMessage());
        }
    }

    /**
     * Hiển thị trang chọn đơn hàng với phân trang
     */
    private void showOrderSelectionPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy các tham số tìm kiếm và phân trang
        String pageStr = req.getParameter("page");
        String orderIdSearch = req.getParameter("orderId");
        String orderCodeSearch = req.getParameter("orderCode");
        String customerSearch = req.getParameter("customer");
        String productIdSearch = req.getParameter("productId");
        String productNameSearch = req.getParameter("productName");
        String fromDateStr = req.getParameter("fromDate");
        String toDateStr = req.getParameter("toDate");

        LOGGER.log(Level.INFO, "Showing order selection page with page={0}", pageStr);

        // Xử lý trang hiện tại
        int currentPage = processPageNumber(pageStr);

        // Lấy danh sách đơn hàng đã lọc
        List<Order> filteredOrders = getFilteredOrders(orderIdSearch, orderCodeSearch, customerSearch,
                productIdSearch, productNameSearch, fromDateStr, toDateStr);

        // Tính toán phân trang
        int totalOrders = filteredOrders.size();
        int totalPages = calculateTotalPages(totalOrders);

        // Điều chỉnh trang hiện tại nếu cần
        if (currentPage > totalPages && totalPages > 0) {
            currentPage = totalPages;
        }

        // Lấy danh sách đơn hàng cho trang hiện tại
        List<Order> ordersForCurrentPage = getOrdersForPage(filteredOrders, currentPage);

        // Khởi tạo đối tượng DAOAccount và DAOCustomer
        DAOAccount accountDAO = new DAOAccount();
        DAOCustomer customerDAO = new DAOCustomer();

        // Đặt các thuộc tính vào request
        setRequestAttributes(req, ordersForCurrentPage, currentPage, totalPages, totalOrders,
                orderIdSearch, orderCodeSearch, customerSearch, productIdSearch,
                productNameSearch, fromDateStr, toDateStr);

        // Thêm đối tượng accountDAO và customerDAO vào request
        req.setAttribute("accountDAO", accountDAO);
        req.setAttribute("customerDAO", customerDAO);

        // Trả về trang order_return_page.jsp
        req.getRequestDispatcher("/order_return_page.jsp").forward(req, resp);
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
     * Lấy danh sách đơn hàng đã lọc theo các tiêu chí tìm kiếm
     */
    private List<Order> getFilteredOrders(String orderIdSearch, String orderCodeSearch, String customerSearch,
            String productIdSearch, String productNameSearch, String fromDateStr, String toDateStr) {
        // Lấy tất cả đơn hàng
        List<Order> allOrders = daoOrder.getAllOrders();

        // TODO: Thêm logic lọc theo các tham số tìm kiếm
        // Ví dụ:
        List<Order> filteredOrders = new ArrayList<>(allOrders);

        if (orderIdSearch != null && !orderIdSearch.isEmpty()) {
            filteredOrders.removeIf(order -> !String.valueOf(order.getOrderID()).contains(orderIdSearch));
        }

        if (customerSearch != null && !customerSearch.isEmpty()) {
            // Giả sử có phương thức getCustomerName() trong Order
            filteredOrders.removeIf(order -> {
                String customerName = daoCustomer.getCustomerName(order.getCustomerID());
                return customerName == null || !customerName.toLowerCase().contains(customerSearch.toLowerCase());
            });
        }

        // Lọc theo ID sản phẩm trong đơn hàng (nếu có)
        if (productIdSearch != null && !productIdSearch.isEmpty()) {
            filteredOrders.removeIf(order -> {
                // Kiểm tra nếu đơn hàng có sản phẩm với ID này
                List<OrderDetail> orderDetails = daoOrderDetails.getOrderDetailsByOrderId(order.getOrderID());
                return orderDetails.stream().noneMatch(detail -> String.valueOf(detail.getProductID()).contains(productIdSearch));
            });
        }

        // Lọc theo tên sản phẩm trong đơn hàng (nếu có)
        if (productNameSearch != null && !productNameSearch.isEmpty()) {
            filteredOrders.removeIf(order -> {
                List<OrderDetail> orderDetails = daoOrderDetails.getOrderDetailsByOrderId(order.getOrderID());
                return orderDetails.stream().noneMatch(detail -> {
                    Product product = daoProduct.getProductById(detail.getProductID());
                    return product != null && product.getProductName().toLowerCase().contains(productNameSearch.toLowerCase());
                });
            });
        }

        // Lọc theo ngày từ
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            try {
                Date fromDate = new SimpleDateFormat("yyyy-MM-dd").parse(fromDateStr);
                filteredOrders.removeIf(order -> order.getOrderDate().before(fromDate));
            } catch (ParseException e) {
                LOGGER.log(Level.WARNING, "Invalid fromDate format: " + fromDateStr, e);
            }
        }

        // Lọc theo ngày đến
        if (toDateStr != null && !toDateStr.isEmpty()) {
            try {
                Date toDate = new SimpleDateFormat("yyyy-MM-dd").parse(toDateStr);
                filteredOrders.removeIf(order -> order.getOrderDate().after(toDate));
            } catch (ParseException e) {
                LOGGER.log(Level.WARNING, "Invalid toDate format: " + toDateStr, e);
            }
        }

        // Thêm các điều kiện lọc khác tương tự
        return filteredOrders;
    }

    /**
     * Tính tổng số trang dựa trên tổng số đơn hàng
     */
    private int calculateTotalPages(int totalOrders) {
        return (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);
    }

    /**
     * Lấy danh sách đơn hàng cho trang hiện tại
     */
    private List<Order> getOrdersForPage(List<Order> filteredOrders, int currentPage) {
        int totalOrders = filteredOrders.size();
        int startIndex = (currentPage - 1) * ORDERS_PER_PAGE;
        int endIndex = Math.min(startIndex + ORDERS_PER_PAGE, totalOrders);

        return startIndex < totalOrders
                ? filteredOrders.subList(startIndex, endIndex)
                : new ArrayList<>();
    }

    /**
     * Đặt các thuộc tính vào request
     */
    private void setRequestAttributes(HttpServletRequest req, List<Order> ordersForCurrentPage,
            int currentPage, int totalPages, int totalOrders,
            String orderIdSearch, String orderCodeSearch, String customerSearch,
            String productIdSearch, String productNameSearch,
            String fromDateStr, String toDateStr) {
        req.setAttribute("orders", ordersForCurrentPage);
        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("ordersPerPage", ORDERS_PER_PAGE);

        // Lưu các tham số tìm kiếm vào request để hiển thị lại trên form
        req.setAttribute("orderIdSearch", orderIdSearch);
        req.setAttribute("orderCodeSearch", orderCodeSearch);
        req.setAttribute("customerSearch", customerSearch);
        req.setAttribute("productIdSearch", productIdSearch);
        req.setAttribute("productNameSearch", productNameSearch);
        req.setAttribute("fromDate", fromDateStr);
        req.setAttribute("toDate", toDateStr);
    }

    /**
     * Hiển thị chi tiết đơn hàng
     */
    private void viewOrderDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderIdStr = req.getParameter("orderId");

        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = daoOrder.getOrderById(orderId);

                if (order != null) {
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/order_details.jsp").forward(req, resp);
                    return;
                }
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid order ID: {0}", orderIdStr);
            }
        }

        // Nếu không tìm thấy đơn hàng hoặc ID không hợp lệ, quay lại trang chọn đơn hàng
        resp.sendRedirect(req.getContextPath() + "/order-return");
    }

    /**
     * Hiển thị trang trả hàng với thông tin chi tiết đơn hàng
     */
    private void showReturnOrderPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderIdStr = req.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            LOGGER.log(Level.WARNING, "Order ID is missing for return order page");
            resp.sendRedirect(req.getContextPath() + "/order-return");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);

            // Lấy thông tin đơn hàng
            Order selectedOrder = daoOrder.getOrderById(orderId);

            if (selectedOrder == null) {
                LOGGER.log(Level.WARNING, "Order not found with ID: {0}", orderId);
                resp.sendRedirect(req.getContextPath() + "/order-return");
                return;
            }

            // Lấy danh sách chi tiết đơn hàng
            List<OrderDetail> orderDetails = daoOrderDetails.getOrderDetailsByOrderId(orderId);

            // Tạo map để lưu thông tin sản phẩm
            Map<Integer, Product> productMap = new HashMap<>();

            // Lấy thông tin sản phẩm cho mỗi chi tiết đơn hàng
            for (OrderDetail detail : orderDetails) {
                Product product = daoProduct.getProductById(detail.getProductID());
                if (product != null) {
                    productMap.put(detail.getProductID(), product);
                }
            }

            // Khởi tạo đối tượng DAOAccount và DAOCustomer
            DAOAccount accountDAO = new DAOAccount();
            DAOCustomer customerDAO = new DAOCustomer();

            // Đặt các thuộc tính vào request
            req.setAttribute("selectedOrder", selectedOrder);
            req.setAttribute("orderDetails", orderDetails);
            req.setAttribute("productMap", productMap);
            req.setAttribute("accountDAO", accountDAO);
            req.setAttribute("customerDAO", customerDAO);

            // Tính tổng tiền hàng
            int totalAmount = 0;
            for (OrderDetail detail : orderDetails) {
                totalAmount += detail.getPrice() * detail.getQuantity();
            }
            req.setAttribute("totalAmount", totalAmount);

            // Chuyển hướng đến trang trả hàng
            req.getRequestDispatcher("/order_Return.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid order ID format: {0}", orderIdStr);
            resp.sendRedirect(req.getContextPath() + "/order-return");
        }
    }

    /**
     * Tìm kiếm đơn hàng
     */
    private void searchOrders(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Chuyển hướng đến trang chọn đơn hàng với các tham số tìm kiếm
        showOrderSelectionPage(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            if (action == null) {
                // Nếu không có action, chuyển hướng về trang chọn đơn hàng
                resp.sendRedirect(req.getContextPath() + "/order-return");
                return;
            }

            switch (action) {
                case "selectOrder":
                    processSelectOrder(req, resp);
                    break;
                case "quickReturn":
                    processQuickReturn(req, resp);
                    break;
                case "submitReturn":
                    processSubmitReturn(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/order-return");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing order return POST request", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi khi xử lý yêu cầu trả hàng: " + e.getMessage());
        }
    }

    /**
     * Xử lý khi người dùng chọn một đơn hàng
     */
    private void processSelectOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String orderId = req.getParameter("orderId");

        if (orderId != null && !orderId.isEmpty()) {
            // Chuyển hướng đến trang trả hàng với đơn hàng đã chọn
            resp.sendRedirect(req.getContextPath() + "/order-return?action=returnOrder&orderId=" + orderId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/order-return");
        }
    }

    /**
     * Xử lý khi người dùng nhấn nút "Trả nhanh"
     */
    private void processQuickReturn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // TODO: Xử lý logic trả nhanh

        resp.sendRedirect(req.getContextPath() + "/order-return");
    }

    /**
     * Xử lý khi người dùng gửi form trả hàng
     */
    private void processSubmitReturn(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy thông tin cơ bản
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            float totalAmount = Float.parseFloat(req.getParameter("totalAmount"));

            // Validate đơn hàng tồn tại
            Order originalOrder = daoOrder.getOrderById(orderId);
            if (originalOrder == null) {
                LOGGER.warning("Order not found with ID: " + orderId);
                resp.sendRedirect(req.getContextPath() + "/order-return?error=order_not_found");
                return;
            }

            // Lấy danh sách chi tiết đơn hàng gốc và validate
            List<OrderDetail> originalDetails = daoOrderDetails.getOrderDetailsByOrderId(orderId);
            if (originalDetails.isEmpty()) {
                LOGGER.warning("No order details found for order ID: " + orderId);
                resp.sendRedirect(req.getContextPath() + "/order-return?error=no_order_details");
                return;
            }

            // Tạo đối tượng Return mới
            Return returnOrder = new Return();
            returnOrder.setReturnDate(new Date());
            returnOrder.setOrderId(orderId);
            returnOrder.setEmployeeId(getCurrentEmployee(req).getEmployeeID());
            returnOrder.setRefundAmount(totalAmount);

            // Lưu thông tin trả hàng và lấy ID
            int returnId = daoReturn.insertReturn(returnOrder);
            if (returnId <= 0) {
                LOGGER.severe("Failed to create return record");
                resp.sendRedirect(req.getContextPath() + "/order-return?error=create_failed");
                return;
            }

            // Xử lý chi tiết trả hàng
            List<ReturnDetails> returnDetailsList = new ArrayList<>();
            boolean hasReturnItems = false;
            float calculatedTotal = 0;

            for (OrderDetail originalDetail : originalDetails) {
                String quantityParam = "returnQuantity_" + originalDetail.getProductID();
                String quantityStr = req.getParameter(quantityParam);

                if (quantityStr != null && !quantityStr.isEmpty()) {
                    int returnQuantity = Integer.parseInt(quantityStr);

                    if (returnQuantity > 0) {
                        hasReturnItems = true;

                        // Validate số lượng trả
                        if (returnQuantity > originalDetail.getQuantity()) {
                            LOGGER.warning("Invalid return quantity for product " + originalDetail.getProductID());
                            daoReturn.deleteReturn(returnId); // Cleanup
                            resp.sendRedirect(req.getContextPath() + "/order-return?error=invalid_quantity");
                            return;
                        }

                        // Tính tổng tiền thực tế
                        calculatedTotal += returnQuantity * originalDetail.getPrice();

                        // Tạo chi tiết trả hàng
                        ReturnDetails returnDetails = new ReturnDetails();
                        returnDetails.setReturnId(returnId);
                        returnDetails.setOrderDetailsId(originalDetail.getOrderDetailID());
                        returnDetails.setQuantity(returnQuantity);

                        returnDetailsList.add(returnDetails);
                    }
                }
            }

            // Lưu chi tiết trả hàng
            boolean success = daoReturnDetails.insertReturnDetails(returnDetailsList);
            if (!success) {
                LOGGER.severe("Failed to save return details");
                daoReturn.deleteReturn(returnId);
                resp.sendRedirect(req.getContextPath() + "/order-return?error=save_failed");
                return;
            }

            // Chuyển hướng đến trang thành công
            resp.sendRedirect(req.getContextPath() + "/order-return?action=returnSuccess&returnId=" + returnId);

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid number format in return form", e);
            resp.sendRedirect(req.getContextPath() + "/order-return?error=invalid_format");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing return submission", e);
            resp.sendRedirect(req.getContextPath() + "/order-return?error=system_error");
        }
    }

    /**
     * Lấy thông tin nhân viên hiện tại từ session
     */
    private Employee getCurrentEmployee(HttpServletRequest req) {
        // TODO: Implement logic to get current employee from session
        // Temporary return dummy employee
        Employee employee = new Employee();
        employee.setEmployeeID(1); // Set appropriate employee ID
        return employee;
    }
}
