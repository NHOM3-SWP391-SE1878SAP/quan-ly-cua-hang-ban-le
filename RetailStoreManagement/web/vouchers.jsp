<%@ page import="java.util.List" %>
<%@ page import="model.Voucher" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head><title>Voucher Management</title></head>
<body>
    <h2>Danh sách Vouchers</h2>
    <table border="1">
        <tr><th>ID</th><th>Code</th><th>Min Order</th><th>Discount Rate</th><th>Max Value</th><th>Start Date</th><th>End Date</th><th>Actions</th></tr>
        <% for (Voucher v : (List<Voucher>) request.getAttribute("vouchers")) { %>
        <tr>
            <td><%= v.getId() %></td>
            <td><%= v.getCode() %></td>
            <td><%= v.getMinOrder() %></td>
            <td><%= v.getDiscountRate() %>%</td>
            <td><%= v.getMaxValue() %></td>
            <td><%= v.getStartDate() %></td>
            <td><%= v.getEndDate() %></td>
            <td>
                <form action="VoucherServlet" method="post">
                    <input type="hidden" name="id" value="<%= v.getId() %>">
                    <button type="submit" name="action" value="delete">Xóa</button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>

    <form action="VoucherServlet" method="post">
        <input type="number" step="0.1" name="minOrder" placeholder="Min Order" required>
        <input type="number" step="0.1" name="discountRate" placeholder="Discount Rate (%)" required>
        <input type="number" step="0.1" name="maxValue" placeholder="Max Value" required>
        <button type="submit" name="action" value="add">Thêm Voucher</button>
    </form>
</body>
</html>
