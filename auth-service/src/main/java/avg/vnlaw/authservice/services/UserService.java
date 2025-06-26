package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    
    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElse(null);
    }

    
    public User getCurrentUserByEmail(String email) {
        User user = findByEmail(email);
        if (user == null) return null;
        return getUserCurrentService();
    }

    private User getUserCurrentService() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated())  return null;
        CustomUserDetail customUserDetail = (CustomUserDetail) authentication.getPrincipal();
        return customUserDetail.getUser();
    }
}
