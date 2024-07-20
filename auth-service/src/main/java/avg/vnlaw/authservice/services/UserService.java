package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.entities.User;
import org.springframework.web.multipart.MultipartFile;

public interface UserService {
    User findByEmail(String email);
    User getCurrentUserByEmail(String email);
}
