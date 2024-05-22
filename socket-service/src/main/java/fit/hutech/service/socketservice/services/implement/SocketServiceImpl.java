package fit.hutech.service.socketservice.services.implement;

import fit.hutech.service.socketservice.services.SocketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Service
public class SocketServiceImpl implements SocketService {

    @Autowired
    private RestTemplate restTemplate;

    private String encodeTextToUrl(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    @Override
    public String getAnswer(String question) {
        String url = "http://localhost:9000/chat-service/rag/get-answer?question=" + question;
        System.out.println(url);
        ResponseEntity<String> responseEntity  = restTemplate.exchange(url, HttpMethod.GET, null, new ParameterizedTypeReference<String>() {});
        String jsonResponse = responseEntity.getBody();
        System.out.println("Response JSON: " + jsonResponse);
        return jsonResponse;
    }
}
