package fit.hutech.service.socketservice.controllers;

import fit.hutech.service.chatservice.models.AnswerResult;
import fit.hutech.service.socketservice.services.SocketService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class SocketController {
    private final SocketService socketService;

    public SocketController(SocketService socketService) {
        this.socketService = socketService;
    }

    @MessageMapping("/sendMessage")
    @SendTo("/server/sendData")
    public ResponseEntity<String> sendMessage(String chatMessage) {
        String answer = socketService.getAnswer(chatMessage);
        System.out.println("reply" + answer);
        return ResponseEntity.ok(answer);
    }
}
