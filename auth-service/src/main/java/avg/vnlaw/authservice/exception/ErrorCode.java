package avg.vnlaw.authservice.exception;

import lombok.Getter;
import org.keycloak.authorization.client.util.Http;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_KEY(1001, "Uncategorized error", HttpStatus.BAD_REQUEST),
    INVALID_USERNAME(1003, "Username must be at least {min} characters", HttpStatus.BAD_REQUEST),
    INVALID_PASSWORD(1004, "Password must be at least {min} characters", HttpStatus.BAD_REQUEST),
    UNAUTHENTICATED(1006, "Unauthenticated", HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED(1007, "You do not have permission", HttpStatus.FORBIDDEN),
    EMAIL_EXISTED(1008,"Email existed, Please choose another email", HttpStatus.BAD_REQUEST),
    USERNAME_EXISTED(1009, "Username existed, Please choose another username",HttpStatus.BAD_REQUEST),
    USERNAME_MISSING(1010,"Username is missing value, Please enter username",HttpStatus.BAD_REQUEST),
    RECAPCHA_INVALID(1011,"Captcha verification failed, Please try again.", HttpStatus.BAD_REQUEST),
    ACCOUNT_NOT_ACTIVATED(1012,"Account is not activated", HttpStatus.BAD_REQUEST),
    PASSWORD_INCORRECT(1013,"Password is incorrect", HttpStatus.UNAUTHORIZED),;

    ErrorCode(int code, String message, HttpStatusCode status){
        this.code = code;
        this.message = message;
        this.status = status;
    }

    private int code;
    private String message;
    private HttpStatusCode status;
}
