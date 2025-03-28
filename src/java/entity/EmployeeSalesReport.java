package entity;

public class EmployeeSalesReport {
    private int employeeID;
    private String employeeName;
    private String reportDate; // Ngày hoặc tháng tùy theo nhóm
    private int orderCount;
    private int totalSales;

    public EmployeeSalesReport(int employeeID, String employeeName, String reportDate, 
                             int orderCount, int totalSales) {
        this.employeeID = employeeID;
        this.employeeName = employeeName;
        this.reportDate = reportDate;
        this.orderCount = orderCount;
        this.totalSales = totalSales;
    }

    // Getters và Setters
    public int getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getReportDate() {
        return reportDate;
    }

    public void setReportDate(String reportDate) {
        this.reportDate = reportDate;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public int getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(int totalSales) {
        this.totalSales = totalSales;
    }
}