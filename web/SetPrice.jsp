<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>
<%@page import="entity.GoodReceiptDetail"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật giá sản phẩm</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>

        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Cập nhật giá sản phẩm</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="HomeAdmin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Set Price</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Danh sách sản phẩm</h5>
                                                <a href="ExportSetPriceExcelServlet" class="btn btn-success mb-3">Xuất File Excel</a>

                        <form action="ProductsControllerURL?service=updatePriceBatch" method="post" onsubmit="convertFormattedPriceBeforeSubmit()">
                            <table class="table table-hover datatable mt-3">
                                <thead>
                                    <tr>
                                        <th scope="col" class="w-20">Mã hàng</th>
                                        <th scope="col" class="w-20">Tên hàng</th>
                                        <th scope="col" class="w-20">Số lô</th>
                                        <th scope="col" class="w-20">Giá vốn (VNĐ)</th>
                                        <th scope="col" class="w-20">Giá bán (VNĐ)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Vector<Product> productList = (Vector<Product>) request.getAttribute("data");
                                        if (productList != null && !productList.isEmpty()) {
                                            for (Product p : productList) {
                                                int unitCost = (p.getGoodReceiptDetail() != null) ? p.getGoodReceiptDetail().getUnitCost() : 0;
                                    %>
                                    <tr>
                                        <td style="align-content: center;"><%= p.getProductCode() %></td>
                                        <td style="align-content: center;"><%= p.getProductName() %></td>
                                        <td style="align-content: center;"><%= p.getGoodReceiptDetail().getBatchNumber() %></td>
                                        <td style="align-content: center;"><%= String.format("%,d", unitCost) %></td>
                                        <td>
                                            <input type="hidden" name="productIds" value="<%= p.getId() %>">
                                            <input type="text" class="form-control price-input" name="prices" 
                                                   value="<%= String.format("%,d", p.getPrice()) %>" 
                                                   min="0" oninput="formatPriceInput(this)" placeholder="1.000.000">
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center text-danger">Không có sản phẩm nào!</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>

                            <div class="d-flex justify-content-between mt-3">
                                <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                            </div>
                        </form>

                        <script>
                            // Định dạng số khi nhập vào
                            function formatPriceInput(input) {
                                let value = input.value.replace(/\D/g, ""); // Xóa ký tự không phải số
                                value = new Intl.NumberFormat('vi-VN').format(value); // Format chuẩn VN (1.000.000)
                                input.value = value;
                            }

                            // Trước khi submit, chuyển giá trị về số nguyên không có dấu .
                            function convertFormattedPriceBeforeSubmit() {
                                document.querySelectorAll(".price-input").forEach(input => {
                                    input.value = input.value.replace(/\./g, ""); // Xóa dấu .
                                });
                            }

                            // Đánh dấu hàng được chỉnh sửa
                            document.querySelectorAll(".price-input").forEach(input => {
                                input.addEventListener("input", function () {
                                    this.closest("tr").classList.add("highlight");
                                });
                            });
                        </script>
                    </div>
                </div>
            </section>
        </main>

        <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/main.js"></script>

    </body>
</html>