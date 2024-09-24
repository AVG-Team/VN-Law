package avg.vnlaw.lawservice.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TableResponse {

    private Integer id;
    private String html;
}
