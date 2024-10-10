package vnlaw.service.customerservice.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.sql.Timestamp;

@Data
@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Users extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String id;

    @NotBlank(message = "Name cannot be blank")
    @Size(min = 2, max = 255, message = "Name must be have 2 characters")
    String name;

    @NotBlank(message = "Phone cannot be blank")
    @Pattern(regexp = "^\\+?\\d{7,15}$", message = "Phone number must be valid")
    String phone;


    @NotBlank(message = "Account cannot be blank")
    @Size(min = 5, max = 50, message = "Account must be between 5 and 50 characters")
    String account;

    @NotNull(message = "Birthday date cannot be null")
    @Pattern(regexp = "^\\d{2}-\\d{2}-\\d{4}$", message = "Birthday must follow the format DD-MM-YYYY")
    String birthdayDate;

    @NotBlank(message = "Address cannot be blank")
    String address;

    @NotBlank(message = "Ward cannot be blank")
    String ward;

    @NotBlank(message = "District cannot be blank")
    String district;

    @NotBlank(message = "Province cannot be blank")
    String province;

    @NotBlank(message = "Email cannot be blank")
    @Email(message = "Email should be valid")
    String email;

    Timestamp emailVerifiedAt;

    @NotBlank(message = "Password cannot be blank")
    @Size(min = 8, message = "Password must be at least 8 characters")
    String password;

    String rememberToken;
}
