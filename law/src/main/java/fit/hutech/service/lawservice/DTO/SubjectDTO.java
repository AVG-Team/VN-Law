package fit.hutech.service.lawservice.DTO;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
public class SubjectDTO {
    private String id;
    private String name;
    private Integer order;

}
