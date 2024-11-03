package fit.hutech.service.socketservice;


import com.fasterxml.jackson.databind.ObjectMapper;
import fit.hutech.service.socketservice.dto.ChatMessage;
import fit.hutech.service.socketservice.services.AsyncChatService;
import fit.hutech.service.socketservice.util.ResponseHolder;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.kafka.core.KafkaTemplate;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class AsyncChatServiceTest {
    @Mock
    private KafkaTemplate<String, String> kafkaTemplate;

    @Mock
    private ObjectMapper objectMapper;

    @InjectMocks
    private AsyncChatService asyncChatService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        ResponseHolder.cleanup(); // Đảm bảo ResponseHolder sạch trước mỗi test
    }

    @Test
    void testGetAsyncAnswer_Success() throws Exception {
        String question = "What is the weather today?";
        String messageId = UUID.randomUUID().toString();
        String messageJson = "{\"messageId\":\"" + messageId + "\",\"question\":\"" + question + "\"}";

        when(objectMapper.writeValueAsString(any(ChatMessage.class))).thenReturn(messageJson);
        CompletableFuture<String> future = asyncChatService.getAsyncAnswer(question);

        // Xác minh rằng câu hỏi đã được gửi
        ArgumentCaptor<String> topicCaptor = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<String> keyCaptor = ArgumentCaptor.forClass(String.class);
        ArgumentCaptor<String> valueCaptor = ArgumentCaptor.forClass(String.class);

        verify(kafkaTemplate).send(topicCaptor.capture(), keyCaptor.capture(), valueCaptor.capture());
        assertEquals("chat-requests", topicCaptor.getValue());
        assertNotNull(keyCaptor.getValue()); // messageId sẽ được tạo ngẫu nhiên
        assertEquals(messageJson, valueCaptor.getValue());

        // Giả lập phản hồi từ chat service
        String responseMessage = "It's sunny today!";
        ConsumerRecord<String, String> record = new ConsumerRecord<>("chat-responses", 0, 0, messageId, responseMessage);
        asyncChatService.handleResponse(record);

        // Xác minh rằng CompletableFuture hoàn thành với phản hồi
        assertEquals(responseMessage, future.get()); // Chờ cho tương lai hoàn thành
    }

    @Test
    void testGetAsyncAnswer_Failure() throws Exception {
        String question = "What is the weather today?";
        CompletableFuture<String> future = asyncChatService.getAsyncAnswer(question);

        // Giả lập lỗi khi gửi Kafka
        doThrow(new RuntimeException("Kafka Error")).when(kafkaTemplate).send(anyString(), anyString(), anyString());

        // Kiểm tra ngoại lệ được hoàn thành cho CompletableFuture
        assertThrows(Exception.class, future::get);
    }
}
