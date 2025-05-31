package avg.vnlaw.lawservice.services;

import avg.vnlaw.lawservice.dto.response.TokenValidationResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class AuthServiceClient {

    private final RestTemplate restTemplate;

    @Value("${auth-service.url-validate:http://localhost:9001/api/auth/validate-token}")
    private String authServiceUrl;

    // Đảm bảo constructor được khai báo công khai
    public AuthServiceClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public TokenValidationResponse validateToken(String token) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> entity = new HttpEntity<>(token, headers);

        String url = authServiceUrl;
        log.info("Sending token validation request to: {}", url);

        try {
            ResponseEntity<TokenValidationResponse> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    entity,
                    TokenValidationResponse.class
            );

            return response.getBody();

        } catch (Exception e) {
            log.error("Error validating token: {}", e.getMessage(), e);
            throw e;
        }
    }
}
