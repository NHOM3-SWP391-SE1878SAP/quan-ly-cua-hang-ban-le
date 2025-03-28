package entity;

public class AttendanceInfo {
    private Employee employee;
    private Shift shift;
    private boolean isMarked;
    private boolean isPresent;

    public AttendanceInfo(Employee employee, Shift shift, boolean isMarked, boolean isPresent) {
        this.employee = employee;
        this.shift = shift;
        this.isMarked = isMarked;
        this.isPresent = isPresent;
    }

    // Getters and Setters
    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public Shift getShift() {
        return shift;
    }

    public void setShift(Shift shift) {
        this.shift = shift;
    }

    public boolean isMarked() {
        return isMarked;
    }

    public void setMarked(boolean marked) {
        isMarked = marked;
    }

    public boolean isPresent() {
        return isPresent;
    }

    public void setPresent(boolean present) {
        isPresent = present;
    }
}