package model;

public class Customer {
    private int id;
    private String customerName;
    private String phone;
    private String address;
    private Integer points; // Đổi từ double sang Integer để xử lý NULL

    public Customer() {}

    public Customer(int id, String customerName, String phone, String address, Integer points) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public Integer getPoints() { return points; }  // Đổi từ double sang Integer
    public void setPoints(Integer points) { this.points = points; }
}
