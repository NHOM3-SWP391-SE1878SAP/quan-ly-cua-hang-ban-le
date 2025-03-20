package entity;

import java.util.Date;

public class SalesReport {
    private Date date;  // Sửa từ String thành Date
    private double revenue;

    public SalesReport() {}

    public SalesReport(Date date, double revenue) {
        this.date = date;
        this.revenue = revenue;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
