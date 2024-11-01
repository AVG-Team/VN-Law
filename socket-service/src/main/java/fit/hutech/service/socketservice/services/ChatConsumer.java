package fit.hutech.service.socketservice.services;

import lombok.RequiredArgsConstructor;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ChatConsumer {

    @KafkaListener(topics = "chat-messages",groupId = "vnlaw-group")
    public void listen(String message){

    }
}
