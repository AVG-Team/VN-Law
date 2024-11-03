package fit.hutech.service.chatservice.DTO;

import lombok.*;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class ServerMessage {
    private String messageId;
    private String question;
    private LocalDateTime timestamp = LocalDateTime.now();

    public ServerMessage(String messageId, String question) {
        this.messageId = messageId;
        this.question = question;
    }
}
