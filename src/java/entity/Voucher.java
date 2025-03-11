package entity;

import java.time.LocalDate;

public class Voucher {
    private int id;
    private String code;
    private int minOrder;
    private int discountRate;
    private int maxValue;
    private LocalDate startDate;
    private LocalDate endDate;

    // 🛠 Constructor đầy đủ (Dùng khi lấy dữ liệu từ database)
    public Voucher(int id, String code, int minOrder, int discountRate, int maxValue, LocalDate startDate, LocalDate endDate) {
        this.id = id;
        this.code = code;
        this.minOrder = minOrder;
        this.discountRate = discountRate;
        this.maxValue = maxValue;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // 🛠 Constructor không có ID (Dùng khi tạo mới)
    public Voucher(String code, int minOrder, int discountRate, int maxValue, LocalDate startDate, LocalDate endDate) {
        this.code = code;
        this.minOrder = minOrder;
        this.discountRate = discountRate;
        this.maxValue = maxValue;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // 🛠 Constructor chỉ có ID (Dùng khi cần xóa)
    public Voucher(int id) {
        this.id = id;
    }

    // 🛠 Constructor rỗng (Dùng khi tạo object trước rồi gán giá trị sau)
    public Voucher() {}

    // ✅ Getter & Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public int getMinOrder() { return minOrder; }
    public void setMinOrder(int minOrder) { this.minOrder = minOrder; }

    public int getDiscountRate() { return discountRate; }
    public void setDiscountRate(int discountRate) { this.discountRate = discountRate; }

    public int getMaxValue() { return maxValue; }
    public void setMaxValue(int maxValue) { this.maxValue = maxValue; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
}