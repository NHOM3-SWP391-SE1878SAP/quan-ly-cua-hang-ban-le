package entity;

/**
 * Entity class for Product
 */
public class Product {

    private int id;
    private String productName;
    private String productCode;
    private int price;
    private int stockQuantity;
    private boolean isAvailable;
    private String imageURL;
    private int categoryId;
    private Category category;
    private GoodReceiptDetail goodReceiptDetail;

    
    // Default Constructor
    public Product() {
    }

    public Product(int id, String productName, String productCode, int price, int stockQuantity, boolean isAvailable, String imageURL, int categoryId, Category category, GoodReceiptDetail goodReceiptDetail) {
        this.id = id;
        this.productName = productName;
        this.productCode = productCode;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.isAvailable = isAvailable;
        this.imageURL = imageURL;
        this.categoryId = categoryId;
        this.category = category;
        this.goodReceiptDetail = goodReceiptDetail;
    }
    
    public Product(int id, String productName, String productCode, int price, int stockQuantity, boolean isAvailable, String imageURL, Category category) {
        this.id = id;
        this.productName = productName;
        this.productCode = productCode;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.isAvailable = isAvailable;
        this.imageURL = imageURL;
        this.category = category;
    }

    public GoodReceiptDetail getGoodReceiptDetail() {
        return goodReceiptDetail;
    }

    public void setGoodReceiptDetail(GoodReceiptDetail goodReceiptDetail) {
        this.goodReceiptDetail = goodReceiptDetail;
    }
    
    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Product(int id, String productName, String productCode, int price, int stockQuantity, boolean isAvailable, String imageURL, int categoryId) {
        this.id = id;
        this.productName = productName;
        this.productCode = productCode;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.isAvailable = isAvailable;
        this.imageURL = imageURL;
        this.categoryId = categoryId;
    }

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

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public boolean isIsAvailable() {
        return isAvailable;
    }

    public void setIsAvailable(boolean isAvailable) {
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

}