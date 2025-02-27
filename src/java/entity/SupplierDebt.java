package entity;

import java.util.Date;

public class SupplierDebt {
    private int supplierDebtID;
    private int totalDebt;
    private Date lastUpdate;
    private GoodReceipt goodReceipt;

    public SupplierDebt() {
    }

    public SupplierDebt(int supplierDebtID, int totalDebt, Date lastUpdate, GoodReceipt goodReceipt) {
        this.supplierDebtID = supplierDebtID;
        this.totalDebt = totalDebt;
        this.lastUpdate = lastUpdate;
        this.goodReceipt = goodReceipt;
    }

    public int getSupplierDebtID() {
        return supplierDebtID;
    }

    public void setSupplierDebtID(int supplierDebtID) {
        this.supplierDebtID = supplierDebtID;
    }

    public int getTotalDebt() {
        return totalDebt;
    }

    public void setTotalDebt(int totalDebt) {
        this.totalDebt = totalDebt;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
    }

    public GoodReceipt getGoodReceipt() {
        return goodReceipt;
    }

    public void setGoodReceipt(GoodReceipt goodReceipt) {
        this.goodReceipt = goodReceipt;
    }
}
