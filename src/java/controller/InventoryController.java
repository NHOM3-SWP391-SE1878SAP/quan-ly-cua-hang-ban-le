package controller;

import entity.GoodReceipt;
import entity.GoodReceiptDetail;
import entity.Product;
import entity.Supplier;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.DAOSupplier;
import model.GoodReceiptDAO;
import model.GoodReceiptDetailDAO;
import model.ProductDAO;

@WebServlet(name = "InventoryController", urlPatterns = {"/inventory"})
public class InventoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list" -> listGoodReceipts(request, response);
            case "view" -> viewGoodReceipt(request, response);
            case "add" -> showAddForm(request, response);
            case "edit" -> showEditForm(request, response);
            case "save" -> saveGoodReceipt(request, response);
            case "delete" -> deleteGoodReceipt(request, response);
            default -> listGoodReceipts(request, response);
        }
    }
    
    private void listGoodReceipts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
        DAOSupplier supplierDAO = new DAOSupplier();
        
        // Lấy các tham số lọc và tìm kiếm
        String timeFilter = request.getParameter("timeFilter");
        if (timeFilter == null || timeFilter.isEmpty()) {
            timeFilter = "thisMonth"; // Mặc định là tháng này
        }
        
        String supplierIdParam = request.getParameter("supplierId");
        int supplierId = 0;
        if (supplierIdParam != null && !supplierIdParam.isEmpty()) {
            try {
                supplierId = Integer.parseInt(supplierIdParam);
            } catch (NumberFormatException e) {
                supplierId = 0;
            }
        }
        
        String search = request.getParameter("search");
        
        // Lấy tham số phân trang
        String pageParam = request.getParameter("page");
        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int pageSize = 10; // Số lượng phiếu nhập hàng trên mỗi trang
        
        // Lấy danh sách phiếu nhập hàng theo bộ lọc
        List<GoodReceipt> goodsReceipts = goodReceiptDAO.getGoodReceiptsByFilter(timeFilter, supplierId, search, page, pageSize);
        
        // Đếm tổng số phiếu nhập hàng
        int totalItems = goodReceiptDAO.countGoodReceiptsByFilter(timeFilter, supplierId, search);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        
        // Lấy danh sách nhà cung cấp cho bộ lọc
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        // Đặt các thuộc tính vào request
        request.setAttribute("goodsReceipts", goodsReceipts);
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        
        request.getRequestDispatcher("inventory-management.jsp").forward(request, response);
    }
    
    // Xem chi tiết phiếu nhập hàng
    private void viewGoodReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("inventory");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
            GoodReceiptDetailDAO goodReceiptDetailDAO = new GoodReceiptDetailDAO();
            
            // Lấy thông tin phiếu nhập hàng
            GoodReceipt goodReceipt = goodReceiptDAO.getGoodReceiptById(id);
            if (goodReceipt == null) {
                response.sendRedirect("inventory");
                return;
            }
            
            // Lấy danh sách chi tiết phiếu nhập hàng
            List<GoodReceiptDetail> goodReceiptDetails = goodReceiptDetailDAO.getGoodReceiptDetailsByReceiptId(id);
            
            // Đặt các thuộc tính vào request
            request.setAttribute("goodReceipt", goodReceipt);
            request.setAttribute("goodReceiptDetails", goodReceiptDetails);
            
            // Chuyển hướng đến trang xem chi tiết phiếu nhập hàng
            request.getRequestDispatcher("inventory-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("inventory");
        }
    }
    
    // Hiển thị form thêm phiếu nhập hàng
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOSupplier supplierDAO = new DAOSupplier();
        ProductDAO productDAO = new ProductDAO();
        
        // Lấy danh sách nhà cung cấp
        List<Supplier> suppliers = supplierDAO.getAllSuppliers();
        
        // Lấy danh sách sản phẩm
        List<Product> products = productDAO.getAllProducts();
        
        // Đặt các thuộc tính vào request
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("products", products);
        
        // Chuyển hướng đến trang thêm phiếu nhập hàng
        request.getRequestDispatcher("inventory-form.jsp").forward(request, response);
    }
    
    // Hiển thị form chỉnh sửa phiếu nhập hàng
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("inventory");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
            GoodReceiptDetailDAO goodReceiptDetailDAO = new GoodReceiptDetailDAO();
            DAOSupplier supplierDAO = new DAOSupplier();
            ProductDAO productDAO = new ProductDAO();
            
            // Lấy thông tin phiếu nhập hàng
            GoodReceipt goodReceipt = goodReceiptDAO.getGoodReceiptById(id);
            if (goodReceipt == null) {
                response.sendRedirect("inventory");
                return;
            }
            
            // Lấy danh sách chi tiết phiếu nhập hàng
            List<GoodReceiptDetail> goodReceiptDetails = goodReceiptDetailDAO.getGoodReceiptDetailsByReceiptId(id);
            
            // Lấy danh sách nhà cung cấp
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();
            
            // Lấy danh sách sản phẩm
            List<Product> products = productDAO.getAllProducts();
            
            // Đặt các thuộc tính vào request
            request.setAttribute("goodReceipt", goodReceipt);
            request.setAttribute("goodReceiptDetails", goodReceiptDetails);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("products", products);
            
            // Chuyển hướng đến trang chỉnh sửa phiếu nhập hàng
            request.getRequestDispatcher("inventory-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("inventory");
        }
    }
    
    // Lưu phiếu nhập hàng (thêm mới hoặc cập nhật)
    private void saveGoodReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String supplierIdParam = request.getParameter("supplierId");
        String receivedDateParam = request.getParameter("receivedDate");
        
        if (supplierIdParam == null || supplierIdParam.isEmpty() || receivedDateParam == null || receivedDateParam.isEmpty()) {
            response.sendRedirect("inventory?action=add");
            return;
        }
        
        try {
            int supplierId = Integer.parseInt(supplierIdParam);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date receivedDate = sdf.parse(receivedDateParam);
            
            DAOSupplier supplierDAO = new DAOSupplier();
            GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
            GoodReceiptDetailDAO goodReceiptDetailDAO = new GoodReceiptDetailDAO();
            
            // Lấy thông tin nhà cung cấp
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            if (supplier == null) {
                response.sendRedirect("inventory?action=add");
                return;
            }
            
            // Tạo đối tượng phiếu nhập hàng
            GoodReceipt goodReceipt = new GoodReceipt();
            goodReceipt.setReceivedDate(receivedDate);
            goodReceipt.setSupplier(supplier);
            goodReceipt.setTotalCost(0); // Sẽ được cập nhật sau khi thêm chi tiết
            
            int goodReceiptId;
            boolean isUpdate = false;
            
            // Kiểm tra xem là thêm mới hay cập nhật
            if (idParam != null && !idParam.isEmpty()) {
                // Cập nhật phiếu nhập hàng
                goodReceiptId = Integer.parseInt(idParam);
                goodReceipt.setGoodReceiptID(goodReceiptId);
                goodReceiptDAO.updateGoodReceipt(goodReceipt);
                
                // Xóa tất cả chi tiết phiếu nhập hàng cũ
                goodReceiptDetailDAO.deleteGoodReceiptDetailsByReceiptId(goodReceiptId);
                
                isUpdate = true;
            } else {
                // Thêm mới phiếu nhập hàng
                goodReceiptId = goodReceiptDAO.addGoodReceipt(goodReceipt);
                if (goodReceiptId == -1) {
                    response.sendRedirect("inventory?action=add");
                    return;
                }
                goodReceipt.setGoodReceiptID(goodReceiptId);
            }
            
            // Lấy thông tin chi tiết phiếu nhập hàng từ form
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitCosts = request.getParameterValues("unitCost");
            String[] batchNumbers = request.getParameterValues("batchNumber");
            String[] expirationDates = request.getParameterValues("expirationDate");
            
            if (productIds != null && quantities != null && unitCosts != null && batchNumbers != null && expirationDates != null) {
                ProductDAO productDAO = new ProductDAO();
                int totalCost = 0;
                
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    int unitCost = Integer.parseInt(unitCosts[i]);
                    String batchNumber = batchNumbers[i];
                    Date expirationDate = sdf.parse(expirationDates[i]);
                    
                    // Lấy thông tin sản phẩm
                    Product product = productDAO.getProductById(productId);
                    if (product == null) {
                        continue;
                    }
                    
                    // Tạo đối tượng chi tiết phiếu nhập hàng
                    GoodReceiptDetail detail = new GoodReceiptDetail();
                    detail.setGoodReceipt(goodReceipt);
                    detail.setProduct(product);
                    detail.setQuantityReceived(quantity);
                    detail.setUnitCost(unitCost);
                    detail.setBatchNumber(batchNumber);
                    detail.setExpirationDate(expirationDate);
                    
                    // Thêm chi tiết phiếu nhập hàng
                    goodReceiptDetailDAO.addGoodReceiptDetail(detail);
                    
                    // Cộng dồn tổng giá trị
                    totalCost += quantity * unitCost;
                }
                
                // Cập nhật tổng giá trị phiếu nhập hàng
                goodReceipt.setTotalCost(totalCost);
                goodReceiptDAO.updateGoodReceipt(goodReceipt);
            }
            
            // Chuyển hướng đến trang danh sách phiếu nhập hàng
            response.sendRedirect("inventory");
        } catch (NumberFormatException | ParseException e) {
            response.sendRedirect("inventory?action=add");
        }
    }
    
    // Xóa phiếu nhập hàng
    private void deleteGoodReceipt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("inventory");
            return;
        }
        
        try {
            int id = Integer.parseInt(idParam);
            GoodReceiptDAO goodReceiptDAO = new GoodReceiptDAO();
            GoodReceiptDetailDAO goodReceiptDetailDAO = new GoodReceiptDetailDAO();
            
            // Xóa tất cả chi tiết phiếu nhập hàng
            goodReceiptDetailDAO.deleteGoodReceiptDetailsByReceiptId(id);
            
            // Xóa phiếu nhập hàng
            goodReceiptDAO.deleteGoodReceipt(id);
            
            // Chuyển hướng đến trang danh sách phiếu nhập hàng
            response.sendRedirect("inventory");
        } catch (NumberFormatException e) {
            response.sendRedirect("inventory");
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
        return "Inventory Controller";
    }
}