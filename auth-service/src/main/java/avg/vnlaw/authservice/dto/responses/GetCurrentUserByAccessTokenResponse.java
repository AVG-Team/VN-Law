package avg.vnlaw.authservice.dto.responses;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class GetCurrentUserByAccessTokenResponse {
    private String name;
    private String role;
}
