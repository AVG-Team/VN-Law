package avg.vnlaw.lawservice.responses;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResponseChapter {
    private String id ;
    private String name;
    private String index;
    private Integer order;
}
