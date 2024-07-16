package avg.vnlaw.lawservice.DTO;

import avg.vnlaw.lawservice.entities.Chapter;
import avg.vnlaw.lawservice.entities.Subject;
import avg.vnlaw.lawservice.entities.Topic;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ListTreeViewDTO {
    private String id;
    private Subject subject;
    private Chapter chapter;
    private Topic topic;

    private List<ArticleTreeViewDTO> articles;

}
