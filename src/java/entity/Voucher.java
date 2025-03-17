package entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Voucher {
    private Integer id;
    private String code;
    private Integer minOrder;
    private Integer discountRate;
    private Integer maxValue;
    private Date startDate;
    private Date endDate;
}