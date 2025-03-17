package entity;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Customer {
    private Integer id;
    private String customerName;
    private String phone;
    private String address;
    private Integer points;
}
