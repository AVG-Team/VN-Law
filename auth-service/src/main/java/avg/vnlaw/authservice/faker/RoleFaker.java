package avg.vnlaw.authservice.faker;

import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.enums.RoleEnum;
import avg.vnlaw.authservice.repositories.RoleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class RoleFaker implements CommandLineRunner {

    private final RoleRepository roleRepository;

    public RoleFaker(RoleRepository roleRepository){
        this.roleRepository = roleRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        if(roleRepository.findAll().isEmpty()){
            RoleEnum[] roleEnums = RoleEnum.values();
            for(RoleEnum roleEnum : roleEnums){
                Role role = new Role();
                role.setName(roleEnum.name());
                roleRepository.save(role);
            }
        }

    }
}
