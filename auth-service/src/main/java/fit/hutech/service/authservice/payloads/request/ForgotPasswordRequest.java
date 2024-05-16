package fit.hutech.service.authservice.payloads.request;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ForgotPasswordRequest {
    private String email;
    private String newPassword;
    private String resetPasswordToken;
}
