package avg.vnlaw.authservice.dto.identity;

import jakarta.annotation.Nullable;
import lombok.*;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CheckTokenParam {
    private String token;
    private String client_id;
    @Nullable
    private String client_secret;
}
