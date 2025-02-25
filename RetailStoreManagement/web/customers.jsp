<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.ArrayList" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
     if (customers == null) {  
        customers = (List<Customer>) session.getAttribute("customers");
        if (customers == null) {
            customers = new ArrayList<>();
        }
    } 

    // Lấy thông báo từ session
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message"); // Xóa thông báo sau khi hiển thị
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Customer Management</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>

        <header id="header" class="header fixed-top d-flex align-items-center">
            <div class="d-flex align-items-center justify-content-between">
                <a href="index.html" class="logo d-flex align-items-center">
                    <img src="assets/img/logo.png" alt="">
                    <span class="d-none d-lg-block">NiceAdmin</span>
                </a>
                <i class="bi bi-list toggle-sidebar-btn"></i>
            </div>
        </header>

        <aside id="sidebar" class="sidebar">
            <ul class="sidebar-nav" id="sidebar-nav">
                <li class="nav-item">
                    <a class="nav-link active" href="CustomerServlet">
                        <i class="bi bi-people"></i><span>Customer Management</span>
                    </a>
                </li>
            </ul>
        </aside>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Customer Management</h1>
            </div>

            <section class="section">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Customer List</h5>

                        <!-- Hiển thị thông báo -->
                        <% if (message != null) { %>
                        <div class="alert alert-info"><%= message %></div>
                        <% } %>

                        <!-- Search Form -->
                        <form action="CustomerServlet" method="get" class="row g-3">
                            <div class="col-md-6">
                                <input type="text" name="search" class="form-control" placeholder="Search by name or phone">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary">Search</button>
                            </div>
                        </form>

                        <!-- Customer Table -->
                        <table class="table table-bordered mt-3">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Points</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (customers.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="text-center">No customers found.</td>
                                </tr>
                                <% } else {
                            for (Customer c : customers) { %>
                                <tr>
                                    <td><%= c.getId() %></td>
                                    <td><%= c.getCustomerName() %></td>
                                    <td><%= c.getPhone() %></td>
                                    <td><%= c.getAddress() %></td>
                                    <td><%= c.getPoints() != null ? c.getPoints() : "N/A" %></td>
                                    <td>
                                        <a href="UpdateCustomerServlet?id=<%= c.getId() %>" class="btn btn-warning btn-sm">Edit</a>
                                        <form action="CustomerServlet" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% }
                        } %>
                            </tbody>
                        </table>

                        <!-- Add Customer Form -->
                        <h5 class="mt-4">Add New Customer</h5>
                        <form action="CustomerServlet" method="post">
                            <input type="hidden" name="action" value="add">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <input type="text" name="customerName" class="form-control" placeholder="Name" required>
                                </div>
                                <div class="col-md-2">
                                    <input type="text" name="phone" class="form-control" placeholder="Phone" required>
                                </div>
                                <div class="col-md-3">
                                    <input type="text" name="address" class="form-control" placeholder="Address">
                                </div>
                                <div class="col-md-2">
                                    <input type="number" name="points" class="form-control" placeholder="Points">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-success">Add</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </main>

        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    </body>
</html>