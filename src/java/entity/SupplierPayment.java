package entity;

import java.util.Date;

public class SupplierPayment {
    private int supplierPaymentID;
    private int amountPaid;
    private Date paymentDate;
    private String paymentMethod;
    private String notes;
    private Supplier supplier;

    public SupplierPayment() {
    }

    public SupplierPayment(int supplierPaymentID, int amountPaid, Date paymentDate, String paymentMethod, String notes, Supplier supplier) {
        this.supplierPaymentID = supplierPaymentID;
        this.amountPaid = amountPaid;
        this.paymentDate = paymentDate;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
        this.supplier = supplier;
    }

    public int getSupplierPaymentID() {
        return supplierPaymentID;
    }

    public void setSupplierPaymentID(int supplierPaymentID) {
        this.supplierPaymentID = supplierPaymentID;
    }

    public int getAmountPaid() {
        return amountPaid;
    }

    public void setAmountPaid(int amountPaid) {
        this.amountPaid = amountPaid;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }
}