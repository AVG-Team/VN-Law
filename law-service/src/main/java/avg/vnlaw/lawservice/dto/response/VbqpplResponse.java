package avg.vnlaw.lawservice.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VbqpplResponse {
    private Integer id;
    private String content;
    private String number;
    private String type;
    private String html;
    private Date effectiveDate;
    private Date effectiveEndDate;
    private Integer status;
    private Date issueDate;
    private String issuer;
    private String title;

}
