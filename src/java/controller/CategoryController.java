package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DAOCategory;
import entity.Category;
import entity.Product;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.Vector;
import model.DAOProduct;

@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryControllerURL"})
public class CategoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAOCategory dao = new DAOCategory();
        String service = request.getParameter("service");

        if (service == null) {
            service = "listAll"; // Default action is listing all categories
        }

        try {
            switch (service) {
                case "listAll":
                    listAllCategory(request, response, dao);
                    break;

                case "add":
                    addCategory(request, response, dao);
                    break;

                case "edit":
                    editCategory(request, response, dao);
                    break;

                case "update":
                    updateCategory(request, response, dao);
                    break;

                case "delete":
                    deleteCategory(request, response, dao);
                    break;

                case "getProduct":
                    getProductByCategory(request, response, dao);
                    break;

                default:
                    response.sendRedirect("CategoryManagement.jsp");
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }

    private void listAllCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        // Retrieve all categories from the DAO
        Vector<Category> categories = dao.getAllCategories();
        // Set categories as an attribute for the JSP
        request.setAttribute("categories", categories);
        // Forward to the CategoryManagement.jsp page
        request.getRequestDispatcher("CategoryManagement.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String imageName = request.getParameter("imageName"); // Image URL

        // Check if the category name already exists
        if (dao.isCategoryNameExists(categoryName)) {
            // If the category name already exists, set an error message and forward to AddCategory.jsp
            request.setAttribute("errorMessage", "Category name already exists.");
            request.getRequestDispatcher("AddCategory.jsp").forward(request, response);
            return;  // Stop further execution
        }

        // Create a new Category object and attempt to insert it
        Category newCategory = new Category(0, categoryName, description, imageName);
        dao.insertCategory(newCategory);  // Add the category using DAO

        // Redirect to the category list after adding
        response.sendRedirect("CategoryControllerURL?service=listAll");
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        Category category = dao.getCategoryByID(categoryID);
        if (category != null) {
            request.setAttribute("category", category);
            RequestDispatcher dispatcher = request.getRequestDispatcher("EditCategory.jsp"); // Redirect to edit page
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Category not found.");
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String imageName = request.getParameter("imageName");

        if (dao.isCategoryNameExistsForUpdate(categoryName, categoryID)) {
            // Nếu đã tồn tại, hiển thị lỗi và quay lại trang chỉnh sửa
            request.setAttribute("errorMessage", "Tên loại hàng đã tồn tại.");
            Category category = dao.getCategoryByID(categoryID);
            request.setAttribute("category", category);
            request.getRequestDispatcher("EditCategory.jsp").forward(request, response);
            return;
        }

        Category category = new Category(categoryID, categoryName, description, imageName);
        dao.updateCategory(category);

        // Redirect về danh sách các danh mục sau khi cập nhật
        response.sendRedirect("CategoryControllerURL?service=listAll");
    }

    private void getProductByCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        int categoryID = Integer.parseInt(request.getParameter("categoryId"));
        DAOProduct daoProduct = new DAOProduct();
        Vector<Product> products = daoProduct.getProductByCategory(categoryID);
        Category category = dao.getCategoryByID(categoryID);
        if (products != null && !products.isEmpty()) {
            request.setAttribute("data", products); 
        } else {
            request.setAttribute("message", "Không có sản phẩm nào trong danh mục này.");
        }
        request.setAttribute("category", category);
        Vector<Category> categories = dao.getAllCategories();
        request.setAttribute("categories", categories);  

        request.getRequestDispatcher("ProductByCategory.jsp").forward(request, response); 
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response, DAOCategory dao)
            throws ServletException, IOException {
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));
        boolean deleted = dao.deleteCategory(categoryID);

        if (deleted) {
            // Redirect to the list of categories after successful deletion
            response.sendRedirect("CategoryControllerURL?service=listAll");
        } else {
            // Handle case when deletion failed
            request.setAttribute("errorMessage", "Deletion failed.");
            request.getRequestDispatcher("CategoryManagement.jsp").forward(request, response);
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
    }
}
