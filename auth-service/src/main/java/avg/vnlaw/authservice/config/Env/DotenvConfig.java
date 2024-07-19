package avg.vnlaw.authservice.config.Env;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.util.Map;

@Configuration
@PropertySource(value = ".env")
public class DotenvConfig implements EnvironmentPostProcessor {

//    @Bean
//    public Dotenv dotenv() {
//        Dotenv dotenv = Dotenv.configure().load();
//        dotenv.entries().forEach(entry -> System.setProperty(entry.getKey(), entry.getValue()));
//        return dotenv;
//    }

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        Dotenv dotenv = Dotenv.configure().load();
        dotenv.entries().forEach(entry -> environment.getPropertySources()
                .addLast(new MapPropertySource("dotenv", Map.of(entry.getKey(), entry.getValue())))); // Chú ý: addLast()
    }
}
