package vnlaw.service.customerservice.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@Getter
@Setter
@Entity
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Products extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @NotBlank(message = "Title cannot be blank")
    @Size(min = 2, max = 100, message = "Title must be between 2 and 100 characters")
    String title;

    @Size(max = 1000, message = "Description can be at most 1000 characters")
    String description;

    @NotBlank(message = "Product code cannot be blank")
    @Size(min = 3, max = 20, message = "Code must be between 3 and 20 characters")
    String code;

    @NotNull(message = "Category ID cannot be null")
    @Min(value = 1, message = "Category ID must be at least 1")
    Long categoryId;
}
