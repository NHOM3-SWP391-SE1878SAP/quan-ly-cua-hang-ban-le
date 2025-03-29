package entity;

import java.util.Date;

public class Supplier {

    private int id;
    private String supplierCode;
    private String supplierName;
    private String companyName;
    private String taxCode;
    private String phone;
    private String address;
    private String email;
    private String region;
    private String ward;
    private String createdBy;
    private Date createdDate;
    private String notes;
    private boolean status;
    private String supplierGroup;
    private double totalPurchase;
    private double currentDebt;
    private GoodReceipt goodReceipt;

    public Supplier() {
        
    }

    public Supplier(int id, String supplierCode, String supplierName, String companyName, String taxCode, String phone, String address, String email, String region, String ward, String createdBy, Date createdDate, String notes, boolean status, String supplierGroup, double totalPurchase, double currentDebt, GoodReceipt goodReceipt) {
        this.id = id;
        this.supplierCode = supplierCode;
        this.supplierName = supplierName;
        this.companyName = companyName;
        this.taxCode = taxCode;
        this.phone = phone;
        this.address = address;
        this.email = email;
        this.region = region;
        this.ward = ward;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.notes = notes;
        this.status = status;
        this.supplierGroup = supplierGroup;
        this.totalPurchase = totalPurchase;
        this.currentDebt = currentDebt;
        this.goodReceipt = goodReceipt;
    }
    
    public GoodReceipt getGoodReceipt() {
        return goodReceipt;
    }

    public void setGoodReceipt(GoodReceipt goodReceipt) {
        this.goodReceipt = goodReceipt;
    }

    
    public Supplier(int id, String supplierCode, String supplierName, String companyName, String taxCode, String phone, String address, String email, String region, String ward, String createdBy, Date createdDate, String notes, boolean status, String supplierGroup, double totalPurchase, double currentDebt) {
        this.id = id;
        this.supplierCode = supplierCode;
        this.supplierName = supplierName;
        this.companyName = companyName;
        this.taxCode = taxCode;
        this.phone = phone;
        this.address = address;
        this.email = email;
        this.region = region;
        this.ward = ward;
        this.createdBy = createdBy;
        this.createdDate = createdDate;
        this.notes = notes;
        this.status = status;
        this.supplierGroup = supplierGroup;
        this.totalPurchase = totalPurchase;
        this.currentDebt = currentDebt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSupplierCode() {
        return supplierCode;
    }

    public void setSupplierCode(String supplierCode) {
        this.supplierCode = supplierCode;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName == null ? null : companyName.trim();
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode == null ? null : taxCode.trim();
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

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getSupplierGroup() {
        return supplierGroup;
    }

    public void setSupplierGroup(String supplierGroup) {
        this.supplierGroup = supplierGroup;
    }

    public double getTotalPurchase() {
        return totalPurchase;
    }

    public void setTotalPurchase(double totalPurchase) {
        this.totalPurchase = totalPurchase;
    }

    public double getCurrentDebt() {
        return currentDebt;
    }

    public void setCurrentDebt(double currentDebt) {
        this.currentDebt = currentDebt;
    }

    @Override
    public String toString() {
        return "Supplier{" + "id=" + id + ", supplierName=" + supplierName
                + ", companyName=" + companyName + ", totalPurchase=" + totalPurchase
                + ", currentDebt=" + currentDebt + '}';
    }
}
