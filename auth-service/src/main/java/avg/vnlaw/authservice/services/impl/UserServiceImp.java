package avg.vnlaw.authservice.services.impl;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.repositories.RoleRepository;
import avg.vnlaw.authservice.repositories.UserRepository;
import avg.vnlaw.authservice.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImp implements UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public User registerUser(String email, String password, String roleName) {
        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        Role role = roleRepository.findByName(Role.RoleType.USER)
                .orElseThrow(() -> new RuntimeException("Role not found"));
        user.setRole(role);
        return userRepository.save(user);
    }

    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public void verifyUserEmail(String email) {
        User user = findByEmail(email);
        user.setEmailVerified(true);
        userRepository.save(user);
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = findByEmail(email);
        return new CustomUserDetail(user);
    }
}
