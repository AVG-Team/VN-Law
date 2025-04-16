package avg.vnlaw.authservice.dto.identity;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class TokenExchangeResponse {
    private String accessToken;
    private String expiresIn;
    private String refreshToken;
    private String tokenType;
    private String idToken;
    private String scope;
}
