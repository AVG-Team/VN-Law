package avg.vnlaw.authservice.config.securiy;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class CustomExceptionHandler {
    @ExceptionHandler(ApiKeyAuthenticationException.class)
    public ResponseEntity<String> handleApiKeyAuthenticationException(ApiKeyAuthenticationException ex) {
        System.out.println("handleApiKeyAuthenticationException");
        return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(ex.getMessage());
    }
}
