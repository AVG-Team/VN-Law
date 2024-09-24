package avg.vnlaw.lawservice.dto.response;

import lombok.*;

@Data
@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class IndexVbqpplResponse {
    private Integer id;
    private String content;
    private String type;
    private String name;
    private Integer idParent;
    private Integer idVbqppl;
}
