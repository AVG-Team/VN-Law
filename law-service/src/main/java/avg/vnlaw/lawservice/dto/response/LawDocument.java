package avg.vnlaw.lawservice.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

import java.io.Serializable;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class LawDocument implements Serializable {
    private String content;
    private boolean compressed;
    private Metadata metadata;

    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Metadata implements Serializable {
        private String topicName;
        private String chapterName;
        private String subjectName;
        private String vbqplLink;
    }
}
