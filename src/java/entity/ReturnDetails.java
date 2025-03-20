package entity;

public class ReturnDetails {
    private int id;
    private int returnId;
    private int orderDetailsId;
    private int quantity;
    
    // Constructor mặc định
    public ReturnDetails() {
    }
    
    // Constructor đầy đủ tham số
    public ReturnDetails(int id, int returnId, int orderDetailsId, int quantity) {
        this.id = id;
        this.returnId = returnId;
        this.orderDetailsId = orderDetailsId;
        this.quantity = quantity;
    }
    
    // Getters và Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getReturnId() {
        return returnId;
    }
    
    public void setReturnId(int returnId) {
        this.returnId = returnId;
    }
    
    public int getOrderDetailsId() {
        return orderDetailsId;
    }
    
    public void setOrderDetailsId(int orderDetailsId) {
        this.orderDetailsId = orderDetailsId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    @Override
    public String toString() {
        return "ReturnDetails{" +
                "id=" + id +
                ", returnId=" + returnId +
                ", orderDetailsId=" + orderDetailsId +
                ", quantity=" + quantity +
                '}';
    }
} 