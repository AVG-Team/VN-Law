package avg.vnlaw.authservice.enums;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum RoleEnum {
    USER(1),
    SUPER_USER(2),
    ADMIN(3);

    public final int value;
}
