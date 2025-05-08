package avg.vnlaw.authservice.repositories;

import avg.vnlaw.authservice.dto.identity.TokenExchangeParam;
import avg.vnlaw.authservice.dto.identity.TokenExchangeResponse;
import avg.vnlaw.authservice.dto.identity.UserCreationParam;
import feign.QueryMap;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@FeignClient(name="identity-client", url="${idp.url}")
public interface IdentityClient {

    @PostMapping(value = "/realms/{realm}/protocol/openid-connect/token", consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    TokenExchangeResponse exchangeToken(@PathVariable("realm") String realm, @RequestBody TokenExchangeParam param);

    @PostMapping(value = "/admin/realms/vnlaw/users", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<?> createUser(@RequestHeader("Authorization") String token, @RequestBody UserCreationParam param);

    @GetMapping(value = "/admin/realms/vnlaw/users/{userId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<Map<String, Object>> getUserByUserId(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token);

    @PutMapping(value = "/admin/realms/vnlaw/users/{userId}/execute-actions-email", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<?> executeActionsEmail(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token, @RequestBody String[] actions);

    @PutMapping(value = "/admin/realms/vnlaw/users/{userId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<?> updateUser(@PathVariable("userId") String userId, @RequestHeader("Authorization") String token, @RequestBody Map<String, Object> userUpdate);

    @GetMapping("/realms/vnlaw/protocol/openid-connect/certs")
    ResponseEntity<Map<String, Object>> getCerts();
}
