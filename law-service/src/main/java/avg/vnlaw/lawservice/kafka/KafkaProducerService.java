package avg.vnlaw.lawservice.kafka;

import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.core.KafkaTemplate;

@EnableKafka
@RequiredArgsConstructor
public class KafkaProducerService {

    private final KafkaTemplate<String, String> kafkaTemplate;
    private static final String TOPIC = "law-service";

    public void sendMessage(String message) {
        kafkaTemplate.send(TOPIC, message);
    }
}
