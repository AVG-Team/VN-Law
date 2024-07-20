package avg.vnlaw.lawservice.responses;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class ResponseArticle implements ResponseArticleInt {
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;
    private String vbqpplLink;
    private Integer order;

    private List<ResponseFile> files;
    private List<ResponseTable> tables;

    public ResponseArticle(String id, String name, String content, String index, String vbqppl, String vbqpplLink, Integer order){
        this.id = id;
        this.name = name;
        this.content = content;
        this.index = index;
        this.vbqppl = vbqppl;
        this.vbqpplLink = vbqpplLink;
        this.order = order;
    }

}
