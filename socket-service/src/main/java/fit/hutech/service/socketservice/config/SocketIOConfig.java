package fit.hutech.service.socketservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.socket.config.annotation.*;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

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
        System.out.println("Registering Stomp Endpoints");
        registry.addEndpoint("/ws").setAllowedOrigins("*");
        registry.addEndpoint("/ws").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/ws").setAllowedOriginPatterns("*").withSockJS(); // Endpoint WebSocket và hỗ trợ SockJS
    }

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    @Bean
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setAllowCoreThreadTimeOut(true);
        executor.setCorePoolSize(10); // number of core thread
        executor.setMaxPoolSize(10); // number of max thread
        executor.setQueueCapacity(500); // size
        executor.setThreadNamePrefix("socket-serviceThread-");
        executor.initialize();
        return executor;
    }
}