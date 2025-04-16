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
public class IndexVbqpplRequest {
    Integer id;
    String content;
    String type;
    String name;
    Integer idParent;
    Integer idVbqppl;
}
