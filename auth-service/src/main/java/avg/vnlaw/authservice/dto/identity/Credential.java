package avg.vnlaw.authservice.dto.identity;

import lombok.*;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Credential {
    private String type;
    private String value;
    private boolean temporary;
}
