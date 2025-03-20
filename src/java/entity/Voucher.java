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
    private Integer usage_limit;
    private Integer usage_count;
    private Boolean status;
    private Date startDate;
    private Date endDate;
    
        public Voucher(int aInt, String string, int aInt0) {
        this.id = aInt;
        this.code = string;
        this.discountRate = aInt0;
    }
}