
package entity;


public class ReportOrderProduct {
    private int productID;
    private String reportDate; // Ngày hoặc tháng tùy theo nhóm
    private int totalRevenue;
    private int soldQuantity;
    //private int productID;
    private String productName;

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    
    public ReportOrderProduct(int productID, String reportDate, int totalRevenue, int soldQuantity, String productName) {
        this.productID = productID;
        this.reportDate = reportDate;
        this.totalRevenue = totalRevenue;
        this.soldQuantity = soldQuantity;
        
        this.productName = productName;
    }
    

//    public int getOrderID() {
//        return OrderID;
//    }
//
//    public void setOrderID(int OrderID) {
//        this.OrderID = OrderID;
//    }

    public String getReportDate() {
        return reportDate;
    }

    public void setReportDate(String reportDate) {
        this.reportDate = reportDate;
    }

    public int getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(int totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }
    

}

