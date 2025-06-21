package avg.vnlaw.lawservice.config;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class SwaggerConfig {
    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
                .group("public")
                .pathsToMatch("/**")
                .build();
    }

    @Bean
    public OpenAPI customOpenAPI() {
        Server ngrokServer = new Server();
        ngrokServer.setUrl("https://a46b-2a09-bac1-7a80-10-00-3c5-15.ngrok-free.app"); // 👈 Đổi theo domain ngrok hiện tại
        return new OpenAPI().servers(List.of(ngrokServer));
    }
}
