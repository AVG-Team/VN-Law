package avg.vnlaw.authservice.dto.identity;

import lombok.*;
import org.springframework.lang.Nullable;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenExchangeParam  {
    @Builder.Default
    private String client_id="admin-cli";
    private String username;
    private String password;
    @Builder.Default
    private String grant_type="password";
    @Nullable
    private String client_secret;
    @Nullable
    private String code;
    @Nullable
    private String redirect_uri;
    @Nullable
    private String subject_token_type;
    @Nullable
    private String subject_issuer;
    @Nullable
    private String subject_token;
}
