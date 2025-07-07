package avg.vnlaw.lawservice.elastic.documents;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.util.Date;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(indexName = "vbqppl-index")
public class VbqpplDocument {
    @Id
    Integer id;
    String content;
    String type;
    String number;
    String html;
    Date effectiveDate;
    Date effectiveEndDate;
    Integer statusCode;
    Date issueDate;
    String issuer;
    String title;
}
