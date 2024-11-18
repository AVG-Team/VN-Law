package vnlaw.service.customerservice.dto.request;

import lombok.*;

import java.time.LocalDateTime;

@Data
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class KafkaRequest <T> {
    private String messageId;
    private T request;
    private LocalDateTime timestamp = LocalDateTime.now();

    public KafkaRequest(String messageId, T request) {
        this.messageId = messageId;
        this.request = request;
    }
}
