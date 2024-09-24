package avg.vnlaw.lawservice.exception;


import avg.vnlaw.lawservice.enums.ErrorCode;
import lombok.Getter;

@Getter
public class ExpiredException extends RuntimeException {
    private final ErrorCode errorCode;

    public ExpiredException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }
}
