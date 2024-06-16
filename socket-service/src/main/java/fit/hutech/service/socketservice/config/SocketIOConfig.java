package fit.hutech.service.socketservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker
public class SocketIOConfig implements WebSocketMessageBrokerConfigurer {
    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.setApplicationDestinationPrefixes("/web");
        registry.enableSimpleBroker("/server");
    }

//     với các trình duyệt cũ không hỗ trợ đầy đủ websocket
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        String reactUrl = System.getenv("REACT_URL");
        registry.addEndpoint("/ws").setAllowedOriginPatterns("*").withSockJS(); // Endpoint WebSocket và hỗ trợ SockJS
        registry.addEndpoint("/ws").setAllowedOrigins(reactUrl).withSockJS();
        registry.addEndpoint("/ws").setAllowedOrigins("http://localhost:3000").withSockJS();
        registry.addEndpoint("/ws").setAllowedOrigins("http://localhost:80").withSockJS();
        registry.addEndpoint("/ws").setAllowedOrigins("http://react-app:3000").withSockJS();
        registry.addEndpoint("/ws").setAllowedOrigins("http://react-app:80").withSockJS();
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
