package avg.vnlaw.lawservice.dto.response;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FileResponse {

    private Integer id;
    private String link;
    private String path;
}
