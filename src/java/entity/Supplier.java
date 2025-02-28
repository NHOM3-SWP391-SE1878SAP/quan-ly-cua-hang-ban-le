package entity;

public class Supplier {
    private int id;
    private String supplierName;
    private String phone;
    private String address;
    private String email;
    private boolean isActive;
    private String supplierCode;
    private String supplierGroup;
    
    public Supplier() {
    }

    public Supplier(int id, String supplierName, String phone, String address, String email, boolean isActive, String supplierCode, String supplierGroup) {
        this.id = id;
        this.supplierName = supplierName;
        this.phone = phone;
        this.address = address;
        this.email = email;
        this.isActive = isActive;
        this.supplierCode = supplierCode;
        this.supplierGroup = supplierGroup;
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

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getSupplierCode() {
        return supplierCode;
    }

    public void setSupplierCode(String supplierCode) {
        this.supplierCode = supplierCode;
    }

    public String getSupplierGroup() {
        return supplierGroup;
    }

    public void setSupplierGroup(String supplierGroup) {
        this.supplierGroup = supplierGroup;
    }

    @Override
    public String toString() {
        return "Supplier{" + "id=" + id + ", supplierName=" + supplierName + ", phone=" + phone + ", address=" + address + ", email=" + email + ", isActive=" + isActive + ", supplierCode=" + supplierCode + ", supplierGroup=" + supplierGroup + '}';
    }
}