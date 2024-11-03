package fit.hutech.service.socketservice.services;

import lombok.RequiredArgsConstructor;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.CompletableFuture;

@Service
@RequiredArgsConstructor()
public class SocketService{

    private final RestTemplate restTemplate;
    private final ThreadPoolTaskExecutor taskExecutor;
    private String encodeTextToUrl(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    public String getAnswer(String question) {
        String url = "http://localhost:9000/chat-service/rag/get-answer?question=" + question;
//        String url = "http://localhost:9000/chat-service/rag/test-answer";
        System.out.println(url);
        ResponseEntity<String> responseEntity  = restTemplate.exchange(url, HttpMethod.GET, null, new ParameterizedTypeReference<String>() {});
        String jsonResponse = responseEntity.getBody();
        System.out.println("Response JSON: " + jsonResponse);
        return jsonResponse;
    }

    @Async
    public CompletableFuture<String> getAsyncAnswer(String question) {
        return CompletableFuture.supplyAsync(() -> {
            String url = "http://localhost:9000/chat-service/rag/get-answer?question=" + question;
            System.out.println(url);
            ResponseEntity<String> responseEntity  = restTemplate.exchange(url, HttpMethod.GET, null, new ParameterizedTypeReference<String>() {});
            String jsonResponse = responseEntity.getBody();
            System.out.println("Response JSON: " + jsonResponse);
            return jsonResponse;
        },taskExecutor);
    }

    @Async
    public void taskAsyncMethod() {
        taskExecutor.execute(() -> {
            // thực hiện các cong viec dong bo khac
        });

    }
}
