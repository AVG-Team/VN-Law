package avg.vnlaw.authservice.o2auth.services;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.entities.RoleType;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.o2auth.services.CustomOAuth2User;
import avg.vnlaw.authservice.repositories.RoleRepository;
import avg.vnlaw.authservice.repositories.UserRepository;
import avg.vnlaw.authservice.services.EmailService;
import avg.vnlaw.authservice.services.JwtService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class OAuth2Service extends DefaultOAuth2UserService {

    private static final Logger logger = LoggerFactory.getLogger(OAuth2Service.class);
    private final UserRepository userRepository;
    private final RoleRepository roleRepository; // Thêm RoleRepository
    private final JwtService jwtService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        logger.info("Loading OAuth2 user from request: {}", userRequest.getClientRegistration().getRegistrationId());
        OAuth2User oAuth2User = super.loadUser(userRequest);
        logger.info("OAuth2 user loaded: {}", oAuth2User.getAttributes());
        return processOAuth2User(oAuth2User);
    }

    private OAuth2User processOAuth2User(OAuth2User oAuth2User) {
        Map<String, Object> attributes = oAuth2User.getAttributes();
        String googleId = attributes.get("sub").toString();
        String email = attributes.get("email").toString();
        String name = attributes.get("name").toString();

        logger.info("Processing OAuth2 user with googleId: {} and email: {} and name: {}", googleId, email,name);

        User user = userRepository.findByGoogleId(googleId)
                .orElseGet(() -> {
                    logger.info("Registering new user with email: {}", email);
                    return registerNewUser(email, googleId, name);
                });

        return new CustomUserDetail(user);
    }

    private User registerNewUser(String email, String googleId, String name) {
        User user = new User();
        user.setEmail(email);
        user.setFirstName(name);
        user.setActive(true);
        String randomPassword = generateRandomPassword(12); // 12 ký tự
        user.setPassword(passwordEncoder.encode(randomPassword));

        // Lấy Role từ database thay vì tạo mới
        Role role = roleRepository.findByName(RoleType.USER)
                .orElseGet(() -> {
                    Role newRole = new Role();
                    newRole.setName(RoleType.USER);
                    return roleRepository.save(newRole); // Lưu Role nếu chưa tồn tại
                });
        user.setRole(role);

        return userRepository.save(user);
    }

    private String generateRandomPassword(int length) {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[length];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes).substring(0, length);
    }
}