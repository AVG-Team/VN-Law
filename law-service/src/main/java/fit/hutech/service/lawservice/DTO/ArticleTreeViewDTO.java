package fit.hutech.service.lawservice.DTO;

import lombok.*;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ArticleTreeViewDTO {
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;

    private List<FileDTO> files;
    private List<TableDTO> tables;
}
