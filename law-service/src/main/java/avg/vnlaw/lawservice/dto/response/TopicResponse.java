package avg.vnlaw.lawservice.dto.response;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class TopicResponse {
    private String id;
    private String name;
    private Integer order;
}
