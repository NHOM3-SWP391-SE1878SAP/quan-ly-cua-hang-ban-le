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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import model.DAOSupplier;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.function.Consumer;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SupplierController", urlPatterns = {"/supplier"})
public class SupplierController extends HttpServlet {

    DAOSupplier dao = new DAOSupplier();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            List<Supplier> suppliers = dao.listAllSuppliers();
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
            if (supplier == null) {
                response.sendRedirect("supplier?action=list");
                return;
            }

            List<GoodReceipt> receipts = dao.getGoodReceipts(supplierId, fromDate, toDate);

            request.setAttribute("supplier", supplier);
            request.setAttribute("transactions", receipts);
            request.setAttribute("tab", "history"); // Mark active tab
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("pageTitle", "Lịch sử nhập/trả hàng");

            RequestDispatcher dispatcher = request.getRequestDispatcher("supplier-purchase-history.jsp");
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
            if (supplier == null) {
                response.sendRedirect("supplier?action=list");
                return;
            }

            List<SupplierPayment> payments = dao.getSupplierPayments(supplierId, fromDate, toDate);

            request.setAttribute("supplier", supplier);
            request.setAttribute("transactions", payments);
            request.setAttribute("tab", "debt"); // Mark active tab
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("pageTitle", "Nợ cần trả NCC");

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
            throws ServletException, IOException, ParseException {
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

        HttpSession session = request.getSession();
        String createdBy = "Admin";

        LocalDateTime now = LocalDateTime.now();
        String createdDatea = now.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Date createdDate = sdf.parse(createdDatea);

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

        Supplier supplier = dao.getSupplierById(id);
        if (supplier == null) {
            response.sendRedirect("supplier?action=list");
            return;
        }

        setIfNotNull(request, "supplierCode", supplier::setSupplierCode);
        setIfNotNull(request, "supplierName", supplier::setSupplierName);
        setIfNotNull(request, "companyName", supplier::setCompanyName);
        setIfNotNull(request, "taxCode", supplier::setTaxCode);
        setIfNotNull(request, "phone", supplier::setPhone);
        setIfNotNull(request, "address", supplier::setAddress);
        setIfNotNull(request, "email", supplier::setEmail);
        setIfNotNull(request, "region", supplier::setRegion);
        setIfNotNull(request, "ward", supplier::setWard);
        setIfNotNull(request, "notes", supplier::setNotes);
        setIfNotNull(request, "supplierGroup", supplier::setSupplierGroup);
        setIfNotNullBoolean(request, "status", supplier::setStatus);

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

    private void setIfNotNull(HttpServletRequest request, String param, Consumer<String> setter) {
        String value = request.getParameter(param);
        if (value != null && !value.trim().isEmpty()) {
            setter.accept(value);
        }
    }

    private void setIfNotNullBoolean(HttpServletRequest request, String param, Consumer<Boolean> setter) {
        String value = request.getParameter(param);
        if (value != null) {
            setter.accept(Boolean.valueOf(value));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(SupplierController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            Logger.getLogger(SupplierController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
