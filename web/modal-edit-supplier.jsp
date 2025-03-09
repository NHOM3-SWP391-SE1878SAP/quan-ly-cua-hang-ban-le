<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Edit Supplier Modal -->
<div class="modal fade" id="editSupplierModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Supplier</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="supplier" method="POST">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="edit-supplier-id">

                    <div class="mb-3">
                        <label for="edit-supplierName" class="form-label">Supplier Name</label>
                        <input type="text" class="form-control" id="edit-supplierName" name="supplierName" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="edit-phone" class="form-label">Phone</label>
                        <input type="tel" class="form-control" id="edit-phone" name="phone" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="edit-email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="edit-email" name="email" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="edit-address" class="form-label">Address</label>
                        <textarea class="form-control" id="edit-address" name="address" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    // Check if we should show edit modal
    <c:if test="${not empty editSupplier}">
        // Populate form fields with supplier data
        document.getElementById("edit-supplier-id").value = "${editSupplier.id}";
        document.getElementById("edit-supplierName").value = "${editSupplier.supplierName}";
        document.getElementById("edit-phone").value = "${editSupplier.phone}";
        document.getElementById("edit-email").value = "${editSupplier.email}";
        document.getElementById("edit-address").value = "${editSupplier.address}";
        
        // Show the modal
        new bootstrap.Modal(document.getElementById('editSupplierModal')).show();
    </c:if>
</script>
