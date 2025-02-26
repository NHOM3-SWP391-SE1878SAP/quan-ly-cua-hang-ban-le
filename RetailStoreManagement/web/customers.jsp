<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 🔍 Lấy danh sách khách hàng từ session hoặc request
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
      if (customers == null) {
        customers = (List<Customer>) session.getAttribute("customers"); // Lấy từ session nếu cần
        if (customers == null) {
            customers = new ArrayList<>();
        }
    }

    // 📌 Lấy thông báo từ session
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message"); // Xóa sau khi hiển thị để tránh hiển thị lại
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

                        <!-- 🛠 Hiển thị thông báo từ session -->
                        <% if (message != null) { %>
                        <div class="alert alert-info"><%= message %></div>
                        <% } %>

                        <!-- 🔍 Search Form -->
                        <!-- 🔍 Form tìm kiếm -->
                        <form action="CustomerServlet" method="get" class="row g-3">
                            <div class="col-md-6">
                                <input type="text" name="search" class="form-control" placeholder="Search by name or phone" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary">Search</button>
                            </div>
                        </form>


                        <!-- 📋 Bảng danh sách khách hàng -->
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
                            <% if (customers != null && !customers.isEmpty()) { %>
                            <tbody>
                                <% for (Customer c : customers) { %>
                                <tr>
                                    <td><%= c.getId() %></td>
                                    <td><%= c.getCustomerName() %></td>
                                    <td><%= c.getPhone() %></td>
                                    <td><%= c.getAddress() %></td>
                                    <td><%= c.getPoints() != null ? c.getPoints() : "" %></td>
                                    <td>
                                        <button type="button" class="btn btn-warning btn-sm" 
                                                onclick="openEditModal('<%= c.getId() %>', '<%= c.getCustomerName() %>', '<%= c.getPhone() %>', '<%= c.getAddress() != null ? c.getAddress() : "" %>', '<%= c.getPoints() != null ? c.getPoints() : 0 %>')">
                                            Edit
                                        </button>


                                        <form action="CustomerServlet" method="post" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                            <% } else { %>
                            <tr>
                                <td colspan="6" class="text-center">No customers found.</td>
                            </tr>
                            <% } %>
                        </table>

                        <!-- 🛠 Form thêm khách hàng -->
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

        <!-- 🔵 MODAL CHỈNH SỬA -->
        <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Customer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="updateForm" action="CustomerServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" id="editId">

                            <label>Name:</label>
                            <input type="text" name="customerName" id="editName" class="form-control" required>

                            <label>Phone:</label>
                            <input type="text" name="phone" id="editPhone" class="form-control" required>

                            <label>Address:</label>
                            <input type="text" name="address" id="editAddress" class="form-control">

                            <label>Points:</label>
                            <input type="number" name="points" id="editPoints" class="form-control">

                            <button type="submit" class="btn btn-primary mt-3">Update</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.querySelector("#updateForm").addEventListener("submit", function (event) {
                let id = document.getElementById('editId').value;
                let name = document.getElementById('editName').value;
                let phone = document.getElementById('editPhone').value;
                let address = document.getElementById('editAddress').value;
                let points = document.getElementById('editPoints').value;

                console.log("🔹 Submitting Update - ID:", id, "Name:", name, "Phone:", phone, "Address:", address, "Points:", points);

                if (!id || id.trim() === "") {
                    alert("⚠️ Error: Missing customer ID!");
                    event.preventDefault(); // Chặn submit nếu thiếu ID
                }
            });

            function openEditModal(id, name, phone, address, points) {
                console.log("Editing Customer ID:", id);
                console.log("Received Data - Name:", name, "Phone:", phone, "Address:", address, "Points:", points);
                if (!id || id == "undefined") {
                    alert("⚠️ Error: Missing customer ID!");
                    return;
                }

                document.getElementById('editId').value = id;
                document.getElementById('editName').value = name;
                document.getElementById('editPhone').value = phone;
                document.getElementById('editAddress').value = address;
                document.getElementById('editPoints').value = points ? points : 0;
                new bootstrap.Modal(document.getElementById('editCustomerModal')).show();
            }


        </script>
        <<script>

        </script>
        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    </body>
</html>
