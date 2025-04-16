package avg.vnlaw.authservice.dto.identity;

import lombok.*;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TokenExchangeParam  {
    private String grant_type;
    private String client_id;
    private String client_secret;
    private String scope;
}
