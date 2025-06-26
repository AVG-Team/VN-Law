package avg.vnlaw.authservice.dto.responses;

import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.lang.Nullable;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AuthenticationResponse {
    @JsonProperty("access_token")
    private String accessToken;
    @JsonProperty("refresh_token")
    private String refreshToken;
    @JsonProperty("type")
    private AuthenticationResponseEnum type;
    @JsonProperty("name")
    private String name;
    @JsonProperty("email")
    private String email;
    @JsonProperty("keycloak_id")
    private String keycloakId;
    @JsonProperty("role")
    private String role;
    @Nullable
    private String message;
}
