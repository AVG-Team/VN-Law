package avg.vnlaw.lawservice.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SubjectDTO {
    private String id;
    private String name;
    private Integer order;

}
