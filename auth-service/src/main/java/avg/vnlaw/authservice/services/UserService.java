package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.entities.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.multipart.MultipartFile;

public interface UserService {
    User registerUser(String email, String password, String roleName);
    User findByEmail(String email);
    void verifyUserEmail(String email);
    UserDetails loadUserByUsername(String email) throws UsernameNotFoundException;
}
