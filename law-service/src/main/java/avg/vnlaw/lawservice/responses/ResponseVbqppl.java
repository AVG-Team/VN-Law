package avg.vnlaw.lawservice.responses;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResponseVbqppl {
    private Integer id;
    private String content;
    private String name;
    private String number;
    private String type;
    private String html;

    public ResponseVbqppl(Integer id, String content, String name, String number, String type, String html) {
        this.id = id;
        this.content = content;
        this.name = name;
        this.number = number;
        this.type = type;
        this.html = html;
    }
}
