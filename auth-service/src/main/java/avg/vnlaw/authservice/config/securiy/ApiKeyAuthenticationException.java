package avg.vnlaw.authservice.config.securiy;

import org.springframework.security.core.AuthenticationException;

public class ApiKeyAuthenticationException extends AuthenticationException {
    public ApiKeyAuthenticationException(String msg) {
        super(msg);
    }
}
