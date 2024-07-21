package avg.vnlaw.lawservice.responses;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResponseVbqppl {
    private Integer id;
    private String content;
    private String name;
    private String number;
    private String type;
    private String html;
}
