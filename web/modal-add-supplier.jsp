<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Add Supplier Modal -->
<div class="modal fade" id="addSupplierModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-building-add me-2"></i>Thêm nhà cung cấp mới</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="supplier" method="POST" class="needs-validation" novalidate>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="supplierCode" class="form-label">Mã nhà cung cấp <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-upc-scan"></i></span>
                                <input type="text" class="form-control" id="supplierCode" name="supplierCode" required>
                                <div class="invalid-feedback">Vui lòng nhập mã nhà cung cấp</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="supplierName" class="form-label">Tên nhà cung cấp <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-vcard"></i></span>
                                <input type="text" class="form-control" id="supplierName" name="supplierName" required>
                                <div class="invalid-feedback">Vui lòng nhập tên nhà cung cấp</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="companyName" class="form-label">Tên công ty</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-building"></i></span>
                                <input type="text" class="form-control" id="companyName" name="companyName">
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="taxCode" class="form-label">Mã số thuế</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-receipt"></i></span>
                                <input type="text" class="form-control" id="taxCode" name="taxCode">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel" class="form-control" id="phone" name="phone" required>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" required>
                                <div class="invalid-feedback">Vui lòng nhập email hợp lệ</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="region" class="form-label">Khu vực</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" class="form-control" id="region" name="region">
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="ward" class="form-label">Phường/Xã</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-geo"></i></span>
                                <input type="text" class="form-control" id="ward" name="ward">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="address" class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-pin-map"></i></span>
                            <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ</div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="supplierGroup" class="form-label">Nhóm nhà cung cấp</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-tags"></i></span>
                                <select class="form-select" id="supplierGroup" name="supplierGroup">
                                    <option value="">-- Chọn nhóm --</option>
                                    <option value="Thực phẩm">Thực phẩm</option>
                                    <option value="Đồ uống">Đồ uống</option>
                                    <option value="Hàng hóa">Hàng hóa</option>
                                    <option value="Dịch vụ">Dịch vụ</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="status" class="form-label">Trạng thái</label>
                            <div class="form-check form-switch mt-2">
                                <input class="form-check-input" type="checkbox" id="status" name="status" checked>
                                <label class="form-check-label" for="status">Hoạt động</label>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="totalPurchase" class="form-label">Tổng mua hàng</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-cash-stack"></i></span>
                                <input type="number" class="form-control" id="totalPurchase" name="totalPurchase" value="0">
                                <span class="input-group-text">VNĐ</span>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="currentDebt" class="form-label">Công nợ hiện tại</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-currency-exchange"></i></span>
                                <input type="number" class="form-control" id="currentDebt" name="currentDebt" value="0">
                                <span class="input-group-text">VNĐ</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="notes" class="form-label">Ghi chú</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-sticky"></i></span>
                            <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                        </div>
                    </div>
                    
                    <!-- Các trường ẩn -->
                    <input type="hidden" name="createdBy" value="${sessionScope.user.username}">
                    <input type="hidden" name="createdDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                </div>
                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i>Đóng
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i>Thêm nhà cung cấp
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Thêm script để kích hoạt validation -->
<script>
    // Kích hoạt validation Bootstrap
    (function() {
        'use strict';
        window.addEventListener('load', function() {
            var forms = document.getElementsByClassName('needs-validation');
            var validation = Array.prototype.filter.call(forms, function(form) {
                form.addEventListener('submit', function(event) {
                    if (form.checkValidity() === false) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        }, false);
    })();
</script>
