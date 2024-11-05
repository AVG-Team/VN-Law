package fit.hutech.service.socketservice.controllers;

import fit.hutech.service.socketservice.dto.request.MessageRequest;
import fit.hutech.service.socketservice.dto.response.MessageResponse;
import fit.hutech.service.socketservice.enums.MessageStatus;
import fit.hutech.service.socketservice.services.AsyncChatService;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import javax.annotation.PostConstruct;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

@Controller
@Slf4j
public class SocketController {
    private final AsyncChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;
    private final Executor taskExecutor;
    private final AtomicInteger activeRequests = new AtomicInteger(0);
    private static final int MAX_CONCURRENT_REQUESTS = 100;
    private final Semaphore requestThrottle;

    public SocketController(
            AsyncChatService chatService,
            SimpMessagingTemplate messagingTemplate,
            @Qualifier("taskExecutor") Executor taskExecutor) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
        this.taskExecutor = taskExecutor;
        this.requestThrottle = new Semaphore(MAX_CONCURRENT_REQUESTS);
    }

    @MessageMapping("/sendMessage")
    public CompletableFuture<Void> handleAsyncMessage(MessageRequest messageRequest) {
        String requestId = UUID.randomUUID().toString();
        String incomingThreadId = Thread.currentThread().getName();

        return CompletableFuture.supplyAsync(() -> {
                    try {
                        if (!acquireThrottle(requestId)) {
                            return CompletableFuture.completedFuture(
                                    createErrorResponse("Server is busy. Please try again later.")
                            );
                        }
                        log.info("Message request : {}", messageRequest);
                        int currentRequests = activeRequests.incrementAndGet();
                        logRequestReceived(requestId, incomingThreadId, currentRequests, messageRequest);

                        return processMessage(requestId, messageRequest);

                    } catch (Exception e) {
                        log.error("Error in message processing for request {}: {}", requestId, e.getMessage(), e);
                        return CompletableFuture.completedFuture(
                                createErrorResponse("Internal server error: " + e.getMessage())
                        );
                    }
                }, taskExecutor)
                .thenComposeAsync(future -> future, taskExecutor)
                .thenAcceptAsync(response -> sendResponse(requestId, response, incomingThreadId), taskExecutor)
                .exceptionally(throwable -> {
                    handleProcessingError(requestId, throwable);
                    return null;
                })
                .whenComplete((result, throwable) -> cleanupResources(requestId));
    }

    private boolean acquireThrottle(String requestId) {
        try {
            boolean acquired = requestThrottle.tryAcquire(5, TimeUnit.SECONDS);
            if (!acquired) {
                log.warn("Request {} throttled - server too busy", requestId);
            }
            return acquired;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            log.error("Thread interrupted while acquiring throttle for request {}", requestId);
            return false;
        }
    }

    private void logRequestReceived(String requestId, String threadId, int currentRequests, MessageRequest message) {
        log.info("Request {} received on thread [{}] - Active requests: {}",
                requestId, threadId, currentRequests);
        log.debug("Request {} content: {}", requestId, message);
    }

    private CompletableFuture<MessageResponse> processMessage(String requestId, MessageRequest message) {
        MDC.put("requestId", requestId);
        try {
            log.info("Processing request {} on thread [{}]", requestId, Thread.currentThread().getName());

            // Gọi chatService.getAsyncAnswer và xử lý kết quả
            return chatService.getAsyncAnswer(message.getContent())
                    .thenApply(answer -> enrichResponse(answer)) // Chuyển đổi kết quả
                    .exceptionally(e -> handleProcessingError(requestId, e)); // Xử lý lỗi
        } finally {
            MDC.remove("requestId");
        }
    }


    private MessageResponse enrichResponse(String answer) {
        return MessageResponse.builder()
                .status(MessageStatus.SUCCESS)
                .message(answer)
                .timestamp(Instant.now())
                .build();
    }


    private void sendResponse(String requestId, MessageResponse response, String originalThreadId) {
        String currentThreadId = Thread.currentThread().getName();
        try {
            log.info("Sending response for request {} on thread [{}]", requestId, currentThreadId);

            messagingTemplate.convertAndSendToUser(
                    "/server/sendData",
                    response.getMessage(),
                    createMessageHeaders(requestId)
            );

            messagingTemplate.convertAndSend("/server/sendData", response.getMessage(), createMessageHeaders(requestId));

            log.info("Request {} completed.",response.getMessage());

            log.info("Request {} completed. Thread flow: Incoming[{}] -> Processing[{}]",
                    requestId, originalThreadId, currentThreadId);

        } catch (Exception e) {
            log.error("Error sending response for request {}: {}", requestId, e.getMessage(), e);
            throw e;
        }
    }

    private MessageHeaders createMessageHeaders(String requestId) {
        Map<String, Object> headers = new HashMap<>();
        headers.put("requestId", requestId);
        headers.put("timestamp", Instant.now().toString());
        return new MessageHeaders(headers);
    }

    private MessageResponse createErrorResponse(String errorMessage) {
        return MessageResponse.builder()
                .status(MessageStatus.ERROR)
                .message(errorMessage)
                .timestamp(Instant.now())
                .build();
    }

    private MessageResponse handleProcessingError(String requestId, Throwable throwable) {
        log.error("Error processing request {}: {}", requestId, throwable.getMessage(), throwable);

        MessageResponse errorResponse = createErrorResponse(
                "Error processing message: " + throwable.getMessage()
        );

        try {
            if (messagingTemplate != null) {
                messagingTemplate.convertAndSend("/server/sendData", errorResponse);
            } else {
                log.warn("Messaging template is null. Cannot send error response for request {}", requestId);
            }
        } catch (Exception e) {
            log.error("Error sending error response for request {}: {}", requestId, e.getMessage(), e);
        }

        return errorResponse;
    }


    private void cleanupResources(String requestId) {
        try {
            requestThrottle.release();
            int remainingRequests = activeRequests.decrementAndGet();
            log.debug("Resources released for request {}", requestId);
        } catch (Exception e) {
            log.error("Error cleaning up resources for request {}: {}", requestId, e.getMessage(), e);
        }
    }
}

