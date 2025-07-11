package avg.vnlaw.lawservice.dto.response;

import jakarta.persistence.Column;

public interface ArticleIntResponse {
    String getId();
    String getName();
    Integer getOrder();
    String getContent();
    String getIndex();
    String getVbqppl();

    @Column(name = "vbqppl_link")
    String getVbqpplLink();
}
