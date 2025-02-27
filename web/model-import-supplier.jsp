<%-- 
    Document   : model-import-supplier
    Created on : Feb 12, 2025, 5:51:51 PM
    Author     : TNO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="modal fade" id="importSupplierModal" tabindex="-1" aria-labelledby="importSupplierModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="importSupplierModalLabel">Import Suppliers</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="mb-3">
                        <a href="path/to/sample.xlsx" class="btn btn-link">Download Sample File: Excel file</a>
                    </div>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="debtUpdateOption" id="updateDebt" value="update">
                            <label class="form-check-label" for="updateDebt">
                                Update Ending Balance
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="debtUpdateOption" id="noUpdateDebt" value="noUpdate" checked>
                            <label class="form-check-label" for="noUpdateDebt">
                                Do Not Update Ending Balance
                            </label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="supplierFile" class="form-label">Select Data File</label>
                        <input class="form-control" type="file" id="supplierFile">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Import</button>
            </div>
        </div>
    </div>
</div>