/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class Attendance {
    private int id;
    private Date workDate;
    private boolean isPresent;
    private Employee employeesID;
    private Shift shiftsID;

    public Attendance() {
    }

    public Attendance(int id, Date workDate, boolean isPresent, Employee employeesID, Shift shiftsID) {
        this.id = id;
        this.workDate = workDate;
        this.isPresent = isPresent;
        this.employeesID = employeesID;
        this.shiftsID = shiftsID;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public boolean isPresent() {
        return isPresent;
    }

    public void setPresent(boolean isPresent) {
        this.isPresent = isPresent;
    }

    public Employee getEmployeesID() {
        return employeesID;
    }

    public void setEmployeesID(Employee employeesID) {
        this.employeesID = employeesID;
    }

    public Shift getShiftsID() {
        return shiftsID;
    }

    public void setShiftsID(Shift shiftsID) {
        this.shiftsID = shiftsID;
    }
    
    

   
}

    