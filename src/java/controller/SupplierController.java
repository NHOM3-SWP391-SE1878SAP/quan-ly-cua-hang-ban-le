package controller;

import entity.GoodReceipt;
import entity.Supplier;
import entity.SupplierPayment;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.DAOSupplier;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;

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
                case "add" ->
                    addSupplier(request, response);
                case "update" ->
                    updateSupplier(request, response);
                case "delete" ->
                    deleteSupplier(request, response);
                case "search" ->
                    searchSuppliers(request, response);
                case "view" ->
                    viewSupplier(request, response);
                case "history" ->
                    viewHistory(request, response);
                case "debt" ->
                    viewDebt(request, response);
                case "makePayment" ->
                    makePayment(request, response);
                case "exportDebt" ->
                    exportDebtReport(request, response);
                case "exportTransactions" ->
                    exportTransactions(request, response);
                case "edit" -> {
                    try {
                        int id = Integer.parseInt(request.getParameter("id"));
                        Supplier supplier = dao.getSupplierById(id);
                        request.setAttribute("supplier", supplier);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("supplier-infor.jsp");
                        dispatcher.forward(request, response);
                    } catch (ServletException | IOException | NumberFormatException e) {
                        System.out.println(e);
                    }
                }
                default ->
                    response.sendRedirect("manage-supplier.jsp");
            }
        }
    }

    private void viewHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            
            Supplier supplier = dao.getSupplierById(supplierId);
            List<GoodReceipt> receipts = dao.getGoodReceipts(supplierId, fromDate, toDate);
            
            request.setAttribute("supplier", supplier);
            request.setAttribute("transactions", receipts);
            RequestDispatcher dispatcher = request.getRequestDispatcher("supplier-payment.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier?action=list");
        }
    }
    
    private void viewDebt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("id"));
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            
            Supplier supplier = dao.getSupplierById(supplierId);
            List<SupplierPayment> payments = dao.getSupplierPayments(supplierId, fromDate, toDate);
            
            request.setAttribute("supplier", supplier);
            request.setAttribute("transactions", payments);
            RequestDispatcher dispatcher = request.getRequestDispatcher("supplier-payment.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier?action=list");
        }
    }
    
    private void makePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            int amount = Integer.parseInt(request.getParameter("amount"));
            String paymentMethod = request.getParameter("paymentMethod");
            String notes = request.getParameter("notes");
            
            SupplierPayment payment = new SupplierPayment();
            payment.setSupplier(dao.getSupplierById(supplierId));
            payment.setAmountPaid(amount);
            payment.setPaymentDate(new Date());
            payment.setPaymentMethod(paymentMethod);
            payment.setNotes(notes);
            
            dao.addSupplierPayment(payment);
            dao.updateSupplierBalance(supplierId, amount);
            
            response.sendRedirect("supplier?action=debt&id=" + supplierId);
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier?action=list");
        }
    }
    
    private void exportDebtReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        // Implementation for exporting debt report
        response.sendRedirect("supplier?action=debt&id=" + supplierId);
    }
    
    private void exportTransactions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        // Implementation for exporting transactions
        response.sendRedirect("supplier?action=history&id=" + supplierId);
    }

    private void viewSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Supplier supplier = dao.getSupplierById(id);
            request.setAttribute("supplier", supplier);
            RequestDispatcher dispatcher = request.getRequestDispatcher("supplier-infor.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier?action=list");
        }
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("supplierCode");
        String name = request.getParameter("supplierName");
        String companyName = request.getParameter("companyName");
        String taxCode = request.getParameter("taxCode");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String region = request.getParameter("region");
        String ward = request.getParameter("ward");
        String notes = request.getParameter("notes");
        String group = request.getParameter("supplierGroup");
        
        // Get current user from session
        HttpSession session = request.getSession();
        String createdBy = "Admin"; // Replace with actual user name from session
        
        // Get current date time
        LocalDateTime now = LocalDateTime.now();
        String createdDate = now.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        
        Supplier supplier = new Supplier();
        supplier.setSupplierCode(code);
        supplier.setSupplierName(name);
        supplier.setCompanyName(companyName);
        supplier.setTaxCode(taxCode);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setEmail(email);
        supplier.setRegion(region);
        supplier.setWard(ward);
        supplier.setCreatedBy(createdBy);
        supplier.setCreatedDate(createdDate);
        supplier.setNotes(notes);
        supplier.setStatus(true);
        supplier.setSupplierGroup(group);
        supplier.setTotalPurchase(0.0);
        supplier.setCurrentDebt(0.0);

        dao.addSupplier(supplier);
        response.sendRedirect("supplier?action=list");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("supplierCode");
        String name = request.getParameter("supplierName");
        String companyName = request.getParameter("companyName");
        String taxCode = request.getParameter("taxCode");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String region = request.getParameter("region");
        String ward = request.getParameter("ward");
        String notes = request.getParameter("notes");
        String group = request.getParameter("supplierGroup");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));

        Supplier supplier = new Supplier();
        supplier.setId(id);
        supplier.setSupplierCode(code);
        supplier.setSupplierName(name);
        supplier.setCompanyName(companyName);
        supplier.setTaxCode(taxCode);
        supplier.setPhone(phone);
        supplier.setAddress(address);
        supplier.setEmail(email);
        supplier.setRegion(region);
        supplier.setWard(ward);
        supplier.setNotes(notes);
        supplier.setStatus(status);
        supplier.setSupplierGroup(group);

        dao.updateSupplier(supplier);
        response.sendRedirect("supplier?action=view&id=" + id);
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
        request.getRequestDispatcher("supplier-infor.jsp").forward(request, response);
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
