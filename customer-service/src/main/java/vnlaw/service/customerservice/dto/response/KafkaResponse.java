package vnlaw.service.customerservice.dto.response;


import lombok.*;
import java.time.LocalDateTime;

@Data
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class KafkaResponse <T> {
    private String messageId;
    private T response;


}
