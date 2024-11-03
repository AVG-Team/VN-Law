package fit.hutech.service.chatservice.DTO;

import fit.hutech.service.chatservice.models.AnswerResult;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatResponse {
    private String messageId;
    private AnswerResult answer;
}
