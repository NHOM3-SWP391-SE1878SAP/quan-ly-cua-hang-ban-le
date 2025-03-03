package entity;

public class OrderDetail {
    private int orderDetailID;
    private int quantity;
    private int price;
    private Order order;
    private Product product;

    public OrderDetail() {
    }

    public OrderDetail(int orderDetailID, int quantity, int price, Order order, Product product) {
        this.orderDetailID = orderDetailID;
        this.quantity = quantity;
        this.price = price;
        this.order = order;
        this.product = product;
    }

    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    
}
