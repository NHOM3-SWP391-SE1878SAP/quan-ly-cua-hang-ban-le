package model;

public class Customer {
    private int id;
    private String customerName;
    private String phone;
    private String address;
    private Integer points;

    // ✅ Constructor đầy đủ (Dùng khi lấy dữ liệu từ database)
    public Customer(int id, String customerName, String phone, String address, Integer points) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    // ✅ Constructor không có ID (Dùng khi tạo mới)
    public Customer(String customerName, String phone, String address, Integer points) {
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    // ✅ Constructor chỉ có ID (Dùng khi xóa)
    public Customer(int id) {
        this.id = id;
    }

    // ✅ Constructor rỗng
    public Customer() {}

    // ✅ Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Integer getPoints() { return points; }
    public void setPoints(Integer points) { this.points = points; }
}
