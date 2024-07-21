package avg.vnlaw.lawservice.responses;

import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class ResponseTopic {
    private String id;
    private String name;
    private Integer order;
}
