package avg.vnlaw.lawservice.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChapterDTO {
    private String id ;
    private String name;
    private String index;
    private Integer order;
}
