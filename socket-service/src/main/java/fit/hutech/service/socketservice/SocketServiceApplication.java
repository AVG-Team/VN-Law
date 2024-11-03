package fit.hutech.service.socketservice;

import fit.hutech.service.socketservice.services.AsyncChatService;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

@SpringBootApplication
@EnableDiscoveryClient
public class SocketServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(SocketServiceApplication.class, args);
    }

}
