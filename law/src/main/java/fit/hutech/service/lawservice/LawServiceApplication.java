package fit.hutech.service.lawservice;

import fit.hutech.service.lawservice.models.IndexVbqppl;
import fit.hutech.service.lawservice.repositories.IndexVbqpplRepository;
import fit.hutech.service.lawservice.services.implement.IndexVbqpplServiceImpl;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class LawServiceApplication {

	public static void main(String[] args) {
		SpringApplication.run(LawServiceApplication.class, args);
	}

}
