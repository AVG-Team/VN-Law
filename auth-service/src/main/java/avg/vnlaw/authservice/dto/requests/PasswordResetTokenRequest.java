package avg.vnlaw.authservice.dto.requests;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PasswordResetTokenRequest {
    private String email;
    private String recaptchaToken;
}
