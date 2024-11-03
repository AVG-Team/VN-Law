package fit.hutech.service.socketservice.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import fit.hutech.service.socketservice.dto.ChatMessage;
import fit.hutech.service.socketservice.util.ResponseHolder;
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
public class AsyncChatService {
    private static final String REQUEST_TOPIC = "chat-requests";
    private static final String RESPONSE_TOPIC = "chat-responses";

    private final KafkaTemplate<String, String> kafkaTemplate;
    private final Executor taskExecutor;
    private final ObjectMapper objectMapper;

    public AsyncChatService(
            KafkaTemplate<String, String> kafkaTemplate, @Qualifier("taskExecutor") Executor taskExecutor,
            ObjectMapper objectMapper) {
        this.kafkaTemplate = kafkaTemplate;
        this.taskExecutor = taskExecutor;
        this.objectMapper = objectMapper;
    }

    @Async
    public CompletableFuture<String> getAsyncAnswer(String question) {
        String messageId = UUID.randomUUID().toString();
        CompletableFuture<String> future = new CompletableFuture<>();

        try {
            ResponseHolder.put(messageId, future);
            ChatMessage chatMessage = new ChatMessage(messageId, question);
            String messageJson = objectMapper.writeValueAsString(chatMessage);

            kafkaTemplate.send(REQUEST_TOPIC, messageId, messageJson)
                    .whenComplete((result,ex) -> {
                                if (ex == null) {
                                    log.info("Sent request to chat-service. MessageId: {}", messageId);
                                } else {
                                    log.error("Failed to send message", ex);
                                    ResponseHolder.remove(messageId);
                                    future.completeExceptionally(ex);
                                }
                            }
                    );
        } catch (Exception e) {
            ResponseHolder.remove(messageId);
            future.completeExceptionally(e);
        }

        return future;
    }

    @KafkaListener(topics = RESPONSE_TOPIC, groupId = "chat-service-group")
    public void handleResponse(ConsumerRecord<String, String> record) {
        String messageId = record.key();
        String response = record.value();

        CompletableFuture<String> future = ResponseHolder.get(messageId);
        if (future != null) {
            log.info("Completing future for messageId: {}", response);
            future.complete(response);
            ResponseHolder.remove(messageId);
            log.info("Completed future for messageId: {}", messageId);
        } else {
            log.warn("No future found for messageId: {}", messageId);
        }
    }
}
