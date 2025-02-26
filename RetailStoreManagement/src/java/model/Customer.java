package model;

public class Customer {
    private int id;
    private String customerName;
    private String phone;
    private String address;
    private Integer points; // Đổi từ double sang Integer để xử lý NULL

    // 🔹 Constructor không có id (Dùng khi thêm mới khách hàng)
    public Customer(String customerName, String phone, String address, Integer points) {
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    // 🔹 Constructor đầy đủ (Dùng khi lấy từ database hoặc cập nhật)
    public Customer(int id, String customerName, String phone, String address, Integer points) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = points;
    }

    // 🔹 Constructor không có `points` (Nếu có thể NULL)
    public Customer(String customerName, String phone, String address) {
        this.customerName = customerName;
        this.phone = phone;
        this.address = address;
        this.points = 0; // Giá trị mặc định nếu không nhập điểm
    }

    // Getter và Setter
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
