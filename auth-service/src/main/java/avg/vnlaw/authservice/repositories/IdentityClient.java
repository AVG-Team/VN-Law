package avg.vnlaw.authservice.repositories;

import avg.vnlaw.authservice.dto.identity.TokenExchangeParam;
import avg.vnlaw.authservice.dto.identity.TokenExchangeResponse;
import avg.vnlaw.authservice.dto.identity.UserCreationParam;
import feign.QueryMap;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@FeignClient(name="identity-client", url="${idp.url}")
public interface IdentityClient {

    @PostMapping(value = "/realms/LegalWise/protocol/openid-connect/token",
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE)
    TokenExchangeResponse exchangeToken(@QueryMap TokenExchangeParam param);

    @PostMapping(value= "/admin/realms/LegalWise/users", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<?>  createUser(@RequestHeader("authorization") String token, @RequestBody UserCreationParam param);

    @GetMapping(value= "/admin/realms/LegalWise/users/${userId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    ResponseEntity<?> getUserByEmail(@PathVariable("userId") String userId, @RequestHeader("authorization") String token);
}
