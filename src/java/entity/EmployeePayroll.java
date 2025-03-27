package entity;

import java.util.Date;

public class EmployeePayroll {
    private int employeePayrollID;
    private Employee employee;
    private Payroll payroll;
    private int workDays;
    private int offDays;
    private Date payDate;
    
    public EmployeePayroll() {
    }

    public EmployeePayroll(int employeePayrollID, Employee employee, Payroll payroll, int workDays, int offDays, Date payDate) {
        this.employeePayrollID = employeePayrollID;
        this.employee = employee;
        this.payroll = payroll;
        this.workDays = workDays;
        this.offDays = offDays;
        this.payDate = payDate;
    }
    
    public EmployeePayroll(int employeePayrollID, Employee employee, Payroll payroll, int workDays, Date payDate) {
        this.employeePayrollID = employeePayrollID;
        this.employee = employee;
        this.payroll = payroll;
        this.workDays = workDays;
        this.payDate = payDate;
    }

    public int getEmployeePayrollID() {
        return employeePayrollID;
    }

    public void setEmployeePayrollID(int employeePayrollID) {
        this.employeePayrollID = employeePayrollID;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public Payroll getPayroll() {
        return payroll;
    }

    public void setPayroll(Payroll payroll) {
        this.payroll = payroll;
    }

    public int getWorkDays() {
        return workDays;
    }

    public void setWorkDays(int workDays) {
        this.workDays = workDays;
    }

    public Date getPayDate() {
        return payDate;
    }

    public void setPayDate(Date payDate) {
        this.payDate = payDate;
    }

    public int getOffDays() {
        return offDays;
    }

    public void setOffDays(int offDays) {
        this.offDays = offDays;
    }
    
}