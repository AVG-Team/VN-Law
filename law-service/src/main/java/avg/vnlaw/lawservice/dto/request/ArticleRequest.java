package avg.vnlaw.lawservice.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class ArticleRequest {
    String id;
    String name;
    String content;
    String index;
    String vbqppl;
    String vbqpplLink;
    Integer order;
    String topicId;
    String subjectId;
    String chapterId;
}
