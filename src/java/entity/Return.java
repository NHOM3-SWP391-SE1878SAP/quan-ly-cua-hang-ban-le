package entity;

import java.util.Date;

public class Return {
    private int returnID;
    private int quantity;
    private String reason;
    private Date returnDate;
    private Order order;
    private Employee employee;

    public Return() {
    }

    public Return(int returnID, int quantity, String reason, Date returnDate, Order order, Employee employee) {
        this.returnID = returnID;
        this.quantity = quantity;
        this.reason = reason;
        this.returnDate = returnDate;
        this.order = order;
        this.employee = employee;
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

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
}
