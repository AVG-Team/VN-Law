package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.PasswordResetToken;
import avg.vnlaw.authservice.entities.Role;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import avg.vnlaw.authservice.enums.TokenTypeForgotPasswordEnum;
import avg.vnlaw.authservice.repositories.PasswordResetTokenRepository;
import avg.vnlaw.authservice.repositories.RoleRepository;
import avg.vnlaw.authservice.repositories.UserRepository;
import avg.vnlaw.authservice.requests.AuthenticationRequest;
import avg.vnlaw.authservice.requests.RegisterRequest;
import avg.vnlaw.authservice.responses.AuthenticationResponse;
import avg.vnlaw.authservice.responses.GetCurrentUserByAccessTokenResponse;
import avg.vnlaw.authservice.responses.MessageResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;
import java.util.logging.Logger;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final JwtService jwtService;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final EmailService emailService;
    private final TokenService tokenService;
    private final Logger logger = Logger.getLogger(AuthenticationService.class.getName());

    private void setPasswordResetToken(User user, TokenTypeForgotPasswordEnum tokenType, String token) {
        long expiration = 24L * 60 * 60 * 1000L;
        PasswordResetToken passwordResetToken = new PasswordResetToken();
        passwordResetToken.setToken(token);
        Timestamp expiryDate = new Timestamp(new Date().getTime() + expiration);
        passwordResetToken.setExpiryDate(expiryDate);
        passwordResetToken.setUser(user);
        passwordResetToken.setType(tokenType.value);
        passwordResetTokenRepository.save(passwordResetToken);
    }

    
    public AuthenticationResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.EMAIL_ALREADY_REGISTERED)
                    .build();
        }

        Role role = roleRepository.findById(request.getRole())
                .orElse(roleRepository.findFirstByOrderByIdAsc());

        User user = new User();
        user.setEmail(request.getEmail());
        user.setName(request.getName());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRole(role);
        user.setActive(false);
        userRepository.save(user);

        String token = "AVG_" + UUID.randomUUID() + System.currentTimeMillis() + "_VNLAW";
        setPasswordResetToken(user, TokenTypeForgotPasswordEnum.EMAIL_VERIFICATION, token);

        try {
            emailService.sendEmailRegister(user.getEmail(), user.getName(), token);
        } catch (Exception e) {
            logger.warning("error Send Mail : " + e.getMessage());
        }

        AuthenticationResponse response = new AuthenticationResponse();
        response.setRefreshToken(null);
        response.setAccessToken(null);
        response.setType(AuthenticationResponseEnum.OK);

        return response;
    }

    
    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );
        User user = userRepository.findByEmail(request.getEmail()).orElseThrow();

        CustomUserDetail customUserDetail = new CustomUserDetail(user);
        if(!customUserDetail.isEnabled()){
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED)
                    .build();
        }

        String jwtToken = jwtService.generateToken(customUserDetail, true);
        String refreshToken = jwtService.generateRefreshToken(customUserDetail);

        tokenService.revokedAllUserTokens(user);
        tokenService.saveUserToken(user,jwtToken);
        return AuthenticationResponse.builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .name(user.getName())
                .role(user.getRole().getName())
                .type(AuthenticationResponseEnum.OK)
                .build();
    }

    
    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException, NoSuchAlgorithmException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if(authHeader == null || !authHeader.startsWith("Bearer")){
            return;
        }
        refreshToken = authHeader.substring(7);
        userEmail = jwtService.extractUsername(refreshToken);
        if(userEmail != null){
            User user = userRepository.findByEmail(userEmail).orElseThrow();
            CustomUserDetail customUserDetail = new CustomUserDetail(user);
            if (jwtService.isTokenValid(refreshToken,customUserDetail)){
                var accessToken = jwtService.generateToken(customUserDetail);
                tokenService.revokedAllUserTokens(user);
                tokenService.saveUserToken(user,accessToken);
                var authResponse = AuthenticationResponse.builder()
                        .accessToken(accessToken)
                        .refreshToken(refreshToken)
                        .build();
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }

    
    public MessageResponse confirm(String token) {
        PasswordResetToken passwordResetToken = passwordResetTokenRepository.findByToken(token).orElseThrow();
        if (passwordResetToken.getExpiryDate().before(new Date())) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Token is expired")
                    .build();
        }

        passwordResetToken.setActivated(true);
        passwordResetToken.getUser().setActive(true);
        passwordResetTokenRepository.save(passwordResetToken);

        return MessageResponse.builder()
                .type(HttpStatus.OK)
                .message("Verify Successfully")
                .build();
    }

    
    public GetCurrentUserByAccessTokenResponse getCurrentUserByAccessToken(String token) {
        User user = tokenService.getUserByToken(token);
        return GetCurrentUserByAccessTokenResponse.builder()
                .name(user.getName())
                .role(user.getRole().getName())
                .build();
    }

    
    public MessageResponse forgotPassword(String email) {
        if (email == null || email.isEmpty()) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Email is required")
                    .build();
        }

        User user = userRepository.findByEmail(email).orElse(null);

        if (user == null) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Email not found")
                    .build();
        }

        if (!user.isActive()) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Account is not activated")
                    .build();
        }

        if (user.getPasswordResetTokens().size() == 10) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("You have reached the limit of password reset, Please contact admin to reactivate")
                    .build();
        }

        String token = "AVG_" + UUID.randomUUID() + System.currentTimeMillis() + "_VNLAW";
        setPasswordResetToken(user, TokenTypeForgotPasswordEnum.PASSWORD_RESET, token);

        try {
            emailService.sendEmailForgotPassword(user.getEmail(), user.getName(), token);
        } catch (Exception e) {
            logger.warning("error Send Mail : " + e.getMessage());
            logger.warning("error Send Mail : " + e.getMessage());
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Error Send Mail")
                    .build();
        }

        return MessageResponse.builder()
                .type(HttpStatus.OK)
                .message("Email sent successfully")
                .build();
    }

    
    public MessageResponse changePassword(String token, String password) {
        if (token == null || token.isEmpty() || password == null || password.isEmpty()) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Token and password is required")
                    .build();
        }

        PasswordResetToken passwordResetToken = passwordResetTokenRepository.findByToken(token).orElse(null);
        if (passwordResetToken == null
                || passwordResetToken.getExpiryDate().before(new Date())
                || passwordResetToken.isActivated()
        ) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Token is invalid or expired or used")
                    .build();
        }

        User user = passwordResetToken.getUser();
        user.setPassword(passwordEncoder.encode(password));
        userRepository.save(user);
        passwordResetToken.setActivated(true);
        passwordResetTokenRepository.save(passwordResetToken);

        return MessageResponse.builder()
                .type(HttpStatus.OK)
                .message("Password reset successfully")
                .build();
    }
}
