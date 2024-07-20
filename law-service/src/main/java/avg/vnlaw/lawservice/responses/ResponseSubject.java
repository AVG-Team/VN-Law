package avg.vnlaw.lawservice.responses;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResponseSubject {
    private String id;
    private String name;
    private Integer order;

}
