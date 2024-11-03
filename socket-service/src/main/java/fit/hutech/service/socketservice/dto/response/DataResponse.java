package fit.hutech.service.socketservice.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class DataResponse<T> {
    private String message;
    private Boolean status;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private T data;
}
