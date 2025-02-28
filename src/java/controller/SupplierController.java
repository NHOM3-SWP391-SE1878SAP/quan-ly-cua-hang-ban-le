package controller;

import entity.Supplier;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.DAOSupplier;

@WebServlet(name = "SupplierController", urlPatterns = {"/supplier"})
public class SupplierController extends HttpServlet {
    
    DAOSupplier dao = new DAOSupplier();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        
        if (action == null || action.equals("list")) {
            List<Supplier> suppliers = dao.getAllSuppliers();
            request.setAttribute("suppliers", suppliers);
            RequestDispatcher dispatcher = request.getRequestDispatcher("manage-supplier.jsp");
            dispatcher.forward(request, response);
        } else {
            switch (action) {
                case "add":
                    addSupplier(request, response);
                    break;
                case "update":
                    updateSupplier(request, response);
                    break;
                case "delete":
                    deleteSupplier(request, response);
                    break;
                case "search":
                    searchSuppliers(request, response);
                    break;
                default:
                    response.sendRedirect("manage-supplier.jsp");
            }
        }
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("supplierName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        
        Supplier supplier = new Supplier();
        supplier.setSupplierName(name);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setEmail(email);
        
        dao.addSupplier(supplier);
        response.sendRedirect("supplier?action=list");
    }
    
    private void updateSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("supplierName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        
        Supplier supplier = new Supplier();
        supplier.setId(id);
        supplier.setSupplierName(name);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setEmail(email);
        
        dao.updateSupplier(supplier);
        response.sendRedirect("supplier?action=list");
    }
    
    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deleteSupplier(id);
        response.sendRedirect("supplier?action=list");
    }
    
    private void searchSuppliers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String group = request.getParameter("group");
        
        List<Supplier> suppliers = dao.searchSuppliers(code, name, phone, group);
        request.setAttribute("suppliers", suppliers);
        request.getRequestDispatcher("manage-supplier.jsp").forward(request, response);
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