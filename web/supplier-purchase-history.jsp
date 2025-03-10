<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title>Lịch sử nhập/trả hàng - SLIM</title>
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

    <style>
      .badge {
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 500;
      }

      .badge-active {
        background-color: #00c853;
        color: white;
      }

      .badge-inactive {
        background-color: #757575;
        color: white;
      }

      .nav-tabs .nav-link {
        color: #666;
        font-weight: 500;
      }

      .nav-tabs .nav-link.active {
        color: #00c853;
        border-color: #00c853;
      }

      tr,
      td {
        text-align: center;
        vertical-align: middle;
      }
    </style>
  </head>

  <body>
    <!-- ======= Header ======= -->
    <%@include file="HeaderAdmin.jsp"%>

    <main id="main" class="main">
      <div class="pagetitle">
        <h1>Chi tiết nhà cung cấp</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="index.html">Home</a></li>
            <li class="breadcrumb-item">
              <a href="supplier?action=list">Nhà cung cấp</a>
            </li>
            <li class="breadcrumb-item active">Lịch sử nhập/trả hàng</li>
          </ol>
        </nav>
      </div>

      <section class="section">
        <div class="row">
          <div class="col-lg-3">
            <div class="card">
              <div class="card-body">
                <h5 class="card-title">Thao tác nhanh</h5>
                <div class="d-grid gap-2">
                  <button
                    type="button"
                    class="btn btn-primary"
                    onclick="window.location.href='supplier?action=view&id=${supplier.id}'"
                  >
                    <i class="bi bi-info-circle"></i> Thông tin nhà cung cấp
                  </button>
                  <button
                    type="button"
                    class="btn btn-success"
                    onclick="window.location.href='supplier?action=debt&id=${supplier.id}'"
                  >
                    <i class="bi bi-cash-coin"></i> Nợ cần trả NCC
                  </button>
                  <button
                    type="button"
                    class="btn btn-info text-white"
                    onclick="window.location.href='supplier?action=exportTransactions&id=${supplier.id}'"
                  >
                    <i class="bi bi-download"></i> Xuất thông tin
                  </button>
                </div>

                <hr />

                <h5 class="card-title">Lọc dữ liệu</h5>
                <form id="filterForm">
                  <div class="mb-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" class="form-control" name="fromDate" />
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" class="form-control" name="toDate" />
                  </div>
                  <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-select" name="status">
                      <option value="">Tất cả</option>
                      <option value="completed">Đã nhập hàng</option>
                      <option value="pending">Đang xử lý</option>
                      <option value="cancelled">Đã hủy</option>
                    </select>
                  </div>
                  <div class="d-grid">
                    <button type="submit" class="btn btn-primary">
                      <i class="bi bi-search"></i> Tìm kiếm
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
                  <h5 class="card-title mb-0">Lịch sử nhập/trả hàng</h5>
                </div>

                <ul class="nav nav-tabs mb-3">
                  <li class="nav-item">
                    <a
                      class="nav-link"
                      href="supplier?action=view&id=${supplier.id}"
                      >Thông tin</a
                    >
                  </li>
                  <li class="nav-item">
                    <a class="nav-link active" href="#"
                      >Lịch sử nhập/trả hàng</a
                    >
                  </li>
                  <li class="nav-item">
                    <a
                      class="nav-link"
                      href="supplier?action=debt&id=${supplier.id}"
                      >Nợ cần trả NCC</a
                    >
                  </li>
                </ul>

                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead>
                      <tr>
                        <th>Mã phiếu</th>
                        <th>Thời gian</th>
                        <!-- <th>Người tạo</th> -->
                        <th>Tổng tiền</th>
                        <!-- <th>Trạng thái</th> -->
                        <th>Thao tác</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${transactions}" var="item">
                        <tr>
                          <td>
                            <a href="#" class="text-primary"
                              >${item.goodReceiptID}</a
                            >
                          </td>
                          <td>${item.receivedDate}</td>
                          <td>
                            <fmt:formatNumber
                              value="${item.totalCost}"
                              type="currency"
                              currencySymbol="₫"
                            />
                          </td>
                          <td>
                            <a
                              href="#"
                              class="btn btn-sm btn-info text-white"
                              title="Chi tiết"
                            >
                              <i class="bi bi-eye"></i>
                            </a>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

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
  </body>
</html>
