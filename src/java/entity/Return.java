package entity;

import java.util.Date;

public class Return {
    private int returnID;
    private int quantity;
    private String reason;
    private Date returnDate;
    private int orderId;
    private int employeeId;
    private Float refundAmount;

    public Return() {
    }

    public Return(int returnID, int quantity, String reason, Date returnDate, int orderId, int employeeId, Float refundAmount) {
        this.returnID = returnID;
        this.quantity = quantity;
        this.reason = reason;
        this.returnDate = returnDate;
        this.orderId = orderId;
        this.employeeId = employeeId;
        this.refundAmount = refundAmount;
    }

    public int getReturnID() {
        return returnID;
    }

    public void setReturnID(int returnID) {
        this.returnID = returnID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(Date returnDate) {
        this.returnDate = returnDate;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public Float getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(Float refundAmount) {
        this.refundAmount = refundAmount;
    }

}