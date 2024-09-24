package avg.vnlaw.lawservice.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@Builder
public class ArticleResponse implements ArticleIntResponse {
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;

    private List<FileResponse> files;
    private List<TableResponse> tables;

    public ArticleResponse(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
    }

}
