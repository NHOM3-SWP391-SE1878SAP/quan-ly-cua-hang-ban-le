<!-- Import Supplier Modal -->
<div class="modal fade" id="importSupplierModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Import Suppliers</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="supplier" method="POST" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="action" value="import">
                    
                    <div class="mb-3">
                        <label for="file" class="form-label">Select Excel File</label>
                        <input type="file" class="form-control" id="file" name="file" accept=".xlsx,.xls" required>
                        <div class="form-text">Only Excel files (.xlsx, .xls) are allowed</div>
                    </div>
                    
                    <div class="alert alert-info">
                        <h6>Import Guidelines:</h6>
                        <ul>
                            <li>File must be in Excel format</li>
                            <li>First row should contain headers</li>
                            <li>Required columns: Code, Name, Phone, Email, Address</li>
                            <li>Optional columns: Group</li>
                        </ul>
                        <p class="mb-0">
                            <a href="assets/templates/supplier-import-template.xlsx" class="alert-link">
                                Download template file
                            </a>
                        </p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Import</button>
                </div>
            </form>
        </div>
    </div>
</div>