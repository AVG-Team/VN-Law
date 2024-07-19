package avg.vnlaw.authservice.requests;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ChangePasswordRequest {
    private String token;
    private String currentPassword;
    private String newPassword;
}
