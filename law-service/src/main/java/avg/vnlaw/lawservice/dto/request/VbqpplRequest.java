package avg.vnlaw.lawservice.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class VbqpplRequest {
    Integer id;
    String content;
    String type;
    String html;
}
