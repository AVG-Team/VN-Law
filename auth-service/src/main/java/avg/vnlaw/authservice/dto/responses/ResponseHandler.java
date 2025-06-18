package avg.vnlaw.authservice.dto.responses;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.HashMap;
import java.util.Map;

public class ResponseHandler {

    public static ResponseEntity<Object> responseBuilder(
            String message, HttpStatus httpStatus, Object responseObject
    ){
        Map<String,Object> response =  new HashMap<>();
        response.put("message",message);
        response.put("httpStatus",httpStatus);
        response.put("data",responseObject);

        return new ResponseEntity<>(response,httpStatus);
    }

    public static ResponseEntity<Object> responseBuilder(
            String message, HttpStatus httpStatus
    ){
        Map<String,Object> response =  new HashMap<>();
        response.put("message",message);
        response.put("httpStatus",httpStatus);

        return new ResponseEntity<>(response,httpStatus);
    }

    public static ResponseEntity<Object> responseOk(
            String message, Object responseObject
    ){
        HttpStatus httpStatus = HttpStatus.OK;
        return responseBuilder(message, httpStatus, responseObject);
    }

    public static ResponseEntity<Object> responseBadRequest(
            String message, Object responseObject
    ){
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;
        return responseBuilder(message, httpStatus, responseObject);
    }

    public static ResponseEntity<Object> responseBadRequest(String message){
        HttpStatus httpStatus = HttpStatus.BAD_REQUEST;
        return responseBuilder(message, httpStatus);
    }
}
