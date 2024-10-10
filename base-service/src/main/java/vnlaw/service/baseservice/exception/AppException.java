package vnlaw.service.baseservice.exception;

import avg.web.backend.enums.ErrorCode;
import lombok.Getter;


@Getter
public class AppException extends RuntimeException {

    private ErrorCode errorCode;

    public AppException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}
