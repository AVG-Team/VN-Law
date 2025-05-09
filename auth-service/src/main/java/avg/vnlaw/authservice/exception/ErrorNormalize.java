package avg.vnlaw.authservice.exception;

import avg.vnlaw.authservice.dto.identity.KeyCloakError;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import feign.FeignException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Component
@Slf4j
public class ErrorNormalize {
    private final ObjectMapper objectMapper;
    private final Map<String,ErrorCode> errorCodeMap;

    public ErrorNormalize(){
        objectMapper = new ObjectMapper();
        errorCodeMap = new HashMap<>();

        errorCodeMap.put("User existed with the same username",ErrorCode.USERNAME_EXISTED);
        errorCodeMap.put("User existed with the same email",ErrorCode.EMAIL_EXISTED);
        errorCodeMap.put("Username is missing",ErrorCode.USERNAME_MISSING);
    }

    public AppException handleKeyCloakException(FeignException exception){
        try{
            log.warn("Can't complete request",exception);
            var response = objectMapper.readValue(exception.contentUTF8(), KeyCloakError.class);

            if(Objects.nonNull(response.getErrorMessage()) &&
              Objects.nonNull(errorCodeMap.get(response.getErrorMessage()))){
                return new AppException(errorCodeMap.get(response.getErrorMessage()));
            }
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }
        return new AppException(ErrorCode.UNCATEGORIZED_EXCEPTION);
    }
}
