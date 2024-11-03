package fit.hutech.service.socketservice.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.web.bind.annotation.ControllerAdvice;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    @MessageExceptionHandler
    public String handleException(Throwable exception) {
        log.error("Error in message handling", exception);
        return "Error: " + exception.getMessage();
    }
}
