package avg.vnlaw.authservice.dto.identity;

import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import java.util.List;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class CheckTokenResponse {
        private boolean active;
        private Long exp;
        private Long iat;
        private String jti;
        private String iss;
        private List<String> aud;
        private String sub;
        private String typ;
        private String azp;
        private String session_state;
        private String name;
        private String given_name;
        private String family_name;
        private String preferred_username;
        private String email;
        private Boolean email_verified;
        private String acr;
        private String sid;
        private String username;
}
