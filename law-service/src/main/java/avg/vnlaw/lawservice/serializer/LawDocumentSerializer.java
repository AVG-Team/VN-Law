package avg.vnlaw.lawservice.serializer;

import avg.vnlaw.lawservice.dto.response.LawDocument;
import org.apache.kafka.common.serialization.Serializer;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public class LawDocumentSerializer implements Serializer<LawDocument> {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void configure(Map<String, ?> configs, boolean isKey) {
        // Không cần cấu hình đặc biệt
    }

    @Override
    public byte[] serialize(String topic, LawDocument data) {
        try {
            if (data == null) {
                return null;
            }
            return objectMapper.writeValueAsBytes(data);  // Chuyển đối tượng thành byte[]
        } catch (Exception e) {
            throw new RuntimeException("Error serializing LawDocument", e);
        }
    }

    @Override
    public void close() {
        // Không cần đóng gì
    }
}
