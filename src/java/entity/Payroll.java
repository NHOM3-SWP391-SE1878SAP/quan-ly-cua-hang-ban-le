package entity;

import java.util.Date;

public class Payroll {
    private int payrollID;
    private String monthYear;
    private Date startDate;
    private Date endDate;

    public Payroll() {
    }

    public Payroll(int payrollID, String monthYear, Date startDate, Date endDate) {
        this.payrollID = payrollID;
        this.monthYear = monthYear;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getPayrollID() {
        return payrollID;
    }

    public void setPayrollID(int payrollID) {
        this.payrollID = payrollID;
    }

    public String getMonthYear() {
        return monthYear;
    }

    public void setMonthYear(String monthYear) {
        this.monthYear = monthYear;
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