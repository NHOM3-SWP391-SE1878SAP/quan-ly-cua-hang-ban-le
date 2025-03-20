package entity;

import java.util.Date;

public class Payment {
    private int paymentID;
    private Date paymentDate;
    private String paymentMethods;

    public Payment() {
    }

    public Payment(int paymentID, Date paymentDate, String paymentMethods) {
        this.paymentID = paymentID;
        this.paymentDate = paymentDate;
        this.paymentMethods = paymentMethods;
    }
        public Payment(int aInt, String string) {
        this.paymentID = aInt;
        this.paymentMethods = string;
    }
    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getPaymentMethods() {
        return paymentMethods;
    }

    public void setPaymentMethods(String paymentMethods) {
        this.paymentMethods = paymentMethods;
    }
}