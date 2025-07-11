package avg.vnlaw.lawservice;

import avg.vnlaw.lawservice.dto.response.LawDocument;
import avg.vnlaw.lawservice.kafka.KafkaProducerService;
import io.github.cdimascio.dotenv.Dotenv;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.retry.annotation.EnableRetry;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
@EnableCaching
@EnableRetry
public class LawServiceApplication {


	private static final Logger log = LoggerFactory.getLogger(LawServiceApplication.class);

	public static void main(String[] args) {
		Dotenv dotenv = Dotenv.configure().directory(".").load();
		System.setProperty("AVG_VNLAW_BOOTSTRAP_SERVER", dotenv.get("AVG_VNLAW_BOOTSTRAP_SERVER"));
		System.setProperty("AVG_VNLAW_KAFKA_PORT", dotenv.get("AVG_VNLAW_KAFKA_PORT"));
		System.setProperty("AVG_VNLAW_REDIS_HOST", dotenv.get("AVG_VNLAW_REDIS_HOST"));
		System.setProperty("AVG_VNLAW_REDIS_PORT", dotenv.get("AVG_VNLAW_REDIS_PORT"));
		System.setProperty("AVG_VNLAW_AUTH_SERVICE_HOST", dotenv.get("AVG_VNLAW_AUTH_SERVICE_HOST"));
		System.setProperty("AVG_VNLAW_AUTH_PORT", dotenv.get("AVG_VNLAW_AUTH_PORT"));
		System.setProperty("AVG_VNLAW_ELASTICSEARCH_HOST", dotenv.get("AVG_VNLAW_ELASTICSEARCH_HOST"));
		System.setProperty("AVG_VNLAW_ELASTICSEARCH_PORT", dotenv.get("AVG_VNLAW_ELASTICSEARCH_PORT"));
		System.setProperty("AVG_VNLAW_DB_HOST", dotenv.get("AVG_VNLAW_DB_HOST"));
		System.setProperty("AVG_VNLAW_DB_USERNAME", dotenv.get("AVG_VNLAW_DB_USERNAME"));
		System.setProperty("AVG_VNLAW_DB_PASSWORD", dotenv.get("AVG_VNLAW_DB_PASSWORD"));
		System.setProperty("AVG_VNLAW_DB_PORT", dotenv.get("AVG_VNLAW_DB_PORT"));

		log.info("Environment variables loaded successfully.");
		log.info("BOOTSTRAP_SERVER: {}", System.getProperty("AVG_VNLAW_BOOTSTRAP_SERVER"));
		log.info("KAFKA_PORT: {}", System.getProperty("AVG_VNLAW_KAFKA_PORT"));
		log.info("REDIS_HOST: {}", System.getProperty("AVG_VNLAW_REDIS_HOST"));
		log.info("REDIS_PORT: {}", System.getProperty("AVG_VNLAW_REDIS_PORT"));
		log.info("AUTH_SERVICE_HOST: {}", System.getProperty("AVG_VNLAW_AUTH_SERVICE_HOST"));
		log.info("AUTH_PORT: {}", System.getProperty("AVG_VNLAW_AUTH_PORT"));
		log.info("ELASTICSEARCH_HOST: {}", System.getProperty("AVG_VNLAW_ELASTICSEARCH_HOST"));
		log.info("ELASTICSEARCH_PORT: {}", System.getProperty("AVG_VNLAW_ELASTICSEARCH_PORT"));
		log.info("DB_HOST: {}", System.getProperty("AVG_VNLAW_DB_HOST"));
		log.info("DB_USERNAME: {}", System.getProperty("AVG_VNLAW_DB_USERNAME"));
		log.info("DB_PASSWORD: {}", System.getProperty("AVG_VNLAW_DB_PASSWORD"));
		log.info("DB_PORT: {}", System.getProperty("AVG_VNLAW_DB_PORT"));
		SpringApplication.run(LawServiceApplication.class, args);
	}

}
