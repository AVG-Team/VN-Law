package fit.hutech.service.lawservice.DTO;

import fit.hutech.service.lawservice.models.Chapter;
import fit.hutech.service.lawservice.models.Subject;
import fit.hutech.service.lawservice.models.Topic;
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