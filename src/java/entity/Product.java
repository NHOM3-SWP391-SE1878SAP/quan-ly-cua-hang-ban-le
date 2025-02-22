package entity;

/**
 * Entity class for Product
 */
public class Product {
    private int id;
    private String productName;
    private String productCode;
    private int unitPrice;
    private int stockQuantity;
    private boolean isAvailable;
    private String imageURL;
    private int categoryId;

    // Default Constructor
    public Product() {
    }

    // Constructor đầy đủ
    public Product(int id, String productName, String productCode, int unitPrice, int stockQuantity, boolean isAvailable, String imageURL, int categoryId) {
        this.id = id;
        this.productName = productName;
        this.productCode = productCode;
        this.unitPrice = unitPrice;
        this.stockQuantity = stockQuantity;
        this.isAvailable = isAvailable;
        this.imageURL = imageURL;
        this.categoryId = categoryId;
    }

    // Constructor không có ID (dùng khi thêm mới sản phẩm)
    public Product(String productName, String productCode, int unitPrice, int stockQuantity, boolean isAvailable, String imageURL, int categoryId) {
        this.productName = productName;
        this.productCode = productCode;
        this.unitPrice = unitPrice;
        this.stockQuantity = stockQuantity;
        this.isAvailable = isAvailable;
        this.imageURL = imageURL;
        this.categoryId = categoryId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(int unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isAvailable() {  // Getter đúng chuẩn Java
        return isAvailable;
    }

    public void setAvailable(boolean isAvailable) {  // Setter giữ nguyên tên thuộc tính
        this.isAvailable = isAvailable;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    // toString() method for debugging
    @Override
    public String toString() {
        return "Product{" +  
                "id=" + id +
                ", productName='" + productName + '\'' +
                ", productCode='" + productCode + '\'' +
                ", unitPrice=" + unitPrice +
                ", stockQuantity=" + stockQuantity +
                ", isAvailable=" + isAvailable +
                ", imageURL='" + imageURL + '\'' +
                ", categoryId=" + categoryId +
                '}';
    }
}
