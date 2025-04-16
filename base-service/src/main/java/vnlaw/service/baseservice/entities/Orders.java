package vnlaw.service.baseservice.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Data
@Setter
@Getter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Orders extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String id;

    @NotBlank(message = "User ID cannot be blank")
    String userId;

    @NotBlank(message = "Name cannot be blank")
    @Size(min = 2, max = 50, message = "Name must be between 2 and 50 characters")
    String name;

    @NotBlank(message = "Phone cannot be blank")
    @Pattern(regexp = "^\\+?\\d{7,15}$", message = "Phone number must be valid")
    String phone;

    @NotBlank(message = "Province cannot be blank")
    String province;

    @NotBlank(message = "District cannot be blank")
    String district;

    @NotBlank(message = "Ward cannot be blank")
    String ward;

    @NotBlank(message = "Address cannot be blank")
    String address;

    @FutureOrPresent(message = "Delivery time must be in the future or present")
    Timestamp deliveryTime;

    @Size(max = 500, message = "Note can be at most 500 characters")
    String note;

    @NotBlank(message = "Content cannot be blank")
    String content;

    @NotNull(message = "Total cannot be null")
    @Min(value = 0, message = "Total must be at least 0")
    Long total;

    @NotBlank(message = "Order code cannot be blank")
    String code;

    @NotNull(message = "Status cannot be null")
    @Min(value = 0, message = "Status must be at least 0")
    @Max(value = 10, message = "Status must be at most 10")
    Integer status;

    String billId;

    @Min(value = 0, message = "Discount ID must be at least 0")
    Long discountId;
}
