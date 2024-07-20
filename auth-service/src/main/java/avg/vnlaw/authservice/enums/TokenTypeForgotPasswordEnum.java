package avg.vnlaw.authservice.enums;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum TokenTypeForgotPasswordEnum {
    EMAIL_VERIFICATION(1),
    PASSWORD_RESET(2);
    public final int value;
}
