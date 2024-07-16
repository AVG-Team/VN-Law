package fit.hutech.service.lawservice.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class VbqpplDTO {
    private Integer id;
    private String content;
    private String name;
    private String number;
    private String type;
    private String html;

    public VbqpplDTO(Integer id, String content, String name, String number, String type, String html) {
        this.id = id;
        this.content = content;
        this.name = name;
        this.number = number;
        this.type = type;
        this.html = html;
    }
}
