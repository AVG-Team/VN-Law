package avg.vnlaw.authservice.config;

import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.entities.RoleType;
import avg.vnlaw.authservice.repositories.RoleRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer {

    private final RoleRepository roleRepository;

    @PostConstruct
    public void init() {
        if (roleRepository.findByName(RoleType.USER).isEmpty()) {
            Role userRole = new Role();
            userRole.setName(RoleType.USER);
            roleRepository.save(userRole);
        }
        if (roleRepository.findByName(RoleType.ADMIN).isEmpty()) {
            Role adminRole = new Role();
            adminRole.setName(RoleType.ADMIN);
            roleRepository.save(adminRole);
        }
        if (roleRepository.findByName(RoleType.SUPER_USER).isEmpty()) {
            Role superUserRole = new Role();
            superUserRole.setName(RoleType.SUPER_USER);
            roleRepository.save(superUserRole);
        }
    }
}