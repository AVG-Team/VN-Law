package avg.vnlaw.lawservice.elastic.documents;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(indexName = "subject-index")
public class SubjectDocument {
    @Id
    String id;
    String name;
    Integer order;
    String topicId;
}
