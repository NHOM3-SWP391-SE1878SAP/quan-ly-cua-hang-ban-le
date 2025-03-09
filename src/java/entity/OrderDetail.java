package entity;

public class OrderDetail {

    private Integer orderDetailID;
    private Integer quantity;
    private Integer price;
    private Integer orderID;
    private Integer productID;

    // Constructor
    public OrderDetail(Integer orderDetailID, Integer quantity, Integer price, Integer orderID, Integer productID) {
        this.orderDetailID = orderDetailID;
        this.quantity = quantity;
        this.price = price;
        this.orderID = orderID;
        this.productID = productID;
    }

    public OrderDetail(int orderID, int productID, int quantity, int price) {
        this.orderID = orderID;
        this.productID = productID;
        this.quantity = quantity;
        this.price = price;
    }

    // Getters and Setters
    public Integer getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(Integer orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getProductID() {
        return productID;
    }

    public void setProductID(Integer productID) {
        this.productID = productID;
    }

    // toString method for logging or printing
    @Override
    public String toString() {
        return "OrderDetail{"
                + "orderDetailID=" + orderDetailID
                + ", quantity=" + quantity
                + ", price=" + price
                + ", orderID=" + orderID
                + ", productID=" + productID
                + '}';
    }
}
