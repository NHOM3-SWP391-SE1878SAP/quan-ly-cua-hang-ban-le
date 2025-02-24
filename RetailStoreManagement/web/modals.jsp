<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Modal -->
<div class="modal fade" id="customerModal" tabindex="-1" aria-labelledby="customerModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="customerModalLabel">Customer Form</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="customer-form" action="CustomerServlet" method="post">
                    <input type="hidden" name="id" id="customer-id">

                    <div class="mb-3">
                        <label for="customer-name" class="form-label">Customer Name</label>
                        <input type="text" class="form-control" id="customer-name" name="customerName" required>
                    </div>

                    <div class="mb-3">
                        <label for="customer-phone" class="form-label">Phone</label>
                        <input type="text" class="form-control" id="customer-phone" name="phone" required>
                    </div>

                    <div class="mb-3">
                        <label for="customer-address" class="form-label">Address</label>
                        <input type="text" class="form-control" id="customer-address" name="address">
                    </div>

                    <div class="mb-3">
                        <label for="customer-points" class="form-label">Points</label>
                        <input type="number" class="form-control" id="customer-points" name="points">
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
