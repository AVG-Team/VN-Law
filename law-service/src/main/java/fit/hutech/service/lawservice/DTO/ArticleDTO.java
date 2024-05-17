package fit.hutech.service.lawservice.DTO;

import fit.hutech.service.lawservice.models.Article;
import lombok.*;

import java.util.List;

@Data
@AllArgsConstructor
public class ArticleDTO implements ArticleDTOINT{
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;

    private List<FileDTO> files;
    private List<TableDTO> tables;

    public ArticleDTO(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
    }

}
