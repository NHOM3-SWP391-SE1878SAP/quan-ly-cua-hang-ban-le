package controller;

import entity.Order;
import entity.OrderDetail;
import entity.Product;
import model.DAOOrder;
import model.DAOOrderDetails;
import model.DAOProduct;
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
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Controller for the sales page
 */
@WebServlet("/sale")
public class SaleController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SaleController.class.getName());
    private DAOProduct daoProduct;
    private DAOOrder daoOrder;
    private DAOOrderDetails daoOrderDetails;

    @Override
    public void init() throws ServletException {
        super.init();
        daoProduct = new DAOProduct();
        daoOrder = new DAOOrder();
        daoOrderDetails = new DAOOrderDetails();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy tất cả sản phẩm từ database
            Vector<Product> products = daoProduct.getAllProducts("SELECT * FROM Products WHERE IsAvailable = 1 ORDER BY ProductName");

            // Đặt danh sách sản phẩm vào request attribute
            req.setAttribute("products", products);

            // Chuyển hướng đến trang sale.jsp
            req.getRequestDispatcher("/sale.jsp").forward(req, resp);

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
                case "checkout":
                    processCheckout(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/sale");
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            if (!resp.isCommitted()) {
                resp.sendRedirect(req.getContextPath() + "/error.jsp");
            }
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
     * Xử lý thanh toán
     */
    private void processCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy dữ liệu giỏ hàng từ request
            String cartDataJson = req.getParameter("cartItems");
            String paymentMethod = req.getParameter("paymentMethod");
            int customerPaid = Integer.parseInt(req.getParameter("customerPaid"));
            int totalPayable = Integer.parseInt(req.getParameter("totalPayable"));

            // Parse JSON data sử dụng Gson
            Gson gson = new Gson();
            JsonArray cartItems = JsonParser.parseString(cartDataJson).getAsJsonArray();

            // Tạo đơn hàng mới
//            Order order = Order.builder()
//                    .orderDate(new Date())
//                    .totalAmount(totalPayable)
//                    .customerID(1) // Mặc định là khách lẻ, ID = 1
//                    .employeeID(11) // Mặc định là nhân viên hiện tại, ID = 1
//                    .paymentID(getPaymentMethodId(paymentMethod))
//                    .voucherID(1) // Mặc định không có voucher
//                    .build();
            Order order = new Order(new Date(), totalPayable, 1, 11, getPaymentMethodId(paymentMethod), 1);

            // Lưu đơn hàng vào database
            boolean orderSaved = daoOrder.addOrder(order);

            if (!orderSaved) {
                throw new Exception("Failed to save order: ");
            }

            // Lấy ID của đơn hàng vừa tạo (giả sử là đơn hàng mới nhất của khách hàng)
            List<Order> customerOrders = daoOrder.getOrdersByCustomerId(1);
            if (customerOrders.isEmpty()) {
                throw new Exception("Failed to retrieve created order");
            }

            // Lấy đơn hàng mới nhất (đơn hàng vừa tạo)
            Order createdOrder = customerOrders.get(customerOrders.size() - 1);
            int orderId = createdOrder.getOrderID();

            // Lưu chi tiết đơn hàng
            for (int i = 0; i < cartItems.size(); i++) {
                JsonObject item = cartItems.get(i).getAsJsonObject();

                int productId = item.get("id").getAsInt();
                int quantity = item.get("quantity").getAsInt();
                int price = item.get("price").getAsInt();

//                OrderDetail orderDetail = OrderDetail.builder()
//                        .quantity(quantity)
//                        .price(price)
//                        .orderID(orderId)
//                        .productID(productId)
//                        .build();
                OrderDetail orderDetail = new OrderDetail(orderId, productId, quantity, price);

                // Lưu chi tiết đơn hàng vào database
                boolean detailSaved = daoOrderDetails.addOrderDetail(orderDetail);

                if (!detailSaved) {
                    throw new Exception("Failed to save order detail for product ID: " + productId);
                }

                // Cập nhật số lượng sản phẩm trong kho
                Product product = daoProduct.getProductById(productId);
                if (product != null) {
                    int newStock = product.getStockQuantity() - quantity;
                    if (newStock < 0) {
                        newStock = 0;
                    }

                    product.setStockQuantity(newStock);
                    daoProduct.updateProduct(product);
                }
            }

            // Chuyển hướng đến trang thành công
            req.setAttribute("successMessage", "Thanh toán thành công! Mã đơn hàng: " + orderId);
            resp.sendRedirect("sale");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing checkout", e);
            req.setAttribute("errorMessage", "Lỗi khi thanh toán: " + e.getMessage());
            req.getRequestDispatcher("/sale.jsp").forward(req, resp);
        }
    }

    /**
     * Lấy ID phương thức thanh toán dựa trên tên
     */
    private int getPaymentMethodId(String paymentMethod) {
        switch (paymentMethod) {
            case "cash":
                return 1; // ID của phương thức thanh toán tiền mặt
            case "transfer":
                return 2; // ID của phương thức thanh toán chuyển khoản
            case "card":
                return 3; // ID của phương thức thanh toán thẻ
            case "vnpay":
                return 4; // ID của phương thức thanh toán VNPay
            default:
                return 1; // Mặc định là tiền mặt
        }
    }

//    @Override
//    public void destroy() {
//        super.destroy();
//        // Đóng kết nối database khi servlet bị hủy
//        if (daoProduct != null) {
//            daoProduct.closeConnection();
//        }
//        if (daoOrder != null) {
//            daoOrder.closeConnection();
//        }
//        if (daoOrderDetails != null) {
//            daoOrderDetails.closeConnection();
//        }
//    }
}
