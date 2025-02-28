<%-- Document : manage-supplier Created on : Feb 12, 2025, 5:02:19 PM Author :
TNO --%> <%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title>Manage Suppliers - NiceAdmin Bootstrap Template</title>
    <meta content="" name="description" />
    <meta content="" name="keywords" />

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon" />
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon" />

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect" />
    <link
      href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i"
      rel="stylesheet"
    />

    <!-- Vendor CSS Files -->
    <link
      href="assets/vendor/bootstrap/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="assets/vendor/bootstrap-icons/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet" />
    <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet" />
    <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet" />
    <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet" />

    <!-- Template Main CSS File -->
    <link href="assets/css/style.css" rel="stylesheet" />
  </head>

  <body>
    <!-- ======= Header ======= -->

    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>Manage Suppliers</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item">Manage</li>
            <li class="breadcrumb-item active">Suppliers</li>
          </ol>
        </nav>
      </div>
      <!-- End Page Title -->

      <section class="section">
        <div class="row">
          <div class="col-lg-3">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Filters</h5>
                <form id="searchForm" action="supplier" method="GET">
                  <input type="hidden" name="action" value="search" />
                  <div class="mb-3">
                    <input
                      type="text"
                      name="code"
                      class="form-control"
                      placeholder="Search by Code"
                    />
                  </div>
                  <div class="mb-3">
                    <input
                      type="text"
                      name="name"
                      class="form-control"
                      placeholder="Search by Name"
                    />
                  </div>
                  <div class="mb-3">
                    <input
                      type="text"
                      name="phone"
                      class="form-control"
                      placeholder="Search by Phone"
                    />
                  </div>
                  <div class="mb-3">
                    <label for="group">Supplier Group</label>
                    <div class="input-group">
                      <select class="form-control" id="group" name="group">
                        <option value="">All</option>
                        <option value="group1">Group 1</option>
                        <option value="group2">Group 2</option>
                      </select>
                      <button
                        class="btn btn-secondary"
                        type="button"
                        data-bs-toggle="modal"
                        data-bs-target="#addGroupModal"
                      >
                        <i class="bi bi-plus-circle"></i>
                      </button>
                    </div>
                  </div>
                  <div class="mb-3">
                    <button type="submit" class="btn btn-primary w-100">
                      <i class="bi bi-search"></i> Search
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <div class="col-lg-9">
            <div class="card">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <h5 class="card-title">Supplier List</h5>
                  <div>
                    <button
                      class="btn btn-primary"
                      data-bs-toggle="modal"
                      data-bs-target="#addSupplierModal"
                    >
                      <i class="bi bi-plus-circle"></i> Add Supplier
                    </button>
                    <button
                      class="btn btn-success"
                      data-bs-toggle="modal"
                      data-bs-target="#importSupplierModal"
                    >
                      <i class="bi bi-upload"></i> Import
                    </button>
                    <button class="btn btn-info">
                      <i class="bi bi-download"></i> Export
                    </button>
                  </div>
                </div>

                <!-- Table with stripped rows -->
                <table class="table datatable">
                  <thead>
                    <tr>
                      <th>Supplier Code</th>
                      <th>Name</th>
                      <th>Phone</th>
                      <th>Email</th>
                      <th>Address</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach items="${suppliers}" var="s">
                      <tr>
                        <td>${s.supplierCode}</td>
                        <td>${s.supplierName}</td>
                        <td>${s.phone}</td>
                        <td>${s.email}</td>
                        <td>${s.address}</td>
                        <td>
                          <button class="btn btn-primary btn-sm" onclick="editSupplier('${s.id}')">
                            <i class="bi bi-pencil"></i>
                          </button>
                          <button class="btn btn-danger btn-sm" onclick="deleteSupplier('${s.id}')">
                            <i class="bi bi-trash"></i>
                          </button>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
                <!-- End Table with stripped rows -->
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
    <!-- End #main -->

    <!-- Vendor JS Files -->
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>

    <!-- Add Supplier Modal -->
    <jsp:include page="modal-add-supplier.jsp"></jsp:include>
    <!-- End Add Supplier Modal -->

    <!-- Import Supplier Modal -->
    <jsp:include page="model-import-supplier.jsp"></jsp:include>
    <!-- End Import Supplier Modal -->

    <!-- Add Group Modal -->
    <jsp:include page="add-group-modal.jsp"></jsp:include>
    <!-- End Add Group Modal -->

    <!-- Custom JavaScript for Supplier Management -->
    <script>
      function editSupplier(id) {
        window.location.href = "supplier?action=edit&id=" + id;
      }

      function deleteSupplier(id) {
        if (confirm("Are you sure you want to delete this supplier?")) {
          window.location.href = "supplier?action=delete&id=" + id;
        }
      }

      // Initialize filter form submission
      document
        .getElementById("searchForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          const formData = new FormData(this);
          const params = new URLSearchParams();

          for (let pair of formData.entries()) {
            if (pair[1]) {
              params.append(pair[0], pair[1]);
            }
          }

          window.location.href = "supplier?" + params.toString();
        });
    </script>
  </body>
</html>
