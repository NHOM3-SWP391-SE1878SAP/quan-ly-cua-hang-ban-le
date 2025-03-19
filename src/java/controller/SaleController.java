package controller;

import entity.Order;
import entity.OrderDetail;
import entity.Product;
import entity.Customer;
import entity.Employee;
import model.DAOOrder;
import model.DAOOrderDetails;
import model.DAOProduct;
import model.DAOCustomer;
import model.DAOAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;
import java.util.Map;
import jakarta.servlet.http.HttpSession;
import model.DAOPayment;
import model.DAOVoucher;
import entity.Voucher;
import java.util.HashMap;

/**
 * Controller for the sales page
 */
@WebServlet("/sale")
public class SaleController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SaleController.class.getName());
    private DAOProduct daoProduct;
    private DAOOrder daoOrder;
    private DAOOrderDetails daoOrderDetails;
    private DAOCustomer daoCustomer;
    private DAOAccount daoAccount;
    private DAOPayment daoPayment;
    private DAOVoucher daoVoucher;

    // Định nghĩa hằng số
    private static final Integer DEFAULT_CUSTOMER_ID = 1; // ID cho khách hàng mặc định
    private static final Integer GUEST_CUSTOMER_ID = null; // Khách lẻ không có ID

    @Override
    public void init() throws ServletException {
        super.init();
        daoProduct = new DAOProduct();
        daoOrder = new DAOOrder();
        daoOrderDetails = new DAOOrderDetails();
        daoCustomer = new DAOCustomer();
        daoAccount = new DAOAccount();
        daoPayment = new DAOPayment();
        daoVoucher = new DAOVoucher();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            // Handle AJAX search request
            if ("searchCustomers".equals(action)) {
                searchCustomers(req, resp);
                return;
            } // Thêm xử lý tìm kiếm sản phẩm
            else if ("searchProducts".equals(action)) {
                searchProducts(req, resp);
                return;
            }
            // Lấy tất cả sản phẩm từ database
            Vector<Product> products = daoProduct.getAllProducts("SELECT * FROM Products WHERE IsAvailable = 1 ORDER BY ProductName");
            // Đặt danh sách sản phẩm vào request attribute
            req.setAttribute("products", products);
            // Chuyển hướng đến trang sale.jsp
            req.getRequestDispatcher("/SaleManagement.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error retrieving products for sale page", e);
            // Không thể chuyển hướng sau khi đã forward, nên chỉ log lỗi
            // Nếu chưa forward, mới chuyển hướng đến trang lỗi
            if (!resp.isCommitted()) {
                resp.sendRedirect(req.getContextPath() + "/error.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Xử lý các hành động POST như thêm sản phẩm vào giỏ hàng, thanh toán, v.v.
        String action = req.getParameter("action");

        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/sale");
            return;
        }

        try {
            switch (action) {
                case "addToCart":
                    addToCart(req, resp);
                    break;
                case "prepareCheckout":
                    processCheckout(req, resp);
                    break;
                case "showPayment":
                    showPaymentPage(req, resp);
                    break;
                case "checkout":
                    processCheckout(req, resp);
                    break;
                case "applyDiscountAjax":
                    applyDiscountCodeAjax(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/sale");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi khi xử lý yêu cầu: " + e.getMessage());
        }
    }

    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    private void addToCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));

            // TODO: Thêm logic để thêm sản phẩm vào giỏ hàng (session)
            // Chuyển hướng trở lại trang bán hàng
            resp.sendRedirect(req.getContextPath() + "/sale");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid product ID or quantity", e);
            if (!resp.isCommitted()) {
                resp.sendRedirect(req.getContextPath() + "/sale");
            }
        }
    }

    /**
     * Hiển thị trang thanh toán với thông tin giỏ hàng và khách hàng
     */
    private void showPaymentPage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy thông tin từ request
            String cartItemsJson = req.getParameter("cartItems");
            String customerName = req.getParameter("customerName");
            String customerPhone = req.getParameter("customerPhone");
            String customerId = req.getParameter("customerId");

            // Lưu thông tin vào session
            HttpSession session = req.getSession();
            session.setAttribute("cartItemsJson", cartItemsJson);
            session.setAttribute("customerName", customerName);
            session.setAttribute("customerPhone", customerPhone);
            session.setAttribute("customerId", customerId);

            // Kiểm tra và xử lý tên khách hàng
            if (customerName == null || customerName.trim().isEmpty()) {
                // Nếu không có tên khách hàng, thử lấy từ database nếu có ID
                if (customerId != null && !customerId.trim().isEmpty() && !customerId.equals("0")) {
                    try {
                        int customerIdInt = Integer.parseInt(customerId);
                        Customer customer = daoCustomer.getCustomerById(customerIdInt);
                        if (customer != null) {
                            customerName = customer.getCustomerName();
                            customerPhone = customer.getPhone();
                        }
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid customer ID: " + customerId, e);
                    }
                }

                // Nếu vẫn không có tên khách hàng, đặt là "Khách lẻ"
                if (customerName == null || customerName.trim().isEmpty()) {
                    customerName = "Khách lẻ";
                }
            }

            // Parse JSON cart items
            List<Map<String, Object>> cartItems = new ArrayList<>();
            double totalAmount = 0;

            if (cartItemsJson != null && !cartItemsJson.isEmpty()) {
                try {
                    Gson gson = new Gson();
                    Type type = new TypeToken<List<Map<String, Object>>>() {
                    }.getType();
                    cartItems = gson.fromJson(cartItemsJson, type);

                    // Tính tổng tiền
                    for (Map<String, Object> item : cartItems) {
                        Object priceObj = item.get("price");
                        Object quantityObj = item.get("quantity");

                        double price = 0;
                        int quantity = 0;

                        if (priceObj instanceof Double) {
                            price = (Double) priceObj;
                        } else if (priceObj instanceof String) {
                            price = Double.parseDouble((String) priceObj);
                        } else if (priceObj instanceof Integer) {
                            price = (Integer) priceObj;
                        }

                        if (quantityObj instanceof Double) {
                            quantity = ((Double) quantityObj).intValue();
                        } else if (quantityObj instanceof String) {
                            quantity = Integer.parseInt((String) quantityObj);
                        } else if (quantityObj instanceof Integer) {
                            quantity = (Integer) quantityObj;
                        }

                        double itemTotal = price * quantity;
                        item.put("total", itemTotal);
                        totalAmount += itemTotal;
                    }
                } catch (JsonSyntaxException | NumberFormatException e) {
                    LOGGER.log(Level.SEVERE, "Error parsing cart items JSON", e);
                }
            }

            // Kiểm tra nếu giỏ hàng trống
            if (cartItems.isEmpty()) {
                req.setAttribute("errorMessage", "Giỏ hàng trống, không thể thanh toán");
                req.getRequestDispatcher("/SaleManagement.jsp").forward(req, resp);
                return;
            }

            // Đặt các thuộc tính vào request
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("cartItemsJson", cartItemsJson);  // Pass the JSON to the page
            req.setAttribute("totalAmount", totalAmount);
            req.setAttribute("customerId", customerId);
            req.setAttribute("customerName", customerName);
            req.setAttribute("customerPhone", customerPhone);
            req.setAttribute("discount", 0); // Mặc định không có giảm giá
            req.setAttribute("paymentMethods", daoPayment.getAllPaymentMethods());

            // Chuyển hướng đến trang thanh toán
            req.getRequestDispatcher("/PaymentManagement.jsp").forward(req, resp);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error showing payment page", e);
            req.setAttribute("errorMessage", "Lỗi hiển thị trang thanh toán: " + e.getMessage());
            req.getRequestDispatcher("/SaleManagement.jsp").forward(req, resp);
        }
    }

    /**
     * Xử lý thanh toán
     */
    private void processCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        try {
            // Lấy thông tin từ request hoặc session nếu không có
            String cartItemsJson = req.getParameter("cartItems");
            String customerName = req.getParameter("customerName");
            String customerPhone = req.getParameter("customerPhone");
            String customerId = req.getParameter("customerId");
            String paymentMethod = req.getParameter("paymentMethod");
            String totalStr = req.getParameter("total");
            String customerPaidStr = req.getParameter("customerPaid");
            String voucherCode = req.getParameter("discountCode");

            // Sử dụng dữ liệu từ session nếu request không có
            if (cartItemsJson == null || cartItemsJson.trim().isEmpty()) {
                cartItemsJson = (String) session.getAttribute("cartItemsJson");
            }
            if (customerName == null || customerName.trim().isEmpty()) {
                customerName = (String) session.getAttribute("customerName");
            }
            if (customerPhone == null || customerPhone.trim().isEmpty()) {
                customerPhone = (String) session.getAttribute("customerPhone");
            }
            if (customerId == null || customerId.trim().isEmpty()) {
                customerId = (String) session.getAttribute("customerId");
            }

            // Xử lý số tiền - sửa lỗi NumberFormatException
            double total = 0;
            double customerPaid = 0;

            try {
                // Xử lý chuỗi số có thể chứa dấu thập phân
                if (totalStr != null && !totalStr.isEmpty()) {
                    // Loại bỏ tất cả ký tự không phải số và dấu thập phân
                    totalStr = totalStr.replaceAll("[^0-9.]", "");
                    total = Double.parseDouble(totalStr);
                }

                if (customerPaidStr != null && !customerPaidStr.isEmpty()) {
                    // Loại bỏ tất cả ký tự không phải số và dấu thập phân
                    customerPaidStr = customerPaidStr.replaceAll("[^0-9.]", "");
                    customerPaid = Double.parseDouble(customerPaidStr);
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error parsing payment amounts", e);
                // Sử dụng giá trị mặc định nếu có lỗi
            }

            // Chuyển đổi sang int nếu cần
            int totalInt = (int) Math.round(total);
            int customerPaidInt = (int) Math.round(customerPaid);

            // Parse JSON cart items
            List<Map<String, Object>> orderItems = new ArrayList<>();
            if (cartItemsJson != null && !cartItemsJson.isEmpty()) {
                try {
                    Gson gson = new Gson();
                    Type type = new TypeToken<List<Map<String, Object>>>() {
                    }.getType();
                    orderItems = gson.fromJson(cartItemsJson, type);

                    for (int i = 0; i < orderItems.size(); i++) {
                        Map<String, Object> item = orderItems.get(i);
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error parsing cart items JSON", e);
                    throw new Exception("Lỗi xử lý dữ liệu giỏ hàng: " + e.getMessage());
                }
            }

            // Kiểm tra nếu giỏ hàng trống
            if (orderItems.isEmpty()) {
                req.setAttribute("errorMessage", "Giỏ hàng trống, không thể thanh toán");
                req.getRequestDispatcher("/SaleManagement.jsp").forward(req, resp);
                return;
            }
            int employeeId = 0; // Mặc định là 0 nếu không tìm thấy thông tin nhân viên
            if (employee != null) {
                employeeId = employee.getEmployeeID(); // Giả sử bạn đã có phương thức getId() trong đối tượng Employee
            }

//            int employeeId = 1; // Mặc định ID nhân viên là 11
            // Chuyển đổi customerId từ String sang Integer
            Integer customerIdInt = GUEST_CUSTOMER_ID; // Mặc định là khách lẻ
            if (customerId != null && !customerId.isEmpty() && !customerId.equals("0")) {
                try {
                    customerIdInt = Integer.parseInt(customerId);
                    // Kiểm tra xem customer có tồn tại không
                    Customer customer = daoCustomer.getCustomerById(customerIdInt);
                    if (customer == null) {
                        LOGGER.warning("Customer with ID " + customerIdInt + " not found. Using guest customer.");
                        customerIdInt = GUEST_CUSTOMER_ID; // Sử dụng khách lẻ nếu không tìm thấy
                    } else {
                        // Nếu tìm thấy customer, lấy thông tin cập nhật
                        customerName = customer.getCustomerName();
                        customerPhone = customer.getPhone();
                    }
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid customer ID format: " + customerId, e);
                    customerIdInt = GUEST_CUSTOMER_ID; // Sử dụng khách lẻ nếu ID không hợp lệ
                }
            }

            // Lấy thông tin voucher nếu có
            Integer voucherId = null; // Mặc định là null (không có voucher)

            if (voucherCode != null && !voucherCode.trim().isEmpty()) {
                try {
                    // Kiểm tra xem voucher có tồn tại không
                    Voucher voucher = daoVoucher.getVoucherByCode(voucherCode);
                    if (voucher == null) {
                        LOGGER.warning("Voucher with ID " + voucherCode + " not found. No voucher will be applied.");
                        voucherId = null;
                    } else {
                        voucherId = voucher.getId();
                        double discount = totalInt * voucher.getDiscountRate() / 100;
                        // Kiểm tra nếu tổng giảm giá vượt quá MaxValue
                        if (discount > voucher.getMaxValue()) {
                            discount = voucher.getMaxValue();  // Áp dụng MaxValue nếu giảm giá vượt quá
                        } // Áp dụng giảm giá vào tổng tiền
                        totalInt = totalInt - (int) discount;
//                        totalInt = totalInt - (int) (totalInt * voucher.getDiscountRate() / 100);
                    }

                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid voucher ID format: " + voucherCode, e);
                    // Nếu không parse được, để voucherId là null
                }
            }

            // Tạo đối tượng Order
            Order order = Order.builder()
                    .orderDate(new Date())
                    .totalAmount(totalInt)
                    .customerID(customerIdInt)
                    .employeeID(employeeId)
                    .paymentID(1)
                    .voucherID(voucherId) // Sử dụng voucherId đã xử lý
                    .build();

            // Thêm đơn hàng vào database và lấy ID
            int orderId = daoOrder.addOrderAndGetId(order);

            if (orderId <= 0) {
                throw new Exception("Cannot create oder: ");
            }

            // Xử lý từng sản phẩm trong giỏ hàng
            boolean allItemsProcessed = true;

            for (Map<String, Object> item : orderItems) {
                try {
                    // Lấy thông tin sản phẩm từ item - xử lý an toàn các kiểu dữ liệu
                    int productId = 0;
                    int price = 0;
                    int quantity = 0;
                    String productName = "";

                    // Xử lý productId
                    Object productIdObj = item.get("productId");
                    if (productIdObj instanceof Double) {
                        productId = ((Double) productIdObj).intValue();
                    } else if (productIdObj instanceof String) {
                        productId = Integer.parseInt((String) productIdObj);
                    } else if (productIdObj instanceof Integer) {
                        productId = (Integer) productIdObj;
                    }

                    // Xử lý productName
                    productName = (String) item.get("productName");

                    // Xử lý price
                    Object priceObj = item.get("price");
                    if (priceObj instanceof Double) {
                        price = ((Double) priceObj).intValue();
                    } else if (priceObj instanceof String) {
                        price = Integer.parseInt((String) priceObj);
                    } else if (priceObj instanceof Integer) {
                        price = (Integer) priceObj;
                    }

                    // Xử lý quantity
                    Object quantityObj = item.get("quantity");
                    if (quantityObj instanceof Double) {
                        quantity = ((Double) quantityObj).intValue();
                    } else if (quantityObj instanceof String) {
                        quantity = Integer.parseInt((String) quantityObj);
                    } else if (quantityObj instanceof Integer) {
                        quantity = (Integer) quantityObj;
                    }

                    // Kiểm tra tồn kho
                    Product product = daoProduct.getProductById(productId);
                    if (product == null || product.getId() <= 0) {
                        throw new Exception("Không tìm thấy sản phẩm với ID: " + productId);
                    }

                    // Tạo chi tiết đơn hàng
                    OrderDetail orderDetail = OrderDetail.builder()
                            .orderID(orderId)
                            .productID(productId)
                            .quantity(quantity)
                            .price(price)
                            .build();

                    // Lưu chi tiết đơn hàng
                    boolean detailSaved = daoOrderDetails.addOrderDetail(orderDetail);
                    if (!detailSaved) {
                        LOGGER.severe("Failed to save order detail for product: " + productName);
                        allItemsProcessed = false;
                        break;
                    }

                    // Cập nhật tồn kho
                    int newStock = product.getStockQuantity() - quantity;
                    if (newStock < 0) {
                        throw new Exception("Sản phẩm '" + product.getProductName() + "' không đủ số lượng trong kho");
                    }

                    product.setStockQuantity(newStock);
                    boolean stockUpdated = daoProduct.updateProduct(product);

                    if (!stockUpdated) {
                        throw new Exception("Không thể cập nhật tồn kho cho sản phẩm: " + product.getProductName());
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error processing item", e);
                    allItemsProcessed = false;
                    break;
                }
            }

            // Nếu có lỗi xảy ra khi xử lý sản phẩm, xóa đơn hàng
            if (!allItemsProcessed) {
                daoOrder.deleteOrder(orderId);
                throw new Exception("Có lỗi xảy ra khi xử lý sản phẩm trong giỏ hàng");
            }

            // Cập nhật số lần sử dụng voucher nếu có
            if (voucherId != null) {
                daoVoucher.incrementUsageCount(voucherId);
            }

            resp.sendRedirect("sale");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing checkout", e);
            req.setAttribute("errorMessage", "Đã xảy ra lỗi khi xử lý thanh toán: " + e.getMessage());
            req.getRequestDispatcher("/SaleManagement.jsp").forward(req, resp);
        }
    }

    
    /**
     * Xử lý áp dụng mã giảm giá qua AJAX
     */
    private void applyDiscountCodeAjax(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            HttpSession session = req.getSession();

            // Lấy thông tin từ request hoặc session
            String discountCode = req.getParameter("discountCode");
            String cartItemsJson = req.getParameter("cartItems");
            String customerName = req.getParameter("customerName");
            String customerPhone = req.getParameter("customerPhone");
            String customerId = req.getParameter("customerId");

            // Sử dụng dữ liệu từ session nếu request không có
            if (cartItemsJson == null || cartItemsJson.trim().isEmpty()) {
                cartItemsJson = (String) session.getAttribute("cartItemsJson");
            }

            // Tính tổng tiền từ giỏ hàng
            List<Map<String, Object>> cartItems = new ArrayList<>();
            double totalAmount = 0;

            if (cartItemsJson != null && !cartItemsJson.isEmpty()) {
                try {
                    Gson gson = new Gson();
                    Type type = new TypeToken<List<Map<String, Object>>>() {
                    }.getType();
                    cartItems = gson.fromJson(cartItemsJson, type);

                    // Tính tổng tiền
                    for (Map<String, Object> item : cartItems) {
                        Object priceObj = item.get("price");
                        Object quantityObj = item.get("quantity");

                        double price = 0;
                        int quantity = 0;

                        if (priceObj instanceof Double) {
                            price = (Double) priceObj;
                        } else if (priceObj instanceof String) {
                            price = Double.parseDouble((String) priceObj);
                        } else if (priceObj instanceof Integer) {
                            price = (Integer) priceObj;
                        }

                        if (quantityObj instanceof Double) {
                            quantity = ((Double) quantityObj).intValue();
                        } else if (quantityObj instanceof String) {
                            quantity = Integer.parseInt((String) quantityObj);
                        } else if (quantityObj instanceof Integer) {
                            quantity = (Integer) quantityObj;
                        }

                        double itemTotal = price * quantity;
                        item.put("total", itemTotal);
                        totalAmount += itemTotal;
                    }
                } catch (JsonSyntaxException | NumberFormatException e) {
                    LOGGER.log(Level.SEVERE, "Error parsing cart items JSON", e);
                }
            }

            // Kiểm tra mã giảm giá
            int totalAmountInt = (int) Math.round(totalAmount);
            DAOVoucher daoVoucher = new DAOVoucher();
            Voucher voucher = daoVoucher.validateVoucher(discountCode, totalAmountInt);

            String message;
            int discountAmount = 0;
            int voucherId = 0;
            boolean success = false;

            if (voucher != null) {
                // Tính số tiền giảm giá
                discountAmount = daoVoucher.calculateDiscount(voucher, totalAmountInt);
                voucherId = voucher.getId();
                message = "Áp dụng mã giảm giá thành công: Giảm " + voucher.getDiscountRate() + "% (tối đa " + voucher.getMaxValue() + " VNĐ)";
                success = true;
            } else {
                // Kiểm tra lý do mã không hợp lệ
                Voucher invalidVoucher = daoVoucher.getVoucherByCode(discountCode);
                if (invalidVoucher == null) {
                    message = "Mã giảm giá không tồn tại";
                } else if (!invalidVoucher.getStatus()) {
                    message = "Mã giảm giá đã bị vô hiệu hóa";
                } else if (invalidVoucher.getMinOrder() > totalAmountInt) {
                    message = "Đơn hàng chưa đạt giá trị tối thiểu " + invalidVoucher.getMinOrder() + " VNĐ để áp dụng mã này";
                } else if (invalidVoucher.getUsage_limit() > 0 && invalidVoucher.getUsage_count() >= invalidVoucher.getUsage_limit()) {
                    message = "Mã giảm giá đã hết lượt sử dụng";
                } else {
                    message = "Mã giảm giá không hợp lệ hoặc đã hết hạn";
                }
            }

            // Logging for debugging
            LOGGER.log(Level.INFO, "Applying discount code: " + discountCode);
            LOGGER.log(Level.INFO, "Success: " + success);
            LOGGER.log(Level.INFO, "Message: " + message);

            // Chuẩn bị JSON response
            Gson gson = new Gson();
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", message);
            responseData.put("discount", discountAmount);
            responseData.put("voucherId", voucherId);
            responseData.put("totalAmount", totalAmountInt);
            responseData.put("totalPayable", totalAmountInt - discountAmount);

            String jsonResponse = gson.toJson(responseData);
            LOGGER.log(Level.INFO, "Response JSON: " + jsonResponse);

            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error applying discount code via AJAX", e);

            Gson gson = new Gson();
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi áp dụng mã giảm giá: " + e.getMessage());

            out.print(gson.toJson(errorResponse));
            out.flush();
        }
    }

    // Add this new method for AJAX customer search
    private void searchCustomers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            String query = req.getParameter("query");
            if (query == null) {
                query = "";
            }

            List<Customer> customers = daoCustomer.searchCustomersByName(query);

            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < customers.size(); i++) {
                Customer customer = customers.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"id\":").append(customer.getId()).append(",");
                jsonBuilder.append("\"customerName\":\"").append(customer.getCustomerName().replace("\"", "\\\"")).append("\",");
                jsonBuilder.append("\"phone\":\"").append(customer.getPhone() != null ? customer.getPhone() : "").append("\"");
                jsonBuilder.append("}");

                if (i < customers.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");

            String jsonResponse = jsonBuilder.toString();
            // System.out.println("JSON Response: " + jsonResponse); // Debug log

            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching customers", e);
            out.print("[]");
            out.flush();
        }
    }

    // Cập nhật phương thức searchProducts
    private void searchProducts(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {
            String query = req.getParameter("query");

            if (query == null) {
                query = "";
            }

            List<Product> products = daoProduct.searchProductsByName(query);

            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < products.size(); i++) {
                Product product = products.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"id\":").append(product.getId()).append(",");
                jsonBuilder.append("\"productName\":\"").append(product.getProductName().replace("\"", "\\\"")).append("\",");
                jsonBuilder.append("\"productCode\":\"").append(product.getProductCode() != null ? product.getProductCode().replace("\"", "\\\"") : "").append("\",");
                jsonBuilder.append("\"price\":").append(product.getPrice()).append(",");
                jsonBuilder.append("\"stockQuantity\":").append(product.getStockQuantity()).append(",");
                jsonBuilder.append("\"imageURL\":\"").append(product.getImageURL() != null ? product.getImageURL().replace("\"", "\\\"") : "").append("\"");
                jsonBuilder.append("}");

                if (i < products.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");

            String jsonResponse = jsonBuilder.toString();

            out.print(jsonResponse);
            out.flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error searching products", e);
            out.print("[]");
            out.flush();
        }
    }

    @Override
    public void destroy() {
        super.destroy();
        // Đóng kết nối database khi servlet bị hủy
        if (daoProduct != null) {
            daoProduct.closeConnection();
        }
        if (daoOrder != null) {
            daoOrder.closeConnection();
        }
        if (daoOrderDetails != null) {
            daoOrderDetails.closeConnection();
        }
        if (daoCustomer != null) {
            daoCustomer.closeConnection();
        }
        if (daoAccount != null) {
            daoAccount.closeConnection();
        }
        if (daoPayment != null) {
            daoPayment.closeConnection();
        }
        if (daoVoucher != null) {
            daoVoucher.closeConnection();
        }
    }
}
