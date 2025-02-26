package entity;

public class Supplier {
    private int supplierID;
    private String supplierName;
    private int phone;
    private String address;
    private String email;

    public Supplier() {
    }

    public Supplier(int supplierID, String supplierName, int phone, String address, String email) {
        this.supplierID = supplierID;
        this.supplierName = supplierName;
        this.phone = phone;
        this.address = address;
        this.email = email;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getPhone() {
        return phone;
    }

    public void setPhone(int phone) {
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
}