package avg.vnlaw.lawservice.responses;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ResponseFile {

    private Integer id;
    private String link;
    private String path;
}
