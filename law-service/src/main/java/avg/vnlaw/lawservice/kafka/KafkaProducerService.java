package avg.vnlaw.lawservice.kafka;

import avg.vnlaw.lawservice.dto.response.LawDocument;
import avg.vnlaw.lawservice.repositories.ArticleRepository;
import avg.vnlaw.lawservice.repositories.ArticleRepositoryCustom;
import org.apache.kafka.clients.admin.AdminClient;
import org.apache.kafka.clients.admin.ConsumerGroupDescription;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Collections;
import java.util.concurrent.ExecutionException;
import java.util.zip.GZIPOutputStream;
import java.util.Base64;

@Service
public class KafkaProducerService {

    private static final Logger logger = LoggerFactory.getLogger(KafkaProducerService.class);
    private final KafkaTemplate<String, LawDocument> kafkaTemplate;
    private final KafkaTemplate<String, String> stringTemplate;
    private final ArticleRepository articleRepository;
    private final ArticleRepositoryCustom articleRepositoryCustom;
    private final AdminClient adminClient;

    private static final String LAW_DOCUMENT_TOPIC = "law-document";
    private static final String TEST_RESPONSE_TOPIC = "test-response-topic";
    private static final String ERROR_TOPIC = "error-messages";
    private static final int BATCH_SIZE = 1000;
    private static final String CONSUMER_GROUP = "law-service-group";

    // Constructor Injection để inject tất cả các dependency
    public KafkaProducerService(KafkaTemplate<String, String> stringTemplate,
                                KafkaTemplate<String, LawDocument> kafkaTemplate,
                                ArticleRepository articleRepository, ArticleRepositoryCustom articleRepositoryCustom, AdminClient adminClient) {
        this.stringTemplate = stringTemplate;
        this.kafkaTemplate = kafkaTemplate;
        this.articleRepository = articleRepository;
        this.articleRepositoryCustom = articleRepositoryCustom;
        this.adminClient = adminClient;
    }

    private boolean isConsumerGroupActive() {
        try {
            ConsumerGroupDescription description = adminClient
                    .describeConsumerGroups(Collections.singletonList(CONSUMER_GROUP))
                    .describedGroups()
                    .get(CONSUMER_GROUP)
                    .get();
            return !description.members().isEmpty(); // Kiểm tra có consumer nào hoạt động
        } catch (InterruptedException | ExecutionException e) {
            logger.error("Error checking consumer group {}: {}", CONSUMER_GROUP, e.getMessage(), e);
            return false;
        }
    }

    private String compressContent(String content) throws Exception {
        if (content == null) return null;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try (GZIPOutputStream gzip = new GZIPOutputStream(baos)) {
            gzip.write(content.getBytes(StandardCharsets.UTF_8));
        }
        return Base64.getEncoder().encodeToString(baos.toByteArray());
    }


    public void sendTestResponse() {
            String response = "Test response with 1";
            logger.info(response);
            stringTemplate.send(TEST_RESPONSE_TOPIC, response);
            logger.info("Sent response to topic '{}': {}", TEST_RESPONSE_TOPIC, response);
    }

    public void sendLawDocuments() {
        if (!isConsumerGroupActive()) {
            logger.warn("No active consumers in group {}. Delaying sendLawDocuments.", CONSUMER_GROUP);
            sendError("No active consumers in group " + CONSUMER_GROUP);
            return; // Thoát nếu không có consumer
        }
        try {
            int[] batchCount = {0}; // Đếm số batch
            int[] recordCount = {0}; // Đếm số bản ghi
            articleRepositoryCustom.fetchArticlesInBatches(BATCH_SIZE, result -> {
                try {
                    // Kiểm tra null
                    if (result[0] == null || result[1] == null || result[2] == null || result[3] == null) {
                        logger.warn("Skipping record with null values: {}", Arrays.toString(result));
                        return;
                    }

                    LawDocument document = new LawDocument();
                    String rawContent = (String) result[0];
                    document.setContent(compressContent(rawContent)); // Nén content
                    document.setCompressed(true);
                    LawDocument.Metadata metadata = new LawDocument.Metadata();
                    metadata.setSubjectName((String) result[1]);
                    metadata.setChapterName((String) result[2]);
                    metadata.setTopicName((String) result[3]);
                    metadata.setVbqplLink((String) result[4] != null ? (String) result[4] : "");
                    document.setMetadata(metadata);

                    kafkaTemplate.send(LAW_DOCUMENT_TOPIC, document)
                            .whenComplete((sendResult, ex) -> {
                                if (ex == null) {
                                    recordCount[0]++;
                                    logger.debug("Successfully sent LawDocument to '{}'", LAW_DOCUMENT_TOPIC);
                                } else {
                                    logger.error("Failed to send LawDocument to '{}': {}", LAW_DOCUMENT_TOPIC, ex.getMessage(), ex);
                                    sendError("Failed to send LawDocument: " + ex.getMessage());
                                }
                            });
                } catch (Exception e) {
                    logger.error("Error processing record: {}", e.getMessage(), e);
                    sendError("Error processing record: " + e.getMessage());
                }
            });
            batchCount[0]++;
            logger.info("Processed batch {}, total records: {}", batchCount[0], recordCount[0]);

            // Flush để đảm bảo tất cả message được gửi
            kafkaTemplate.flush();
            logger.info("Flushed Kafka template for topic '{}'", LAW_DOCUMENT_TOPIC);
        } catch (Exception e) {
            logger.error("Error in sendLawDocuments: {}", e.getMessage(), e);
            sendError("Error in sendLawDocuments: " + e.getMessage());
            throw new RuntimeException("Failed to send LawDocuments", e);
        }
    }

    public void sendLawDocumentManually() {
        try {
//            List<Object[]> results = articleRepository.findAllArticlesForKafka();
//            sendLawDocuments(results);
        } catch (Exception e) {
            logger.error("Error sending documents: {}", e.getMessage(), e);
        }
    }

    public void sendError(String errorMessage) {
        try {
            stringTemplate.send(ERROR_TOPIC, errorMessage)
                    .whenComplete((result, ex) -> {
                        if (ex == null) {
                            logger.info("Sent error to '{}': {}", ERROR_TOPIC, errorMessage);
                        } else {
                            logger.error("Failed to send error to '{}': {}", ERROR_TOPIC, ex.getMessage(), ex);
                        }
                    });
        } catch (Exception e) {
            logger.error("Error sending error message to '{}': {}", ERROR_TOPIC, e.getMessage(), e);
        }
    }

    public void flush() {
        try {
            kafkaTemplate.flush();
            stringTemplate.flush();
            logger.info("Flushed Kafka templates");
        } catch (Exception e) {
            logger.error("Error flushing Kafka templates: {}", e.getMessage(), e);
        }
    }
}
