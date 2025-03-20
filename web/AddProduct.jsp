<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Vector"%>
<%@page import="entity.Product"%>
<%@page import="entity.Category, model.DAOProduct"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm sản phẩm</title>
        <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="assets/css/style.css" rel="stylesheet">
    </head>
    <body>
        <%@include file="HeaderAdmin.jsp"%>

        <main id="main" class="main">
            <div class="pagetitle">
                <h1>Thêm sản phẩm</h1>
                <nav>
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="ProductsControllerURL?service=listAll">Quản lý sản phẩm</a></li>
                        <li class="breadcrumb-item active">Thêm sản phẩm</li>
                    </ol>
                </nav>
            </div>

            <section class="section">
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Thêm sản phẩm mới</h5>

                                <%-- Hiển thị thông báo lỗi nếu mã sản phẩm trùng --%>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger" role="alert">
                                        ${error}
                                    </div>
                                </c:if>

                                <form action="ProductsControllerURL" method="post" onsubmit="return validateForm()">
                                    <input type="hidden" name="service" value="addProduct">
                                    <div class="mb-3">
                                        <label for="productName" class="form-label">Tên sản phẩm</label>
                                        <input type="text" class="form-control" id="productName" name="productName" placeholder="ABC" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="productCode" class="form-label">Mã sản phẩm</label>
                                        <input type="text" class="form-control" id="productCode" name="productCode" placeholder="ABC001" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Giá (VNĐ)</label>
                                        <input type="number" class="form-control" id="price" name="price" min="0" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="stockQuantity" class="form-label">Số lượng tồn kho</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" min="0" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label">Hình ảnh</label>
                                        <input type="text" class="form-control" id="imageURL" name="imageURL" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="categoryId" class="form-label">Loại hàng</label>
                                        <select class="form-control" id="categoryId" name="categoryId" required>
                                            <option value="">Chọn loại hàng</option>
                                            <%
                                                DAOProduct daoP = new DAOProduct();
                                                Vector<Category> categories = daoP.getAllCategories();
                                                    for (Category cat : categories) {
                                            %>
                                            <option value="<%= cat.getCategoryID() %>"><%= cat.getCategoryName() %></option>
                                            <%
                                                    }
                                            %>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                                    <a href="ProductsControllerURL?service=listAll" class="btn btn-secondary">Quay lại</a>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <script>
            function validateForm() {
                let productName = document.getElementById("productName").value.trim();
                let productCode = document.getElementById("productCode").value.trim();
                let price = document.getElementById("price").value;
                let stockQuantity = document.getElementById("stockQuantity").value;

                if (productName.length < 3) {
                    alert("Tên sản phẩm phải có ít nhất 3 ký tự.");
                    return false;
                }
                if (!/^[A-Z0-9]+$/.test(productCode)) {
                    alert("Mã sản phẩm chỉ được chứa chữ in hoa và số.");
                    return false;
                }
                return true;
            }
        </script>
    </body>
</html>
