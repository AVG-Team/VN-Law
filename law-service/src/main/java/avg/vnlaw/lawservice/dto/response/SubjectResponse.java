package avg.vnlaw.lawservice.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SubjectResponse {
    private String id;
    private String name;
    private Integer order;

}
