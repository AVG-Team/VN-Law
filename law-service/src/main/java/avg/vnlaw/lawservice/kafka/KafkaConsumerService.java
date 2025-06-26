package avg.vnlaw.lawservice.kafka;

import avg.vnlaw.lawservice.dto.request.LawRequest;
import avg.vnlaw.lawservice.dto.response.LawDocument;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.ArticleRepositoryCustom;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class KafkaConsumerService {
    private static final Logger logger = LoggerFactory.getLogger(KafkaProducerService.class);
    private final KafkaTemplate<String, LawDocument> kafkaTemplate;
    private final KafkaTemplate<String, String> stringTemplate;
    private final ArticleRepository articleRepository;
    private final KafkaProducerService kafkaProducer;

    private static final String TOPIC = "law-document";
    private static final String REQUEST_TOPIC = "law-request";
    private volatile boolean consumerRunning = false;

    public KafkaConsumerService(KafkaTemplate<String, String> stringTemplate,
                                KafkaTemplate<String, LawDocument> kafkaTemplate,
                                ArticleRepository articleRepository, KafkaProducerService kafkaProducer) {
        this.stringTemplate = stringTemplate;
        this.kafkaTemplate = kafkaTemplate;
        this.articleRepository = articleRepository;
        this.kafkaProducer = kafkaProducer;
    }

    @KafkaListener(topics = REQUEST_TOPIC, groupId = "law-service-group")
    public void handleLawRequest(LawRequest request) {
        try {
            logger.info("Received request on {}: {}", REQUEST_TOPIC, request.getRequestType());
            if ("ALL".equals(request.getRequestType())) {
                logger.info("Triggering sendLawDocuments for ALL request");
                kafkaProducer.sendLawDocuments();
                logger.info("Completed processing ALL request");
            } else {
                logger.warn("Unsupported request type: {}", request.getRequestType());
            }
        } catch (Exception e) {
            logger.error("Error processing request on {}: {}", REQUEST_TOPIC, e.getMessage(), e);
            kafkaProducer.sendError("Error processing law request: " + e.getMessage());
        }
    }

    @KafkaListener(topics = "test-topic", groupId = "law-service-group")
    public void handleTestTopic(LawRequest request) {
        logger.info("✅ Received request: {}", request.getRequestType());
        try {
            if ("TEST".equalsIgnoreCase(request.getRequestType())) {
                String response = "✅ Test Kafka - message from law-service";
                logger.info(response);
                kafkaProducer.sendTestResponse();
            }
        } catch (Exception e) {
            logger.error("❌ Error processing request: {}", e.getMessage(), e);
        }
    }

}
