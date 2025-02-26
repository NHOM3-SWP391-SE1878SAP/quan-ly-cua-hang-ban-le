package entity;

import java.util.Date;

public class Employee {
    private int employeeID;
    private String employeeName;
    private String avatar;
    private Date dob;  // Date of Birth
    private String gender;
    private int salary;
    private String cccd;    
    private boolean isAvailable; // Availability status
    private Account account;

    public Employee() {
    }

    public Employee(int employeeID, String employeeName, String avatar, Date dob, String gender, int salary, String cccd, boolean isAvailable, Account account) {
        this.employeeID = employeeID;
        this.employeeName = employeeName;
        this.avatar = avatar;
        this.dob = dob;
        this.gender = gender;
        this.salary = salary;
        this.cccd = cccd;
        this.isAvailable = isAvailable;
        this.account = account;
    }

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

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getSalary() {
        return salary;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
        this.isAvailable = isAvailable;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    } 
}
