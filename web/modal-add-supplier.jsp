<%-- 
    Document   : modal-add-supplier
    Created on : Feb 12, 2025, 5:44:01 PM
    Author     : TNO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="modal fade" id="addSupplierModal" tabindex="-1" aria-labelledby="addSupplierModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addSupplierModalLabel">Add Supplier</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierCode" class="form-label">Supplier Code</label>
                            <input type="text" class="form-control" id="supplierCode">
                        </div>
                        <div class="col-md-6">
                            <label for="supplierName" class="form-label">Supplier Name</label>
                            <input type="text" class="form-control" id="supplierName">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierPhone" class="form-label">Phone</label>
                            <input type="text" class="form-control" id="supplierPhone">
                        </div>
                        <div class="col-md-6">
                            <label for="supplierAddress" class="form-label">Address</label>
                            <input type="text" class="form-control" id="supplierAddress">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierArea" class="form-label">Area</label>
                            <input type="text" class="form-control" id="supplierArea">
                        </div>
                        <div class="col-md-6">
                            <label for="supplierWard" class="form-label">Ward</label>
                            <input type="text" class="form-control" id="supplierWard">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierBranch" class="form-label">Branch</label>
                            <input type="text" class="form-control" id="supplierBranch">
                        </div>
                        <div class="col-md-6">
                            <label for="supplierEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="supplierEmail">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierCompany" class="form-label">Company</label>
                            <input type="text" class="form-control" id="supplierCompany">
                        </div>
                        <div class="col-md-6">
                            <label for="supplierTaxCode" class="form-label">Tax Code</label>
                            <input type="text" class="form-control" id="supplierTaxCode">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="supplierGroup" class="form-label">Supplier Group</label>
                            <select class="form-control" id="supplierGroup">
                                <option value="">Select Group</option>
                                <option value="group1">Group 1</option>
                                <option value="group2">Group 2</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="supplierNote" class="form-label">Note</label>
                            <textarea class="form-control" id="supplierNote"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary">Save</button>
            </div>
        </div>
    </div>
</div>
