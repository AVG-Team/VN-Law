package fit.hutech.service.chatservice.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import fit.hutech.service.chatservice.DTO.ChatResponse;
import fit.hutech.service.chatservice.DTO.ServerMessage;
import fit.hutech.service.chatservice.models.AnswerResult;
import fit.hutech.service.chatservice.util.ResponseHolder;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;

@Service
@Slf4j
@RequiredArgsConstructor
public class AsyncQuestionService {
    private final KafkaTemplate<String, String> kafkaTemplate;
    private final ObjectMapper objectMapper;
    private final RAGService ragService; // Service để tương tác với AI

    private static final String REQUEST_TOPIC = "chat-requests";
    private static final String RESPONSE_TOPIC = "chat-responses";


    @KafkaListener(topics = REQUEST_TOPIC, groupId = "socket-service-group")
    public void handleChatRequest(ConsumerRecord<String, String> record) {
        String messageId = record.key();
        String messageJson = record.value();

        log.info("Received chat request with messageId: {}", messageId);

        try {
            // Parse the incoming message
            ServerMessage chatMessage = objectMapper.readValue(messageJson, ServerMessage.class);

            // Process the question asynchronously
            processQuestionAsync(chatMessage)
                    .thenAccept(answer -> sendResponse(messageId, answer))
                    .exceptionally(ex -> {
                        handleError(messageId, ex);
                        return null;
                    });

        } catch (Exception e) {
            handleError(messageId, e);
        }
    }

    public CompletableFuture<AnswerResult> processQuestionAsync(ServerMessage chatMessage) {
        return CompletableFuture.supplyAsync(() -> {
            try {
                // Gọi AI service để xử lý câu hỏi
                log.info("Processing question for messageId: {}", chatMessage.getQuestion());
                AnswerResult answer = ragService.getAnswer(chatMessage.getQuestion());

                // Log kết quả
                log.info("Generated answer for messageId: {}", chatMessage.getMessageId());

                System.out.println("Answer: " + answer.getAnswer());
                return answer;
            } catch (Exception e) {
                log.error("Error processing question for messageId: {}",
                        chatMessage.getMessageId(), e);
                throw e;
            }
        });
    }

    private void sendResponse(String messageId, AnswerResult answer) {
        try {
            ChatResponse response = new ChatResponse(messageId, answer);
            String responseJson = objectMapper.writeValueAsString(response);

            kafkaTemplate.send(RESPONSE_TOPIC, messageId, responseJson)
                    .whenComplete((result, ex) -> {
                        if (ex == null) {
                            log.info("Sent response for messageId: {}, partition: {}, offset: {}",
                                    messageId,
                                    result.getRecordMetadata().partition(),
                                    result.getRecordMetadata().offset());
                        } else {
                            log.error("Failed to send response for messageId: {}", messageId, ex);
                        }
                    });
        } catch (Exception e) {
            log.error("Error sending response for messageId: {}", messageId, e);
        }
    }

    private void handleError(String messageId, Throwable ex) {
        log.error("Error processing request for messageId: {}", messageId, ex);
        try {
            // Send error response back
            String errorMessage = "Error processing your request: " + ex.getMessage();
            sendResponse(messageId, new AnswerResult(errorMessage));
        } catch (Exception e) {
            log.error("Failed to send error response for messageId: {}", messageId, e);
        }
    }
}
