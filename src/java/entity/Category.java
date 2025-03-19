package entity;

public class Category {
    private int categoryID;
    private String categoryName;
    private String description;
    private String image;
    private Product Product;
    
    public Category() {
    }

    public Category(int categoryID, String categoryName, String description, String image) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
    }

    public Category(int categoryID, String categoryName, String description, String image, Product Product) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.description = description;
        this.image = image;
        this.Product = Product;
    }

    public Product getProduct() {
        return Product;
    }

    public void setProduct(Product Product) {
        this.Product = Product;
    }
    
    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
