package fit.hutech.service.chatservice.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class VbqpplDTO {
    private String id;
    private String content;
    private String name;
    private String number;
    private String type;
    private String html;

    public VbqpplDTO(String id, String content, String name, String number, String type, String html) {
        this.id = id;
        this.content = content;
        this.name = name;
        this.number = number;
        this.type = type;
        this.html = html;
    }
}