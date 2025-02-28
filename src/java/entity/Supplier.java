package entity;

public class Supplier {
    private int id;
    private String supplierName;
    private String phone;
    private String address;
    private String email;
    
    public Supplier() {
    }

    public Supplier(int id, String supplierName, String phone, String address, String email) {
        this.id = id;
        this.supplierName = supplierName;
        this.phone = phone;
        this.address = address;
        this.email = email;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Supplier{" + "id=" + id + ", supplierName=" + supplierName + ", phone=" + phone + ", address=" + address + ", email=" + email + '}';
    }
}