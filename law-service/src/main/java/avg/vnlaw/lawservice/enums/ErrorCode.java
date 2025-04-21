package avg.vnlaw.lawservice.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
@FieldDefaults(level = lombok.AccessLevel.PRIVATE, makeFinal = true)
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error",HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_KEY(100, "Invalid key",HttpStatus.BAD_REQUEST),
    INVALID_INPUT(103, "Invalid input provided",HttpStatus.BAD_REQUEST),
    PERMISSION_DENIED(104, "Permission denied",HttpStatus.FORBIDDEN),
    RESOURCE_NOT_AVAILABLE(105, "Resource not available",HttpStatus.NOT_FOUND),
    OPERATION_FAILED(106, "Operation failed",HttpStatus.INTERNAL_SERVER_ERROR),
    DATABASE_ERROR(107, "Database error",HttpStatus.INTERNAL_SERVER_ERROR),
    UNAUTHENTICATED(108, "Authentication failed",HttpStatus.UNAUTHORIZED),
    SESSION_EXPIRED(112, "Session expired",HttpStatus.UNAUTHORIZED),
    CONFLICT(113, "Conflict occurred",HttpStatus.CONFLICT),
    SERVICE_UNAVAILABLE(114, "Service temporarily unavailable",HttpStatus.SERVICE_UNAVAILABLE),
    ROLE_EXISTED(117, "Role existed",HttpStatus.BAD_REQUEST),
    UNAUTHORIZED(125,"You don't have permission",HttpStatus.FORBIDDEN),
    CHAPTER_NOT_FOUND(125,"Chapter is not found",HttpStatus.NOT_FOUND ),
    CHAPTER_EXISTED(126,"Chapter is existed",HttpStatus.BAD_REQUEST),
    CHAPTER_EMPTY(126,"Chapter is empty",HttpStatus.BAD_REQUEST),
    TOPIC_NOT_FOUND(127,"Topic is not found",HttpStatus.NOT_FOUND ),
    TOPIC_EXISTED(128,"Topic is existed",HttpStatus.BAD_REQUEST),
    TOPIC_EMPTY(128,"Topic is empty",HttpStatus.BAD_REQUEST),
    TOPIC_IS_NOT_EXISTED(128,"Topic is not existed",HttpStatus.NOT_FOUND),
    SUBJECT_NOT_FOUND(129,"Subject is not found",HttpStatus.NOT_FOUND ),
    SUBJECT_EXISTED(130,"Subject is existed",HttpStatus.BAD_REQUEST),
    SUBJECT_EMPTY(130,"Subject is empty",HttpStatus.BAD_REQUEST),
    SUBJECT_IS_NOT_EXISTED(130,"Subject is not existed",HttpStatus.NOT_FOUND),
    ARTICLE_NOT_FOUND(131,"Article is not found",HttpStatus.NOT_FOUND ),
    ARTICLE_EXISTED(132,"Article is existed",HttpStatus.BAD_REQUEST),
    ARTICLE_EMPTY(133,"Article is empty",HttpStatus.BAD_REQUEST),
    ARTICLE_IS_NOT_EXISTED(134,"Article is not existed",HttpStatus.NOT_FOUND),
    INDEXVBQPPL_NOT_FOUND(135,"IndexVBQPPL is not found",HttpStatus.NOT_FOUND ),
    INDEXVBQPPL_EXISTED(136,"IndexVBQPPL is existed",HttpStatus.BAD_REQUEST),
    INDEXVBQPPL_EMPTY(137,"IndexVBQPPL is empty",HttpStatus.BAD_REQUEST),
    INDEXVBQPPL_IS_NOT_EXISTED(138,"IndexVBQPPL is not existed",HttpStatus.NOT_FOUND),
    VBQPPL_NOT_FOUND(139,"VBQPPL is not found",HttpStatus.NOT_FOUND ),
    VBQPPL_EXISTED(140,"VBQPPL is existed",HttpStatus.BAD_REQUEST),
    VBQPPL_EMPTY(141,"VBQPPL is empty",HttpStatus.BAD_REQUEST),
    VBQPPL_IS_NOT_EXISTED(142,"VBQPPL is not existed",HttpStatus.NOT_FOUND),
    ID_EMPTY(143,"Id is empty",HttpStatus.BAD_REQUEST),
    TABLE_NOT_FOUND(144,"Table is not found",HttpStatus.NOT_FOUND ),
    TABLE_EXISTED(145,"Table is existed",HttpStatus.BAD_REQUEST),
    TABLE_IS_NOT_EXISTED(146,"Table is not existed",HttpStatus.NOT_FOUND),
    COMPRESS_FAILD(147,"Compress faild",HttpStatus.INTERNAL_SERVER_ERROR),
    ;

    int code ;
    String message;
    HttpStatus status;


}
