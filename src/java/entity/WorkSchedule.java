package entity;

import java.util.Date;

public class WorkSchedule {
    private int scheduleID;
    private Date workDate;
    private String startTime;
    private String endTime;
    private Date checkIn;
    private Date checkOut;
    private Employee employee;

    public WorkSchedule() {
    }

    public WorkSchedule(int scheduleID, Date workDate, String startTime, String endTime, Date checkIn, Date checkOut, Employee employee) {
        this.scheduleID = scheduleID;
        this.workDate = workDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.employee = employee;
    }

    public int getScheduleID() {
        return scheduleID;
    }

    public void setScheduleID(int scheduleID) {
        this.scheduleID = scheduleID;
    }

    public Date getWorkDate() {
        return workDate;
    }

    public void setWorkDate(Date workDate) {
        this.workDate = workDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Date getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Date checkIn) {
        this.checkIn = checkIn;
    }

    public Date getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(Date checkOut) {
        this.checkOut = checkOut;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }
}