package controller;

import entity.Account;
import entity.Employee;
import entity.EmployeeSalesReport;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;
import model.DAOEmployee;

@WebServlet(name = "EmployeeController", urlPatterns = {"/EmployeeControllerURL"})
public class EmployeeController extends HttpServlet {

    private DAOEmployee dao;

    @Override
    public void init() throws ServletException {
        dao = new DAOEmployee();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String service = request.getParameter("service");
        if (service == null) {
            service = "listAll";
        }

        switch (service) {
            case "listAll":
                listAllEmployees(request, response);
                break;
            case "addEmployee":
                addEmployee(request, response);
                break;
            case "updateEmployee":
                updateEmployee(request, response);
                break;
            case "deleteEmployee":
                deleteEmployee(request, response);
                break;
            case "salesReport":
            generateSalesReport(request, response);
            break;
            default:
                listAllEmployees(request, response);
                break;
        }
    }

    private void listAllEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Vector<Employee> employees = dao.getAllEmployees();
        request.setAttribute("employees", employees);
        RequestDispatcher dispatcher = request.getRequestDispatcher("EmployeeManagement.jsp");
        dispatcher.forward(request, response);
    }

//    private void addEmployee(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        try {
//            String name = getParameterSafe(request, "employeeName");
//            String avatar = getParameterSafe(request, "avatar");
//            String dobStr = getParameterSafe(request, "dob");
//            boolean gender = Boolean.parseBoolean(getParameterSafe(request, "gender"));
//            int salary = Integer.parseInt(getParameterSafe(request, "salary"));
//            String cccd = getParameterSafe(request, "cccd");
//            boolean isAvailable = Boolean.parseBoolean(getParameterSafe(request, "isAvailable"));
//
//            String username = getParameterSafe(request, "userName");
//            String password = getParameterSafe(request, "password");
//            String email = getParameterSafe(request, "email");
//            String phone = getParameterSafe(request, "phone");
//            String address = getParameterSafe(request, "address");
//
//            Date dob = parseDate(dobStr);
//
//            Account account = new Account(0, username, password, email, phone, address, null);
//            Employee emp = new Employee(0, name, avatar, dob, gender, salary, cccd, isAvailable, account);
//
//            if (dao.addEmployee(emp)) {
//                request.setAttribute("message", "Nhân viên đã được thêm thành công!");
//            } else {
//                request.setAttribute("message", "Thêm nhân viên thất bại.");
//            }
//
//        } catch (Exception e) {
//            request.setAttribute("message", "Lỗi: " + e.getMessage());
//        }
//        response.sendRedirect("EmployeeControllerURL?service=listAll");
//    }
//
//    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
//            throws IOException {
//        try {
//            int employeeID = Integer.parseInt(getParameterSafe(request, "employeeID"));
//            String name = getParameterSafe(request, "employeeName");
//            String avatar = getParameterSafe(request, "avatar");
//            String dobStr = getParameterSafe(request, "dob");
//            boolean gender = Boolean.parseBoolean(getParameterSafe(request, "gender"));
//            int salary = Integer.parseInt(getParameterSafe(request, "salary"));
//            String cccd = getParameterSafe(request, "cccd");
//            boolean isAvailable = Boolean.parseBoolean(getParameterSafe(request, "isAvailable"));
//
//            String username = getParameterSafe(request, "userName");
//            String email = getParameterSafe(request, "email");
//            String phone = getParameterSafe(request, "phone");
//            String address = getParameterSafe(request, "address");
//
//            Date dob = parseDate(dobStr);
//
//            Account account = new Account(0, username, "", email, phone, address, null);
//            Employee emp = new Employee(employeeID, name, avatar, dob, gender, salary, cccd, isAvailable, account);
//
//            if (dao.updateEmployee(emp)) {
//                request.setAttribute("message", "Cập nhật nhân viên thành công!");
//            } else {
//                request.setAttribute("message", "Cập nhật nhân viên thất bại.");
//            }
//        } catch (Exception e) {
//            request.setAttribute("message", "Lỗi: " + e.getMessage());
//        }
//        response.sendRedirect("EmployeeControllerURL?service=listAll");
//    }
private void addEmployee(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    try {
        String name = getParameterSafe(request, "employeeName");
        String avatar = getParameterSafe(request, "avatar");
        String dobStr = getParameterSafe(request, "dob");
        boolean gender = Boolean.parseBoolean(getParameterSafe(request, "gender"));
        int salary = Integer.parseInt(getParameterSafe(request, "salary"));
        String cccd = getParameterSafe(request, "cccd");
        boolean isAvailable = Boolean.parseBoolean(getParameterSafe(request, "isAvailable"));

        String username = getParameterSafe(request, "userName");
        String password = getParameterSafe(request, "password");
        String email = getParameterSafe(request, "email");
        String phone = getParameterSafe(request, "phone");
        String address = getParameterSafe(request, "address");

        // Validate password
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (@$!%*?&)");
            listAllEmployees(request, response);
            return;
        }

        // Check for existing email/phone
        if (dao.isEmailExists(email, 0)) {
            request.setAttribute("error", "Email đã tồn tại trong hệ thống");
            listAllEmployees(request, response);
            return;
        }

        if (dao.isPhoneExists(phone, 0)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại trong hệ thống");
            listAllEmployees(request, response);
            return;
        }

        Date dob = parseDate(dobStr);

        Account account = new Account(0, username, password, email, phone, address, null);
        Employee emp = new Employee(0, name, avatar, dob, gender, salary, cccd, isAvailable, account);

        if (dao.addEmployee(emp)) {
            request.setAttribute("message", "Nhân viên đã được thêm thành công!");
        } else {
            request.setAttribute("message", "Thêm nhân viên thất bại.");
        }

    } catch (Exception e) {
        request.setAttribute("error", "Lỗi: " + e.getMessage());
    }
    response.sendRedirect("EmployeeControllerURL?service=listAll");
}

