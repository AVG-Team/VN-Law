package fit.hutech.service.lawservice.DTO;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FileDTO {

    private Integer id;
    private String link;
    private String path;
}
