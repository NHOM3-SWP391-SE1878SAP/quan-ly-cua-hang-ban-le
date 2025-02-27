package controller;

import entity.Product;
import model.DAOProduct;
import java.io.IOException;
import java.util.Vector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    // Method to handle both GET and POST requests
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Create an instance of DAOProduct to fetch products from DB
        DAOProduct dao = new DAOProduct();

        // Fetch all products using the getAllProducts method
        Vector<Product> product = dao.getAllProducts("SELECT * FROM Products WHERE IsAvailable = 1");

        // Set the fetched product list as a request attribute
        request.setAttribute("productList", product);

        // Forward the request to the ProductManager.jsp page
        RequestDispatcher dispatcher = request.getRequestDispatcher("SaleManagement.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Call the processRequest method for GET requests
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Call the processRequest method for POST requests
        processRequest(request, response);
    }
}


//@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
//public class ProductController extends HttpServlet {
//
//    // Method to handle both GET and POST requests
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        DAOProduct dao = new DAOProduct();
//        Vector<Product> product = dao.getAllProducts("SELECT * FROM Products WHERE IsAvailable = 1");
//
//        // Get cart from session, or create a new one if it doesn't exist
//        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getSession().getAttribute("cart");
//        if (cart == null) {
//            cart = new HashMap<>();
//            request.getSession().setAttribute("cart", cart);
//        }
//
//        request.setAttribute("productList", product);
//        request.setAttribute("cart", cart);
//        RequestDispatcher dispatcher = request.getRequestDispatcher("SaleManagement.jsp");
//        dispatcher.forward(request, response);
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);  // This handles GET requests by calling processRequest
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String action = request.getParameter("action");
//
//        // Handle add to cart action
//        if ("add".equals(action)) {
//            int productId = Integer.parseInt(request.getParameter("productId"));
//            DAOProduct dao = new DAOProduct();
//            Product product = dao.getProductById(productId);
//            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getSession().getAttribute("cart");
//
//            if (cart == null) {
//                cart = new HashMap<>();
//                request.getSession().setAttribute("cart", cart);
//            }
//
//            // Add or update product quantity in the cart
//            if (!cart.containsKey(productId)) {
//                cart.put(productId, new CartItem(product, 1));
//            } else {
//                CartItem cartItem = cart.get(productId);
//                cartItem.setQuantity(cartItem.getQuantity() + 1);
//            }
//
//            response.sendRedirect("ProductController");
//        }
//
//        // Handle remove from cart action
//        if ("remove".equals(action)) {
//            int productId = Integer.parseInt(request.getParameter("productId"));
//            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getSession().getAttribute("cart");
//
//            if (cart != null) {
//                cart.remove(productId);
//            }
//            response.sendRedirect("ProductController");
//        }
//
//        // Handle quantity update action
//        if ("updateQuantity".equals(action)) {
//            int productId = Integer.parseInt(request.getParameter("productId"));
//            int quantity = Integer.parseInt(request.getParameter("quantity"));
//            Map<Integer, CartItem> cart = (Map<Integer, CartItem>) request.getSession().getAttribute("cart");
//
//            if (cart != null) {
//                CartItem cartItem = cart.get(productId);
//                if (cartItem != null) {
//                    cartItem.setQuantity(quantity);
//                    if (cartItem.getQuantity() <= 0) {
//                        cart.remove(productId);
//                    }
//                }
//            }
//            response.sendRedirect("ProductController");
//        }
//    }
//}


