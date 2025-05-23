package avg.vnlaw.lawservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
@EnableCaching
public class LawServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(LawServiceApplication.class, args);
	}

}
