<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Add Customer</title>
    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
    <div class="container mt-5">
        <h2>Add New Customer</h2>
        <form action="AddCustomerServlet" method="post">
            <div class="mb-3">
                <label>Name:</label>
                <input type="text" name="customerName" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Phone:</label>
                <input type="text" name="phone" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Address:</label>
                <input type="text" name="address" class="form-control">
            </div>
            <div class="mb-3">
                <label>Points:</label>
                <input type="number" name="points" class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Add</button>
            <a href="CustomerServlet" class="btn btn-secondary">Back</a>
        </form>
    </div>
</body>
</html>
