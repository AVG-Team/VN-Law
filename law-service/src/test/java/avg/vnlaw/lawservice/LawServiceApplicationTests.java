package avg.vnlaw.lawservice;

import io.github.cdimascio.dotenv.Dotenv;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class LawServiceApplicationTests {

	private static final Logger log = LoggerFactory.getLogger(LawServiceApplicationTests.class);

	@BeforeAll
	static void setup() {
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
	}

	@Test
	void contextLoads() {
	}

}
