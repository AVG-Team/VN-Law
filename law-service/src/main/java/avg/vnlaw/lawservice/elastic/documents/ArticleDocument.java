package avg.vnlaw.lawservice.elastic.documents;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Document(indexName = "article-index")
public class ArticleDocument {
    @Id
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;
    private Date effectiveDate;
    private String topicId;
    private String subjectId;
    private String chapterId;

}
