<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Customer Management</title>
</head>
<body>
    <h2>Danh sách Khách Hàng</h2>

    <% 
        List<Customer> customers = (List<Customer>) request.getAttribute("customers"); 
        if (customers == null) {
            customers = new ArrayList<>();
            out.println("<p style='color:red;'>❌ Không có dữ liệu khách hàng!</p>");
        } else {
            out.println("<p style='color:green;'>✅ Có " + customers.size() + " khách hàng.</p>");
        }
    %>

    <table border="1">
        <tr><th>ID</th><th>Name</th><th>Phone</th><th>Address</th><th>Points</th></tr>
        <% for (Customer c : customers) { %>
        <tr>
            <td><%= c.getId() %></td>
            <td><%= c.getCustomerName() %></td>
            <td><%= c.getPhone() %></td>
            <td><%= c.getAddress() != null ? c.getAddress() : "N/A" %></td>
            <td><%= c.getPoints() != null ? c.getPoints() : "N/A" %></td>
        </tr>
        <% } %>
    </table>
</body>
</html>
