<%-- 
    Document   : manage-supplier
    Created on : Feb 12, 2025, 5:02:19 PM
    Author     : TNO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>Manage Suppliers - NiceAdmin Bootstrap Template</title>
        <meta content="" name="description">
        <meta content="" name="keywords">

        <!-- Favicons -->
        <link href="assets/img/favicon.png" rel="icon">
        <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
        <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
        <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

        <!-- Template Main CSS File -->
        <link href="assets/css/style.css" rel="stylesheet">


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
                </div><!-- End Page Title -->

                <section class="section">
                    <div class="row">
                        <div class="col-lg-3">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Filters</h5>
                                    <div class="mb-3">
                                        <input type="text" class="form-control" placeholder="Search by Code">
                                    </div>
                                    <div class="mb-3">
                                        <input type="text" class="form-control" placeholder="Search by Name">
                                    </div>
                                    <div class="mb-3">
                                        <input type="text" class="form-control" placeholder="Search by Phone">
                                    </div>
                                    <div class="mb-3">
                                        <label for="group">Supplier Group</label>
                                        <div class="input-group">
                                            <select class="form-control" id="group">
                                                <option value="">All</option>
                                                <option value="group1">Group 1</option>
                                                <option value="group2">Group 2</option>
                                            </select>
                                            <button class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#addGroupModal"><i class="bi bi-plus-circle"></i></button>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="total-purchase">Total Purchase</label>
                                        <input type="text" class="form-control mb-2" placeholder="From">
                                        <input type="text" class="form-control" placeholder="To">
                                    </div>
                                    <div class="mb-3">
                                        <label for="current-location">Current Location</label>
                                        <input type="text" class="form-control mb-2" placeholder="From">
                                        <input type="text" class="form-control" placeholder="To">
                                    </div>
                                    <div class="mb-3">
                                        <label for="status">Status</label>
                                        <select class="form-control" id="status">
                                            <option value="all">All</option>
                                            <option value="active">Active</option>
                                            <option value="inactive">Inactive</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-9">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="card-title">Supplier List</h5>
                                        <div>
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSupplierModal"><i class="bi bi-plus-circle"></i> Add Supplier</button>
                                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#importSupplierModal"><i class="bi bi-upload"></i> Import</button>
                                            <button class="btn btn-info"><i class="bi bi-download"></i> Export</button>
                                        </div>
                                    </div>

                                    <!-- Table with stripped rows -->
                                    <table class="table datatable">
                                        <thead>
                                            <tr>
                                                <th>Name</th>
                                                <th>Ext.</th>
                                                <th>City</th>
                                                <th data-type="date" data-format="YYYY/DD/MM">Start Date</th>
                                                <th>Completion</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Unity Pugh</td>
                                                <td>9958</td>
                                                <td>Curicó</td>
                                                <td>2005/02/11</td>
                                                <td>37%</td>
                                            </tr>
                                            <tr>
                                                <td>Theodore Duran</td>
                                                <td>8971</td>
                                                <td>Dhanbad</td>
                                                <td>1999/04/07</td>
                                                <td>97%</td>
                                            </tr>
                                            <tr>
                                                <td>Kylie Bishop</td>
                                                <td>3147</td>
                                                <td>Norman</td>
                                                <td>2005/09/08</td>
                                                <td>63%</td>
                                            </tr>
                                            <tr>
                                                <td>Willow Gilliam</td>
                                                <td>3497</td>
                                                <td>Amqui</td>
                                                <td>2009/29/11</td>
                                                <td>30%</td>
                                            </tr>
                                            <tr>
                                                <td>Blossom Dickerson</td>
                                                <td>5018</td>
                                                <td>Kempten</td>
                                                <td>2006/11/09</td>
                                                <td>17%</td>
                                            </tr>
                                            <tr>
                                                <td>Elliott Snyder</td>
                                                <td>3925</td>
                                                <td>Enines</td>
                                                <td>2006/03/08</td>
                                                <td>57%</td>
                                            </tr>
                                            <tr>
                                                <td>Castor Pugh</td>
                                                <td>9488</td>
                                                <td>Neath</td>
                                                <td>2014/23/12</td>
                                                <td>93%</td>
                                            </tr>
                                            <tr>
                                                <td>Pearl Carlson</td>
                                                <td>6231</td>
                                                <td>Cobourg</td>
                                                <td>2014/31/08</td>
                                                <td>100%</td>
                                            </tr>
                                            <tr>
                                                <td>Deirdre Bridges</td>
                                                <td>1579</td>
                                                <td>Eberswalde-Finow</td>
                                                <td>2014/26/08</td>
                                                <td>44%</td>
                                            </tr>
                                            <tr>
                                                <td>Daniel Baldwin</td>
                                                <td>6095</td>
                                                <td>Moircy</td>
                                                <td>2000/11/01</td>
                                                <td>33%</td>
                                            </tr>
                                            <tr>
                                                <td>Phelan Kane</td>
                                                <td>9519</td>
                                                <td>Germersheim</td>
                                                <td>1999/16/04</td>
                                                <td>77%</td>
                                            </tr>
                                            <tr>
                                                <td>Quentin Salas</td>
                                                <td>1339</td>
                                                <td>Los Andes</td>
                                                <td>2011/26/01</td>
                                                <td>49%</td>
                                            </tr>
                                            <tr>
                                                <td>Armand Suarez</td>
                                                <td>6583</td>
                                                <td>Funtua</td>
                                                <td>1999/06/11</td>
                                                <td>9%</td>
                                            </tr>
                                            <tr>
                                                <td>Gretchen Rogers</td>
                                                <td>5393</td>
                                                <td>Moxhe</td>
                                                <td>1998/26/10</td>
                                                <td>24%</td>
                                            </tr>
                                            <tr>
                                                <td>Harding Thompson</td>
                                                <td>2824</td>
                                                <td>Abeokuta</td>
                                                <td>2008/06/08</td>
                                                <td>10%</td>
                                            </tr>
                                            <tr>
                                                <td>Mira Rocha</td>
                                                <td>4393</td>
                                                <td>Port Harcourt</td>
                                                <td>2002/04/10</td>
                                                <td>14%</td>
                                            </tr>
                                            <tr>
                                                <td>Drew Phillips</td>
                                                <td>2931</td>
                                                <td>Goes</td>
                                                <td>2011/18/10</td>
                                                <td>58%</td>
                                            </tr>
                                            <tr>
                                                <td>Emerald Warner</td>
                                                <td>6205</td>
                                                <td>Chiavari</td>
                                                <td>2002/08/04</td>
                                                <td>58%</td>
                                            </tr>
                                            <tr>
                                                <td>Colin Burch</td>
                                                <td>7457</td>
                                                <td>Anamur</td>
                                                <td>2004/02/01</td>
                                                <td>34%</td>
                                            </tr>
                                            <tr>
                                                <td>Russell Haynes</td>
                                                <td>8916</td>
                                                <td>Frascati</td>
                                                <td>2015/28/04</td>
                                                <td>18%</td>
                                            </tr>
                                            <tr>
                                                <td>Brennan Brooks</td>
                                                <td>9011</td>
                                                <td>Olmué</td>
                                                <td>2000/18/04</td>
                                                <td>2%</td>
                                            </tr>
                                            <tr>
                                                <td>Kane Anthony</td>
                                                <td>8075</td>
                                                <td>LaSalle</td>
                                                <td>2006/21/05</td>
                                                <td>93%</td>
                                            </tr>
                                            <tr>
                                                <td>Scarlett Hurst</td>
                                                <td>1019</td>
                                                <td>Brampton</td>
                                                <td>2015/07/01</td>
                                                <td>94%</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <!-- End Table with stripped rows -->

                                </div>
                            </div>
                        </div>
                    </div>
                </section>

            </main><!-- End #main -->



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

    </body>

</html>