package avg.vnlaw.lawservice.elastic.documents;

import org.springframework.data.annotation.Id;
import lombok.*;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Document(indexName = "chapter-index")
public class ChapterDocument {
    @Id
    String id;
    @Field(type = FieldType.Keyword)
    String name;
    String index;
    Integer order;
    String subjectId;
}
