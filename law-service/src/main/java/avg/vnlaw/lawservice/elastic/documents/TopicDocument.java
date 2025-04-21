package avg.vnlaw.lawservice.elastic.documents;

import org.springframework.data.annotation.Id;
import lombok.*;
import org.springframework.data.elasticsearch.annotations.Document;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(indexName = "topic-index")
public class TopicDocument {
    @Id
    String id;
    String name;
    Integer order;
}
