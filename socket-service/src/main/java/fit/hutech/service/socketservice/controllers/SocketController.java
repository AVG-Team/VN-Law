package fit.hutech.service.socketservice.controllers;

import fit.hutech.service.chatservice.models.AnswerResult;
import fit.hutech.service.socketservice.services.AsyncChatService;
import fit.hutech.service.socketservice.services.SocketService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.util.concurrent.CompletableFuture;

@Controller
@Slf4j
public class SocketController {
    private final AsyncChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    public SocketController(
            AsyncChatService chatService,
            SimpMessagingTemplate messagingTemplate) {
        this.chatService = chatService;
        this.messagingTemplate = messagingTemplate;
    }

    @MessageMapping("/sendMessage")
    public void handleAsyncMessage(String chatMessage) {
        log.info("Received message: {}", chatMessage);

        chatService.getAsyncAnswer(chatMessage)
                .thenAccept(response -> {
                    log.info("Processing completed, sending response");
                    messagingTemplate.convertAndSend("/server/sendData", response);
                })
                .exceptionally(throwable -> {
                    log.error("Error processing message", throwable);
                    messagingTemplate.convertAndSend("/server/sendData",
                            "Error: " + throwable.getMessage());
                    return null;
                });
    }
}

