package vnlaw.service.baseservice.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error",HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_KEY(100, "Invalid key",HttpStatus.BAD_REQUEST),
    USER_EXISTED(101, "User existed",HttpStatus.BAD_REQUEST),
    USER_NOT_FOUND(102, "User not found",HttpStatus.NOT_FOUND),
    INVALID_INPUT(103, "Invalid input provided",HttpStatus.BAD_REQUEST),
    PERMISSION_DENIED(104, "Permission denied",HttpStatus.FORBIDDEN),
    RESOURCE_NOT_AVAILABLE(105, "Resource not available",HttpStatus.NOT_FOUND),
    OPERATION_FAILED(106, "Operation failed",HttpStatus.INTERNAL_SERVER_ERROR),
    DATABASE_ERROR(107, "Database error",HttpStatus.INTERNAL_SERVER_ERROR),
    UNAUTHENTICATED(108, "Authentication failed",HttpStatus.UNAUTHORIZED),
    EMAIL_ALREADY_EXISTS(109, "Email already exists",HttpStatus.BAD_REQUEST),
    USERNAME_ALREADY_EXISTS(110, "Username already exists",HttpStatus.BAD_REQUEST),
    PASSWORD_TOO_WEAK(111, "Password too weak",HttpStatus.BAD_REQUEST),
    SESSION_EXPIRED(112, "Session expired",HttpStatus.UNAUTHORIZED),
    CONFLICT(113, "Conflict occurred",HttpStatus.CONFLICT),
    SERVICE_UNAVAILABLE(114, "Service temporarily unavailable",HttpStatus.SERVICE_UNAVAILABLE),
    USER_NOT_EXISTED(115, "User not exist",HttpStatus.NOT_FOUND),
    USER_NOT_AUTHENTICATED(116, "User not authenticated",HttpStatus.UNAUTHORIZED),
    ROLE_EXISTED(117, "Role existed",HttpStatus.BAD_REQUEST),
    ADDRESS_EXISTED(118, "Address existed",HttpStatus.BAD_REQUEST),
    CONTACT_EXISTED(119, "Contact existed",HttpStatus.BAD_REQUEST),
    USER_PROFILE_EXISTED(120, "User profile existed",HttpStatus.BAD_REQUEST),
    ADDRESS_NOT_FOUND(121, "Address not found",HttpStatus.NOT_FOUND),
    CONTACT_NOT_FOUND(122, "Contact not found",HttpStatus.NOT_FOUND),
    USER_PROFILE_NOT_FOUND(123, "User profile not found",HttpStatus.NOT_FOUND),
    TOKEN_EXPIRED(124,"Token expired",HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED(125,"You don't have permission",HttpStatus.FORBIDDEN),;

    private int code ;
    private String message;
    private HttpStatus status;


}
