<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Customer" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    if (customer == null) {
        response.sendRedirect("customers.jsp?error=Customer%20not%20found");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Update Customer</title>
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
    <div class="container mt-5">
        <h2>Update Customer</h2>
        <form action="UpdateCustomerServlet" method="post">
            <input type="hidden" name="id" value="<%= customer.getId() %>">
            <div class="mb-3">
                <label>Name:</label>
                <input type="text" name="customerName" class="form-control" value="<%= customer.getCustomerName() %>" required>
            </div>
            <div class="mb-3">
                <label>Phone:</label>
                <input type="text" name="phone" class="form-control" value="<%= customer.getPhone() %>" required>
            </div>
            <div class="mb-3">
                <label>Address:</label>
                <input type="text" name="address" class="form-control" value="<%= customer.getAddress() %>">
            </div>
            <div class="mb-3">
                <label>Points:</label>
                <input type="number" name="points" class="form-control" value="<%= customer.getPoints() != null ? customer.getPoints() : "" %>">
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="CustomerServlet" class="btn btn-secondary">Back</a>
        </form>
    </div>
</body>
</html>
