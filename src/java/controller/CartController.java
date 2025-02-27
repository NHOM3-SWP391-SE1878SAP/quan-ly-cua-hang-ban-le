package controller;

import entity.Product;
import entity.CartItem;
import model.DAOProduct;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            DAOProduct dao = new DAOProduct();
            Product product = dao.getProductById(productId);

            cart.putIfAbsent(productId, new CartItem(product, 0));
            cart.get(productId).setQuantity(cart.get(productId).getQuantity() + 1);
        } else if ("increase".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if (cart.containsKey(productId)) {
                cart.get(productId).setQuantity(cart.get(productId).getQuantity() + 1);
            }
        } else if ("decrease".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if (cart.containsKey(productId)) {
                CartItem item = cart.get(productId);
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    cart.remove(productId); // Nếu số lượng giảm xuống < 1 thì xóa sản phẩm khỏi giỏ hàng
                }
            }
        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            cart.remove(productId);
        } else if ("getTotal".equals(action)) {
            int total = 0;
            for (CartItem item : cart.values()) {
                total += item.getProduct().getUnitPrice() * item.getQuantity();
            }
            session.setAttribute("totalAmount", total);
            response.getWriter().print(total);
            return;
        } else if ("checkout".equals(action)) {
            int total = 0;
            for (CartItem item : cart.values()) {
                total += item.getProduct().getUnitPrice() * item.getQuantity();
            }
            session.setAttribute("totalAmount", total);
            response.sendRedirect("Invoice.jsp");
        }

        // Trả về HTML cập nhật cho phần giỏ hàng
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        if (!cart.isEmpty()) {
            for (CartItem item : cart.values()) {
                out.println("<div class='cart-item'>"
                        + "<span>" + item.getProduct().getProductName() + " (x" + item.getQuantity() + ")</span>"
                        + "<span>" + (item.getProduct().getUnitPrice() * item.getQuantity()) + " VND</span>"
                        + "<div class='cart-actions'>"
                        + "<button onclick=\"updateCart(" + item.getProduct().getId() + ", 'decrease')\">➖</button>"
                        + "<button onclick=\"updateCart(" + item.getProduct().getId() + ", 'increase')\">➕</button>"
                        + "<button onclick=\"updateCart(" + item.getProduct().getId() + ", 'remove')\">🗑️</button>"
                        + "</div>"
                        + "</div>");
            }
        } else {
            out.println("<p class='text-danger'>Giỏ hàng trống.</p>");
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
}
