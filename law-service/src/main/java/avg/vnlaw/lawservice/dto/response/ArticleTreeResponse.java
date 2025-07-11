package avg.vnlaw.lawservice.dto.response;

import jakarta.persistence.Column;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ArticleTreeResponse {
    private String id;
    private String name;
    private String content;
    private String index;
    private String vbqppl;

    @Column(name = "vbqppl_link")
    private String vbqpplLink;
    private Integer order;

    private List<FileResponse> files;
    private List<TableResponse> tables;
}
