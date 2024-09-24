package avg.vnlaw.lawservice.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChapterResponse {
    private String id ;
    private String name;
    private String index;
    private Integer order;
}
