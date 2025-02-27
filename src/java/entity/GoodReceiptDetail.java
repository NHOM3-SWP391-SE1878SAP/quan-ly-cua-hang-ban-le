package entity;

import java.util.Date;

public class GoodReceiptDetail {
    private int goodReceiptDetailID;
    private String batchNumber;
    private int quantityReceived;
    private int unitCost;
    private Date expirationDate;
    private GoodReceipt goodReceipt;
    private Product product;

    public GoodReceiptDetail() {
    }

    public GoodReceiptDetail(int goodReceiptDetailID, String batchNumber, int quantityReceived, int unitCost, Date expirationDate, GoodReceipt goodReceipt, Product product) {
        this.goodReceiptDetailID = goodReceiptDetailID;
        this.batchNumber = batchNumber;
        this.quantityReceived = quantityReceived;
        this.unitCost = unitCost;
        this.expirationDate = expirationDate;
        this.goodReceipt = goodReceipt;
        this.product = product;
    }

    public int getGoodReceiptDetailID() {
        return goodReceiptDetailID;
    }

    public void setGoodReceiptDetailID(int goodReceiptDetailID) {
        this.goodReceiptDetailID = goodReceiptDetailID;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public int getQuantityReceived() {
        return quantityReceived;
    }

    public void setQuantityReceived(int quantityReceived) {
        this.quantityReceived = quantityReceived;
    }

    public int getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(int unitCost) {
        this.unitCost = unitCost;
    }

    public Date getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(Date expirationDate) {
        this.expirationDate = expirationDate;
    }

    public GoodReceipt getGoodReceipt() {
        return goodReceipt;
    }

    public void setGoodReceipt(GoodReceipt goodReceipt) {
        this.goodReceipt = goodReceipt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}