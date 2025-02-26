package entity;

import java.util.Date;

public class GoodReceipt {
    private int goodReceiptID;
    private Date receivedDate;
    private int totalCost;
    private Supplier supplier;

    public GoodReceipt() {
    }

    public GoodReceipt(int goodReceiptID, Date receivedDate, int totalCost, Supplier supplier) {
        this.goodReceiptID = goodReceiptID;
        this.receivedDate = receivedDate;
        this.totalCost = totalCost;
        this.supplier = supplier;
    }

    public int getGoodReceiptID() {
        return goodReceiptID;
    }

    public void setGoodReceiptID(int goodReceiptID) {
        this.goodReceiptID = goodReceiptID;
    }

    public Date getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.receivedDate = receivedDate;
    }

    public int getTotalCost() {
        return totalCost;
    }

    public void setTotalCost(int totalCost) {
        this.totalCost = totalCost;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }
}