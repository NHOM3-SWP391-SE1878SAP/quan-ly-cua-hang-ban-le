package controller;

import entity.Category;
import entity.Product;
import model.DAOProduct;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

@WebServlet(name = "ProductsController", urlPatterns = {"/ProductsControllerURL"})
public class ProductsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        DAOProduct dao = new DAOProduct();
        String service = request.getParameter("service");

        if (service == null) {
            service = "listAll"; // Default action is listing all products
        }

        try {
            switch (service) {
                case "listAll":
                    listAllProducts(request, response, dao);
                    break;

                case "addProduct":
                    addProduct(request, response, dao);
                    break;

                case "edit":
                    editProduct(request, response, dao);
                    break;

                case "updateProduct":
                    updateProduct(request, response, dao);
                    break;

                case "delete":
                    deleteProduct(request, response, dao);
                    break;
                case "setPrice":  // New Service
                    setPrice(request, response, dao);
                    break;
                case "updatePriceBatch":
                    updatePriceBatch(request, response, dao);
                    break;

                default:
                    response.sendRedirect("ProductManagement.jsp"); // Redirect to default page for unknown services
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    private void listAllProducts(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        Vector<Product> vector = dao.getAllProducts1();
        request.setAttribute("data", vector);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ProductManagement.jsp");
        dispatcher.forward(request, response);
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        // Extract product data from the request
        String productName = request.getParameter("productName");
        String productCode = request.getParameter("productCode");
        int price = Integer.parseInt(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));

        boolean isAvailable = stockQuantity > 0; // Nếu stock > 0 thì Available = true
        String imageURL = request.getParameter("imageURL");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Category category = new Category(categoryId, "", "", ""); // Tạo Category object
        Product newProduct = new Product(0, productName, productCode, price, stockQuantity, isAvailable, imageURL, category);

        dao.addProduct(newProduct); // Add the product using DAO

        response.sendRedirect("ProductsControllerURL?service=listAll");
    }

    private void editProduct(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        Product product = dao.getProductByIdNg(productId); // Fetch the product by ID

        if (product != null) {
            request.setAttribute("product", product);
            RequestDispatcher dispatcher = request.getRequestDispatcher("EditProduct.jsp"); // Redirect to edit page
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        // Retrieve updated product information from the request
        int productId = Integer.parseInt(request.getParameter("productId"));
        String productName = request.getParameter("productName");
        String productCode = request.getParameter("productCode");
        int price = Integer.parseInt(request.getParameter("price"));
        int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
        String imageURL = request.getParameter("imageURL");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        Category category = new Category(categoryId, "", "", ""); // Assuming no category image for now
        Product updatedProduct = new Product(productId, productName, productCode, price, stockQuantity, true, imageURL, category);

        dao.updateProduct(updatedProduct);

        response.sendRedirect("ProductsControllerURL?service=listAll");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        boolean success = dao.deleteProduct(productId); // Delete the product by ID

        if (success) {
            // Redirect to product list if the delete operation is successful
            response.sendRedirect("ProductsControllerURL?service=listAll");
        } else {
            // Send an error if the delete operation fails
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete product.");
        }
    }

    private void setPrice(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        Vector<Product> vector = dao.getProductsWithUnitCost();
        request.setAttribute("data", vector);
        RequestDispatcher dispatcher = request.getRequestDispatcher("SetPrice.jsp");
        dispatcher.forward(request, response);
    }

    private void updatePriceBatch(HttpServletRequest request, HttpServletResponse response, DAOProduct dao) throws ServletException, IOException {
        String[] productIdsArray = request.getParameterValues("productIds");
        String[] pricesArray = request.getParameterValues("prices");

        if (productIdsArray == null || pricesArray == null || productIdsArray.length != pricesArray.length) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ.");
            return;
        }

        List<Product> updatedProducts = new ArrayList<>();

        for (int i = 0; i < productIdsArray.length; i++) {
            try {
                int productId = Integer.parseInt(productIdsArray[i]);
                int price = Integer.parseInt(pricesArray[i]);

                Product product = new Product();
                product.setId(productId);
                product.setPrice(price);
                updatedProducts.add(product);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID hoặc giá không hợp lệ.");
                return;
            }
        }

        boolean success = dao.updateProductsPriceBatch(updatedProducts);

        if (success) {
            response.sendRedirect("ProductsControllerURL?service=setPrice");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật giá.");
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
        return "Product Controller";
    }
}
