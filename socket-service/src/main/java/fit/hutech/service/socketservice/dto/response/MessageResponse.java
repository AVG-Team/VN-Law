package fit.hutech.service.socketservice.dto.response;

import fit.hutech.service.socketservice.enums.MessageStatus;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;

@Data
@Builder
public class MessageResponse {
    private String message;
    private MessageStatus status;
    private Instant timestamp;

    // Add other fields as needed
}