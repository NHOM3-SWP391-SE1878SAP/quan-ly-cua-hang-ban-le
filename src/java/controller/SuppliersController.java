package controller;

import entity.Supplier;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Vector;
import model.DAOSupplier;

@WebServlet(name = "SuppliersController", urlPatterns = {"/SuppliersControllerURL"})
public class SuppliersController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DAOSupplier dao = new DAOSupplier();
        String service = request.getParameter("service");

        if (service == null) {
            service = "listAll"; // Mặc định là hiển thị danh sách nhà cung cấp
        }

        try {
            switch (service) {
                case "listAll":
                    listAllSuppliers(request, response, dao);
                    break;

                case "addSupplier":
                    addSupplier(request, response, dao);
                    break;

                case "editSupplier":
                    editSupplier(request, response, dao);
                    break;

                case "updateSupplier":
                    updateSupplier(request, response, dao);
                    break;

                case "deleteSupplier":
                    deleteSupplier(request, response, dao);
                    break;

                default:
                    response.sendRedirect("SupplierManagement.jsp");
                    break;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xảy ra khi xử lý yêu cầu.");
        }
    }

    private void listAllSuppliers(HttpServletRequest request, HttpServletResponse response, DAOSupplier dao)
            throws ServletException, IOException {
        String status = request.getParameter("status");

        // Nếu không có tham số status (ví dụ: không chọn gì), mặc định lấy tất cả
        if (status == null) {
            status = "all"; // Lọc tất cả nhà cung cấp
        }

        try {
            // Gọi phương thức DAO để lấy nhà cung cấp theo status
            Vector<Supplier> suppliers = dao.listSuppliersByStatus(status); // Lấy nhà cung cấp theo status
            request.setAttribute("suppliers", suppliers); // Đưa kết quả vào request
            request.getRequestDispatcher("SupplierManagement.jsp").forward(request, response); // Chuyển hướng tới trang hiển thị
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể lấy danh sách nhà cung cấp.");
            request.getRequestDispatcher("SupplierManagement.jsp").forward(request, response);
        }
    }

    private void addSupplier(HttpServletRequest request, HttpServletResponse response, DAOSupplier dao)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ request
            String supplierCode = request.getParameter("supplierCode");
            String supplierName = request.getParameter("supplierName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            // Kiểm tra dữ liệu bắt buộc
            if (supplierCode == null || supplierCode.trim().isEmpty()
                    || supplierName == null || supplierName.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Mã nhà cung cấp, Tên, Số điện thoại và Email là bắt buộc.");
                request.getRequestDispatcher("AddSupplier.jsp").forward(request, response);
                return;
            }

            // Kiểm tra trùng lặp SupplierCode
            if (dao.isSupplierCodeExists(supplierCode)) {
                request.setAttribute("errorMessage", "Mã nhà cung cấp đã tồn tại. Vui lòng nhập mã khác.");
                request.getRequestDispatcher("AddSupplier.jsp").forward(request, response);
                return;
            }

            // Lấy thêm thông tin khác
            String companyName = request.getParameter("companyName");
            String taxCode = request.getParameter("taxCode");
            String address = request.getParameter("address");
            String region = request.getParameter("region");
            String ward = request.getParameter("ward");
            String createdBy = request.getParameter("createdBy");
            String createdDateStr = request.getParameter("createdDate");
            String notes = request.getParameter("notes");
            String supplierGroup = request.getParameter("supplierGroup");

            // Xử lý trạng thái
            boolean status = false;
            if (request.getParameter("status") != null) {
                status = Boolean.parseBoolean(request.getParameter("status"));
            }

            // Xử lý ngày tạo
            java.util.Date createdDate = null;
            try {
                if (createdDateStr != null && !createdDateStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    createdDate = sdf.parse(createdDateStr);
                }
            } catch (ParseException e) {
                request.setAttribute("errorMessage", "Ngày tạo không hợp lệ.");
                request.getRequestDispatcher("AddSupplier.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Supplier
            Supplier supplier = new Supplier();
            supplier.setSupplierCode(supplierCode);
            supplier.setSupplierName(supplierName);
            supplier.setPhone(phone);
            supplier.setEmail(email);
            supplier.setCompanyName(companyName);
            supplier.setTaxCode(taxCode);
            supplier.setAddress(address);
            supplier.setRegion(region);
            supplier.setWard(ward);
            supplier.setCreatedBy(createdBy);
            supplier.setCreatedDate(createdDate);
            supplier.setNotes(notes);
            supplier.setStatus(status);
            supplier.setSupplierGroup(supplierGroup);

            // Thêm vào database
            dao.addSupplier(supplier);

            // Chuyển hướng về danh sách nhà cung cấp
            response.sendRedirect("SuppliersControllerURL?service=listAll");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm nhà cung cấp.");
            request.getRequestDispatcher("AddSupplier.jsp").forward(request, response);
        }
    }

    private void editSupplier(HttpServletRequest request, HttpServletResponse response, DAOSupplier dao)
            throws ServletException, IOException {
        int supllierId = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = dao.getSupplierById(supllierId);

        if (supplier != null) {
            request.setAttribute("supplier", supplier);
            RequestDispatcher dispatcher = request.getRequestDispatcher("EditSupplier.jsp"); // Redirect to edit page
            dispatcher.forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
        }
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response, DAOSupplier dao)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ form
            int supplierId = Integer.parseInt(request.getParameter("Id"));
            String supplierCode = request.getParameter("supplierCode");
            String supplierName = request.getParameter("supplierName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            // Kiểm tra dữ liệu bắt buộc
            if (supplierCode == null || supplierCode.trim().isEmpty()
                    || supplierName == null || supplierName.trim().isEmpty()
                    || phone == null || phone.trim().isEmpty()
                    || email == null || email.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Mã nhà cung cấp, Tên nhà cung cấp, Số điện thoại và Email là bắt buộc.");
                request.getRequestDispatcher("EditSupplier.jsp").forward(request, response);
                return;
            }

            // Lấy các thông tin khác từ form (có thể null)
            String companyName = request.getParameter("companyName");
            String taxCode = request.getParameter("taxCode");
            String address = request.getParameter("address");
            String region = request.getParameter("region");
            String ward = request.getParameter("ward");
            String createdBy = request.getParameter("createdBy");
            String notes = request.getParameter("notes");
            String supplierGroup = request.getParameter("supplierGroup");

            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            java.util.Date createdDate = null;
            try {
                String createdDateStr = request.getParameter("createdDate");
                if (createdDateStr != null && !createdDateStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    createdDate = sdf.parse(createdDateStr);
                }
            } catch (ParseException e) {
                request.setAttribute("errorMessage", "Ngày tạo không hợp lệ.");
                request.getRequestDispatcher("EditSupplier.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Supplier với các giá trị cập nhật
            Supplier supplier = new Supplier();
            supplier.setId(supplierId);  // Đảm bảo ID của nhà cung cấp được sử dụng để cập nhật đúng bản ghi
            supplier.setSupplierCode(supplierCode);
            supplier.setSupplierName(supplierName);
            supplier.setPhone(phone);
            supplier.setEmail(email);
            supplier.setCompanyName(companyName);
            supplier.setTaxCode(taxCode);
            supplier.setAddress(address);
            supplier.setRegion(region);
            supplier.setWard(ward);
            supplier.setCreatedBy(createdBy);
            supplier.setCreatedDate(createdDate);
            supplier.setNotes(notes);
            supplier.setStatus(status);
            supplier.setSupplierGroup(supplierGroup);

            // Gọi DAO để thực hiện cập nhật trong cơ sở dữ liệu
            dao.updateSupplier(supplier);

            // Nếu thành công, chuyển hướng về danh sách nhà cung cấp
            response.sendRedirect("SuppliersControllerURL?service=listAll");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật nhà cung cấp.");
            request.getRequestDispatcher("EditSupplier.jsp").forward(request, response);
        }
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response, DAOSupplier dao) throws ServletException, IOException {
        int supplierId = Integer.parseInt(request.getParameter("id"));
        boolean success = dao.deleteSupplier(supplierId);

        if (success) {
            response.sendRedirect("SuppliersControllerURL?service=listAll");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete supplier.");
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
        return "Servlet quản lý nhà cung cấp";
    }
}
