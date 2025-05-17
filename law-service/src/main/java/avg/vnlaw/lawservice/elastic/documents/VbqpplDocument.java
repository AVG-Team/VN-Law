package avg.vnlaw.lawservice.elastic.documents;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

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
    String html;
}
