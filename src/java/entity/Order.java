package entity;

import java.util.Date;

public class Order {

    private Integer orderID;
    private Date orderDate;
    private Integer totalAmount;
    private Integer customerID;
    private Integer employeeID;
    private Integer paymentID;
    private Integer voucherID;
    private String employeeName;
    private String customerName;

    // Constructor
    public Order(Integer orderID, Date orderDate, Integer totalAmount, Integer customerID,
            Integer employeeID, Integer paymentID, Integer voucherID) {
        this.orderID = orderID;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.customerID = customerID;
        this.employeeID = employeeID;
        this.paymentID = paymentID;
        this.voucherID = voucherID;
    }

    public Order() {
    }

    public Order(Date orderDate, int totalAmount, int customerID, int employeeID, int paymentID, int voucherID) {
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.customerID = customerID;
        this.employeeID = employeeID;
        this.paymentID = paymentID;
        this.voucherID = voucherID;
    }

    // Getters and Setters
    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Integer getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(Integer totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Integer getCustomerID() {
        return customerID;
    }

    public void setCustomerID(Integer customerID) {
        this.customerID = customerID;
    }

    public Integer getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(Integer employeeID) {
        this.employeeID = employeeID;
    }

    public Integer getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(Integer paymentID) {
        this.paymentID = paymentID;
    }

    public Integer getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(Integer voucherID) {
        this.voucherID = voucherID;
    }

    // Getters and Setters
    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    // toString method for logging or printing
    @Override
    public String toString() {
        return "Order{"
                + "orderID=" + orderID
                + ", orderDate=" + orderDate
                + ", totalAmount=" + totalAmount
                + ", customerID=" + customerID
                + ", employeeID=" + employeeID
                + ", paymentID=" + paymentID
                + ", voucherID=" + voucherID
                + '}';
    }
}
