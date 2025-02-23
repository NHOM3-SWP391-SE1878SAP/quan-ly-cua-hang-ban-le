package model;

import dao.VoucherDAO;
import java.time.LocalDateTime;
import java.util.Random;

public class Voucher {
    private int id;
    private String code;
    private double minOrder;
    private float discountRate;
    private double maxValue;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    public Voucher() {}

    public Voucher(int id, String code, double minOrder, float discountRate, double maxValue, LocalDateTime startDate, LocalDateTime endDate) {
        this.id = id;
        this.code = code;
        this.minOrder = minOrder;
        this.discountRate = discountRate;
        this.maxValue = maxValue;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Tạo mã voucher ngẫu nhiên và đảm bảo không trùng lặp
    public static String generateUniqueVoucherCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code;
        Random rand = new Random();
        VoucherDAO voucherDAO = new VoucherDAO(); // Tạo đối tượng DAO để kiểm tra mã

        do {
            code = new StringBuilder();
            for (int i = 0; i < 10; i++) {
                code.append(chars.charAt(rand.nextInt(chars.length())));
            }
        } while (voucherDAO.checkIfCodeExists(code.toString())); // Kiểm tra trùng

        return code.toString();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public double getMinOrder() { return minOrder; }
    public void setMinOrder(double minOrder) { this.minOrder = minOrder; }
    public float getDiscountRate() { return discountRate; }
    public void setDiscountRate(float discountRate) { this.discountRate = discountRate; }
    public double getMaxValue() { return maxValue; }
    public void setMaxValue(double maxValue) { this.maxValue = maxValue; }
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
}
