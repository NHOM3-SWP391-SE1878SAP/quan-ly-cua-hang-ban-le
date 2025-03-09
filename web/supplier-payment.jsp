<%@page contentType="text/html" pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />

    <title>Nợ cần trả NCC - SLIM</title>
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
            <li class="breadcrumb-item active">Nợ cần trả NCC</li>
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
                    onclick="window.location.href='supplier?action=history&id=${supplier.id}'"
                  >
                    <i class="bi bi-clock-history"></i> Lịch sử nhập/trả hàng
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

                <div class="text-center mb-3">
                  <div class="fs-5">Nợ hiện tại</div>
                  <div class="fs-4 text-danger">
                    <fmt:formatNumber
                      value="${supplier.currentDebt}"
                      type="currency"
                      currencySymbol="₫"
                    />
                  </div>
                </div>

                <div class="mb-3">
                  <label class="form-label">Tổng mua</label>
                  <div class="fs-5 text-end">
                    <fmt:formatNumber
                      value="${supplier.totalPurchase}"
                      type="currency"
                      currencySymbol="₫"
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-lg-9">
            <div class="card">
              <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                  <h5 class="card-title mb-0">Nợ cần trả nhà cung cấp</h5>
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
                    <a
                      class="nav-link"
                      href="supplier?action=history&id=${supplier.id}"
                      >Lịch sử nhập/trả hàng</a
                    >
                  </li>
                  <li class="nav-item">
                    <a class="nav-link active" href="#">Nợ cần trả NCC</a>
                  </li>
                </ul>

                <div class="mb-3">
                  <form id="filterForm" class="row g-3">
                    <div class="col-md-4">
                      <input
                        type="date"
                        class="form-control"
                        name="fromDate"
                        value="${fromDate}"
                      />
                    </div>
                    <div class="col-md-4">
                      <input
                        type="date"
                        class="form-control"
                        name="toDate"
                        value="${toDate}"
                      />
                    </div>
                    <div class="col-md-4">
                      <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Lọc dữ liệu
                      </button>
                    </div>
                  </form>
                </div>

                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead>
                      <tr>
                        <th>Mã phiếu</th>
                        <th>Thời gian</th>
                        <th>Loại</th>
                        <th>Giá trị</th>
                        <th>Nợ cần trả</th>
                        <th>Thao tác</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${transactions}" var="trans">
                        <tr>
                          <td>
                            <a href="#" class="text-primary">${trans.id}</a>
                          </td>
                          <td>
                            <fmt:formatDate
                              value="${trans.date}"
                              pattern="dd/MM/yyyy HH:mm"
                            />
                          </td>
                          <td>${trans.type}</td>
                          <td class="text-end">
                            <fmt:formatNumber
                              value="${trans.amount}"
                              type="currency"
                              currencySymbol="₫"
                            />
                          </td>
                          <td class="text-end">
                            <fmt:formatNumber
                              value="${trans.remainingDebt}"
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

                <div class="d-flex gap-2 mt-3">
                  <button
                    class="btn btn-primary"
                    onclick="showAdjustmentModal()"
                  >
                    <i class="bi bi-arrow-repeat"></i> Điều chỉnh
                  </button>
                  <button class="btn btn-success" onclick="showPaymentModal()">
                    <i class="bi bi-cash-coin"></i> Thanh toán
                  </button>
                  <button
                    class="btn btn-info text-white"
                    onclick="showDiscountModal()"
                  >
                    <i class="bi bi-receipt"></i> Chiết khấu thanh toán
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Thanh toán công nợ</h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
            ></button>
          </div>
          <div class="modal-body">
            <form id="paymentForm" action="supplier" method="POST">
              <input type="hidden" name="action" value="makePayment" />
              <input type="hidden" name="supplierId" value="${supplier.id}" />

              <div class="mb-3">
                <label class="form-label">Số tiền thanh toán</label>
                <input
                  type="number"
                  class="form-control"
                  name="amount"
                  required
                  max="${supplier.currentDebt}"
                />
              </div>

              <div class="mb-3">
                <label class="form-label">Phương thức thanh toán</label>
                <select class="form-select" name="paymentMethod" required>
                  <option value="CASH">Tiền mặt</option>
                  <option value="BANK">Chuyển khoản</option>
                </select>
              </div>

              <div class="mb-3">
                <label class="form-label">Ghi chú</label>
                <textarea class="form-control" name="notes" rows="3"></textarea>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Hủy
            </button>
            <button type="submit" form="paymentForm" class="btn btn-primary">
              Xác nhận
            </button>
          </div>
        </div>
      </div>
    </div>

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
    <script src="assets/js/supplier-payment.js"></script>
    <script>
      // Apply currency formatting on load
      document.addEventListener("DOMContentLoaded", function () {
        // Format debt and total amount in header
        const debtElement = document.querySelector(".fs-5");
        const totalElement = debtElement.nextElementSibling;

        if (debtElement) {
          const debtValue = parseCurrency(
            debtElement.textContent.split(":")[1]
          );
          debtElement.innerHTML = "Nợ hiện tại: " + formatCurrency(debtValue);
        }

        if (totalElement) {
          const totalValue = parseCurrency(
            totalElement.textContent.split(":")[1]
          );
          totalElement.innerHTML = "Tổng mua: " + formatCurrency(totalValue);
        }

        // Format amounts in transaction table
        document.querySelectorAll(".text-end").forEach((cell) => {
          if (
            cell.textContent.trim() &&
            !isNaN(parseCurrency(cell.textContent))
          ) {
            const value = parseCurrency(cell.textContent);
            cell.textContent = formatCurrency(value);
          }
        });
      });
    </script>
  </body>
</html>
