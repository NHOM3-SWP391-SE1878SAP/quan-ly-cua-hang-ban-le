package entity;

import java.util.Date;

public class Voucher {
    private int id;
    private String code;
    private int minOrder;
    private int discountRate;
    private int maxValue;
    private Date startDate;
    private Date endDate;

    public Voucher() {
    }

    public Voucher(int id, String code, int minOrder, int discountRate, int maxValue, Date startDate, Date endDate) {
        this.id = id;
        this.code = code;
        this.minOrder = minOrder;
        this.discountRate = discountRate;
        this.maxValue = maxValue;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public Voucher(int aInt, String string, int aInt0) {
        this.id = aInt;
        this.code = string;
        this.discountRate = aInt0;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getMinOrder() {
        return minOrder;
    }

    public void setMinOrder(int minOrder) {
        this.minOrder = minOrder;
    }

    public int getDiscountRate() {
        return discountRate;
    }

    public void setDiscountRate(int discountRate) {
        this.discountRate = discountRate;
    }

    public int getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(int maxValue) {
        this.maxValue = maxValue;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}