private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {
    try {
        int employeeID = Integer.parseInt(getParameterSafe(request, "employeeID"));
        String name = getParameterSafe(request, "employeeName");
        String avatar = getParameterSafe(request, "avatar");
        String dobStr = getParameterSafe(request, "dob");
        boolean gender = Boolean.parseBoolean(getParameterSafe(request, "gender"));
        int salary = Integer.parseInt(getParameterSafe(request, "salary"));
        String cccd = getParameterSafe(request, "cccd");
        boolean isAvailable = Boolean.parseBoolean(getParameterSafe(request, "isAvailable"));

        String username = getParameterSafe(request, "userName");
        String email = getParameterSafe(request, "email");
        String phone = getParameterSafe(request, "phone");
        String address = getParameterSafe(request, "address");

       // Lấy thông tin tài khoản hiện tại của nhân viên
        Employee existingEmp = dao.getEmployeeByID(employeeID);
        if (existingEmp == null) {
            request.setAttribute("error", "Nhân viên không tồn tại");
            listAllEmployees(request, response);
            return;
        }

        // Lấy accountID từ thông tin hiện tại
        int currentAccountID = existingEmp.getAccount().getId();

        // Kiểm tra email/phone đã tồn tại (LOẠI TRỪ account hiện tại)
        if (dao.isEmailExists(email, currentAccountID)) { // Truyền currentAccountID vào
            request.setAttribute("error", "Email đã tồn tại trong hệ thống");
            listAllEmployees(request, response);
            return;
        }

        if (dao.isPhoneExists(phone, currentAccountID)) { // Truyền currentAccountID vào
            request.setAttribute("error", "Số điện thoại đã tồn tại trong hệ thống");
            listAllEmployees(request, response);
            return;
        }

        Date dob = parseDate(dobStr);

        Account account = new Account(currentAccountID, username, "", email, phone, address, null);
        Employee emp = new Employee(employeeID, name, avatar, dob, gender, salary, cccd, isAvailable, account);

        if (dao.updateEmployee(emp)) {
            request.setAttribute("message", "Cập nhật nhân viên thành công!");
        } else {
            request.setAttribute("message", "Cập nhật nhân viên thất bại.");
        }
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi: " + e.getMessage());
    }
    response.sendRedirect("EmployeeControllerURL?service=listAll");
}
    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    try {
        int employeeID = Integer.parseInt(getParameterSafe(request, "employeeID"));
        if (dao.deleteEmployee(employeeID)) {
            request.getSession().setAttribute("message", "Xóa nhân viên thành công!");
        } else {
            request.getSession().setAttribute("message", "Xóa nhân viên thất bại. Có thể còn dữ liệu liên quan.");
        }
    } catch (Exception e) {
        request.getSession().setAttribute("message", "Lỗi: " + e.getMessage());
    }
    response.sendRedirect("EmployeeControllerURL?service=listAll");
}

    // Hàm hỗ trợ tránh lỗi NullPointerException
    private String getParameterSafe(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return (value != null) ? value.trim() : "";
    }

private Date parseDate(String dateStr) throws ParseException {
    if (dateStr == null || dateStr.trim().isEmpty()) {
        return null; // hoặc trả về ngày mặc định
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    return sdf.parse(dateStr);
}
    
    private void generateSalesReport(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        String fromDateStr = getParameterSafe(request, "fromDate");
        String toDateStr = getParameterSafe(request, "toDate");
        
        // Xử lý ngày mặc định
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date fromDate;
        Date toDate;
        
        if (fromDateStr.isEmpty()) {
            Calendar cal = Calendar.getInstance();
            toDate = new Date();
            cal.add(Calendar.DAY_OF_MONTH, -30);
            fromDate = cal.getTime();
        } else {
            fromDate = sdf.parse(fromDateStr);
            toDate = toDateStr.isEmpty() ? new Date() : sdf.parse(toDateStr);
        }
        
        if (toDate.before(fromDate)) {
            toDate = fromDate;
        }
        
        Vector<EmployeeSalesReport> report = dao.getEmployeeSalesReport(fromDate, toDate);
        
        request.setAttribute("report", report);
        request.setAttribute("fromDate", sdf.format(fromDate));
        request.setAttribute("toDate", sdf.format(toDate));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("EmployeeSalesReport.jsp");
        dispatcher.forward(request, response);
        
    } catch (Exception e) {
        request.setAttribute("error", "Lỗi khi tạo báo cáo: " + e.getMessage());
        listAllEmployees(request, response);
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
        return "Employee Controller";
    }
}
