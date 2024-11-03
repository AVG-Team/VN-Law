package fit.hutech.service.socketservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatMessage {
    private String messageId;
    private String question;
    private LocalDateTime timestamp = LocalDateTime.now();

    public ChatMessage(String messageId, String question) {
        this.messageId = messageId;
        this.question = question;
    }
}

