package avg.vnlaw.lawservice.responses;

import lombok.*;

@Data
@Builder
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ResponseIndexVbqppl {
    private Integer id;
    private String content;
    private String type;
    private String name;
    private Integer idParent;
    private Integer idVbqppl;
}
