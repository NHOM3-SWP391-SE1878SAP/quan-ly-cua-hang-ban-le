package entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Return {
    private int returnID;
    private int quantity;
    private String reason;
    private Date returnDate;
    private int orderId;
    private int employeeId;
    private Float refundAmount;

}