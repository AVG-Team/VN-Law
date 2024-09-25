package vnlaw.service.baseservice.exception;


import avg.web.backend.enums.ErrorCode;
import lombok.Getter;

@Getter
public class ExpiredException extends RuntimeException {
    private final ErrorCode errorCode;

    public ExpiredException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}
