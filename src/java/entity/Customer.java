package entity;

public class Customer {
    private int id;
    private String customerName;
    private String phone;
    private String address;
    private int points;

    public Customer() {
    }

    public Customer(int id, String customerName, String phone, String address, int points) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    public Customer(int aInt, String string, String string0) {
        this.id = aInt;
        this.customerName = string;
        this.phone = string0;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }
}
