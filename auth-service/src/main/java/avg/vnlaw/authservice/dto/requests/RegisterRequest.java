package avg.vnlaw.authservice.dto.requests;

import jakarta.annotation.Nullable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    @Nullable
    private String username;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private int role;
    @Nullable
    private String recaptchaToken;
}
