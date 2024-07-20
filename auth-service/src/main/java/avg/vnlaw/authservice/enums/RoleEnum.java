package avg.vnlaw.authservice.enums;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum RoleEnum {
    USER(1),
    ADMIN(2);

    public final int value;
}
