package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.dto.identity.Credential;
import avg.vnlaw.authservice.dto.identity.TokenExchangeParam;
import avg.vnlaw.authservice.dto.identity.TokenExchangeResponse;
import avg.vnlaw.authservice.dto.identity.UserCreationParam;
import avg.vnlaw.authservice.dto.responses.KeycloakErrorResponse;
import avg.vnlaw.authservice.entities.*;
import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import avg.vnlaw.authservice.enums.TokenTypeForgotPasswordEnum;
import avg.vnlaw.authservice.mapper.UserMapper;
import avg.vnlaw.authservice.repositories.IdentityClient;
import avg.vnlaw.authservice.repositories.PasswordResetTokenRepository;
import avg.vnlaw.authservice.repositories.RoleRepository;
import avg.vnlaw.authservice.repositories.UserRepository;
import avg.vnlaw.authservice.dto.requests.AuthenticationRequest;
import avg.vnlaw.authservice.dto.requests.RegisterRequest;
import avg.vnlaw.authservice.dto.responses.AuthenticationResponse;
import avg.vnlaw.authservice.dto.responses.GetCurrentUserByAccessTokenResponse;
import avg.vnlaw.authservice.dto.responses.MessageResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import feign.FeignException;
import io.github.cdimascio.dotenv.Dotenv;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SigningKeyResolverAdapter;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.math.BigInteger;
import java.security.Key;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;
import java.sql.Timestamp;
import java.util.*;
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
    private final ObjectMapper objectMapper;
    private final IdentityClient identityClient;
    private final UserMapper userMapper;
    @Value("${spring.profiles.active}")
    private String activeProfile;
    @Value("${idp.client_id}")
    @NonFinal
    private String idpClientId;
    @Value("${idp.client_secret}")
    @NonFinal
    private String idpClientSecret;

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

    private String extractUserId(ResponseEntity<?> response) {
        String location = response.getHeaders().get("Location").getFirst();
        String[] splitedPart = location.split("/");
        return splitedPart[splitedPart.length - 1];
    }

    public TokenExchangeResponse getTokenAdmin() {
        Dotenv dotenv = Dotenv.configure()
                .directory("./")
                .load();

        String username_admin = dotenv.get("KEYCLOAK_ADMIN_USERNAME");
        String password_admin = dotenv.get("KEYCLOAK_ADMIN_PASSWORD");
        TokenExchangeParam tokenExchangeParam = TokenExchangeParam.builder()
                .username(username_admin)
                .password(password_admin)
                .build();
        log.info("Token exchange param: {}", tokenExchangeParam.toString());
        return identityClient.exchangeToken("master",tokenExchangeParam);
    }

    public AuthenticationResponse register(RegisterRequest request) {
        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.EMAIL_ALREADY_REGISTERED)
                    .build();
        }

        Role role = roleRepository.findByName(RoleType.USER)
                .orElseThrow(() -> new IllegalArgumentException("Role USER not found"));
        // create account in keycloak
        // exchange client token
        log.info("Client id: {}", idpClientId);

        var tokenKeyCloak = getTokenAdmin();
        if (tokenKeyCloak == null) {
            log.error("Failed to get token from Keycloak");
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                    .build();
        }

        log.info("Client token: {}", tokenKeyCloak.getAccessToken());
        log.info("INfo request: {}", request.toString());
        // create user with client token and given info
        try {
            var creationResponse = identityClient.createUser(
                    "Bearer " + tokenKeyCloak.getAccessToken(),
                    UserCreationParam.builder()
                            .username(request.getEmail())
                            .email(request.getEmail())
                            .firstName(request.getFirstName())
                            .lastName(request.getLastName())
                            .enabled(true)
                            .emailVerified(false)
                            .credentials(List.of(Credential.builder()
                                    .type("password")
                                    .temporary(false)
                                    .value(request.getPassword())
                                    .build()))
                            .build()
            );


            // get userid from keyCloak
            String userId = extractUserId(creationResponse);

            User user = new User();
            log.info("user: {}", user.toString());
            log.info("request: {}", request.toString());
            user.setUsername(request.getUsername());
            user.setEmail(request.getEmail());
            user.setFirstName(request.getFirstName());
            user.setLastName(request.getLastName());
            user.setPassword(passwordEncoder.encode(request.getPassword()));
            user.setRole(role);
            user.setKeycloakId(userId);
            user.setActive("prod".equalsIgnoreCase(activeProfile));

            userRepository.save(user);

            String token = "AVG_" + UUID.randomUUID() + System.currentTimeMillis() + "_VNLAW";
            setPasswordResetToken(user, TokenTypeForgotPasswordEnum.EMAIL_VERIFICATION, token);

            try {
                emailService.sendEmailRegister(user.getEmail(), user.getUsername(), token);
            } catch (Exception e) {
                logger.warning("error Send Mail : " + e.getMessage());
            }

            AuthenticationResponse response = new AuthenticationResponse();
            response.setRefreshToken(tokenKeyCloak.getRefreshToken());
            response.setAccessToken(tokenKeyCloak.getAccessToken());
            response.setType(AuthenticationResponseEnum.OK);
            response.setEmail(user.getEmail());
            response.setName(user.getFirstName() + " " + user.getLastName());

            return response;
        } catch (Exception e) {
            log.error("Failed to create user in Keycloak: {}", e.getMessage());
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                    .build();
        }
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        TokenExchangeParam tokenExchangeParam = TokenExchangeParam.builder()
                .username(request.getEmail())
                .password(request.getPassword())
                .client_id(idpClientId)
                .client_secret(idpClientSecret)
                .grant_type("password")
                .build();

        try {
            TokenExchangeResponse tokenResponse = identityClient.exchangeToken("vnlaw", tokenExchangeParam);
            log.info("Token exchange response: {}", tokenResponse.toString());
            if (tokenResponse.getAccessToken() == null) {
                return AuthenticationResponse.builder()
                        .type(AuthenticationResponseEnum.INVALID_CREDENTIALS)
                        .build();
            }

            // Find user in local database
            User user = userRepository.findByEmail(request.getEmail()).orElseThrow();
            CustomUserDetail customUserDetail = new CustomUserDetail(user);
            if (!customUserDetail.isEnabled()) {
                return AuthenticationResponse.builder()
                        .type(AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED)
                        .build();
            }

            // Save token to local database
            tokenService.revokedAllUserTokens(user);
            tokenService.saveUserToken(user, tokenResponse.getAccessToken());

            return AuthenticationResponse.builder()
                    .accessToken(tokenResponse.getAccessToken())
                    .refreshToken(tokenResponse.getRefreshToken())
                    .name(user.getUsername())
                    .email(user.getEmail())
                    .role(user.getRole().getName().name())
                    .type(AuthenticationResponseEnum.OK)
                    .build();
        } catch (FeignException.BadRequest ex) {
            log.error("Keycloak authentication failed: {}", ex.getMessage());
            try {
                // Parse Keycloak error response
                String errorResponse = ex.contentUTF8();
                KeycloakErrorResponse error = objectMapper.readValue(errorResponse, KeycloakErrorResponse.class);
                if ("invalid_grant".equals(error.getError()) && "Account is not fully set up".equals(error.getErrorDescription())) {
                    return AuthenticationResponse.builder()
                            .type(AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED)
                            .message("Account is not fully set up. Please verify your email.")
                            .build();
                }
                return AuthenticationResponse.builder()
                        .type(AuthenticationResponseEnum.INVALID_CREDENTIALS)
                        .message(error.getErrorDescription())
                        .build();
            } catch (IOException e) {
                log.error("Failed to parse Keycloak error response: {}", e.getMessage());
                return AuthenticationResponse.builder()
                        .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                        .message("Authentication failed due to Keycloak error")
                        .build();
            }
        } catch (Exception ex) {
            log.error("Unexpected error during authentication: {}", ex.getMessage());
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                    .message("Unexpected error during authentication")
                    .build();
        }
    }

    public AuthenticationResponse authenticateWithGoogleToken(String provider, String googleToken) {
        TokenExchangeParam tokenExchangeParam = TokenExchangeParam.builder()
                .grant_type("urn:ietf:params:oauth:grant-type:token-exchange")
                .subject_token_type("urn:ietf:params:oauth:token-type:access_token")
                .client_id(idpClientId)
                .client_secret(idpClientSecret)
                .subject_issuer(provider)
                .subject_token(googleToken)
                .build();

        try {
            TokenExchangeResponse tokenResponse = identityClient.exchangeToken("vnlaw", tokenExchangeParam);
            log.info("Token exchange response: {}", tokenResponse.toString());
            if (tokenResponse.getAccessToken() == null) {
                return AuthenticationResponse.builder()
                        .type(AuthenticationResponseEnum.INVALID_CREDENTIALS)
                        .message("Invalid Google token")
                        .build();
            }

            ResponseEntity<Map<String, Object>> certsResponse = identityClient.getCerts();
            Map<String, Object> certs = certsResponse.getBody();
            if (certs == null || !certs.containsKey("keys")) {
                throw new RuntimeException("Failed to retrieve Keycloak public keys");
            }

            List<Map<String, Object>> keys = (List<Map<String, Object>>) certs.get("keys");
            Claims claims = Jwts.parserBuilder()
                    .setSigningKeyResolver(new SigningKeyResolverAdapter() {
                        @Override
                        public PublicKey resolveSigningKey(JwsHeader header, Claims claims) {
                            String kid = header.getKeyId();
                            for (Map<String, Object> key : keys) {
                                if (kid.equals(key.get("kid"))) {
                                    try {
                                        String n = (String) key.get("n");
                                        String e = (String) key.get("e");
                                        BigInteger modulus = new BigInteger(1, Base64.getUrlDecoder().decode(n));
                                        BigInteger exponent = new BigInteger(1, Base64.getUrlDecoder().decode(e));
                                        RSAPublicKeySpec spec = new RSAPublicKeySpec(modulus, exponent);
                                        KeyFactory factory = KeyFactory.getInstance("RSA");
                                        return factory.generatePublic(spec);
                                    } catch (Exception ex) {
                                        log.error("Failed to parse public key: {}", ex.getMessage());
                                        return null;
                                    }
                                }
                            }
                            log.error("No matching key found for kid: {}", kid);
                            return null;
                        }
                    })
                    .build()
                    .parseClaimsJws(tokenResponse.getAccessToken())
                    .getBody();

            String email = claims.get("email", String.class);
            String username = claims.get("preferred_username", String.class);
            String firstName = claims.get("given_name", String.class);
            String lastName = claims.get("family_name", String.class);
            String keycloakId = claims.get("sub", String.class);

            log.info("User info from token: email={}, username={}, firstName={}, lastName={}, keycloakId={}",
                    email, username, firstName, lastName, keycloakId);

            User user = userRepository.findByEmail(email).orElseGet(() -> {
                User newUser = new User();
                newUser.setEmail(email);
                newUser.setUsername(username);
                newUser.setFirstName(firstName);
                newUser.setLastName(lastName);
                newUser.setRole(roleRepository.findByName(RoleType.USER).orElseThrow());
                newUser.setKeycloakId(keycloakId);
                newUser.setActive(true);
                newUser.setPassword(passwordEncoder.encode("avg_vnlaw"));
                return userRepository.save(newUser);
            });

            tokenService.revokedAllUserTokens(user);
            tokenService.saveUserToken(user, tokenResponse.getAccessToken());

            return AuthenticationResponse.builder()
                    .accessToken(tokenResponse.getAccessToken())
                    .refreshToken(tokenResponse.getRefreshToken())
                    .name(user.getFirstName() + " " + user.getLastName())
                    .email(user.getEmail())
                    .keycloakId(user.getKeycloakId())
                    .role(user.getRole().getName().name())
                    .type(AuthenticationResponseEnum.OK)
                    .build();
        } catch (FeignException ex) {
            log.error("Keycloak authentication failed: {}", ex.getMessage());
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                    .message("Authentication failed due to Keycloak error")
                    .build();
        } catch (Exception ex) {
            log.error("Unexpected error during Google authentication: {}", ex.getMessage());
            return AuthenticationResponse.builder()
                    .type(AuthenticationResponseEnum.KEYCLOAK_ERROR)
                    .message("Unexpected error during authentication")
                    .build();
        }
    }

    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException, NoSuchAlgorithmException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if (authHeader == null || !authHeader.startsWith("Bearer")) {
            return;
        }
        refreshToken = authHeader.substring(7);
        userEmail = jwtService.extractUsername(refreshToken);
        if (userEmail != null) {
            User user = userRepository.findByEmail(userEmail).orElseThrow();
            CustomUserDetail customUserDetail = new CustomUserDetail(user);
            if (jwtService.isTokenValid(refreshToken, customUserDetail)) {
                var accessToken = jwtService.generateToken(customUserDetail);
                tokenService.revokedAllUserTokens(user);
                tokenService.saveUserToken(user, accessToken);
                var authResponse = AuthenticationResponse.builder()
                        .accessToken(accessToken)
                        .refreshToken(refreshToken)
                        .build();
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }


    public MessageResponse confirm(String token) {
        log.info("Confirm token: {}", token);
        Optional<PasswordResetToken> passwordResetTokenOptional = passwordResetTokenRepository.findByToken(token);

        if (passwordResetTokenOptional.isEmpty()) {
            return MessageResponse.builder()
                    .type(HttpStatus.NOT_FOUND)
                    .message("Token không tồn tại hoặc không hợp lệ")
                    .build();
        }

        PasswordResetToken passwordResetToken = passwordResetTokenOptional.get();

        if (passwordResetToken.getExpiryDate().before(new Date())) {
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Token is expired")
                    .build();
        }

        passwordResetToken.setActivated(true);
        passwordResetToken.getUser().setActive(true);
        passwordResetTokenRepository.save(passwordResetToken);

        User user = passwordResetToken.getUser();
        String keycloakId = user.getKeycloakId();

        try {
            MessageResponse response = emailService.verifyEmail(keycloakId, getTokenAdmin().getAccessToken());
            return MessageResponse.builder()
                    .type(HttpStatus.OK)
                    .message("Verify Successfully")
                    .build();
        } catch (Exception e) {
            logger.warning("error Send Mail : " + e.getMessage());
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Error Send Mail")
                    .build();
        }
    }

    public GetCurrentUserByAccessTokenResponse getCurrentUserByAccessToken(String token) {
        User user = tokenService.getUserByToken(token);
        return GetCurrentUserByAccessTokenResponse.builder()
                .name(user.getUsername())
                .role(user.getRole().getName().name())
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
            emailService.sendEmailForgotPassword(user.getEmail(), user.getUsername(), token);
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

        try {
            Map<String, Object> credentials = new HashMap<>();
            credentials.put("type", "password");
            credentials.put("value", password);
            credentials.put("temporary", false);

            List<Map<String, Object>> credentialsList = new ArrayList<>();
            credentialsList.add(credentials);

            Map<String, Object> userUpdate = new HashMap<>();
            userUpdate.put("credentials", credentialsList);

            ResponseEntity<?> updateResponse = identityClient.updateUser(user.getKeycloakId(), "Bearer " + getTokenAdmin().getAccessToken(), userUpdate);
            if (updateResponse.getStatusCode().is2xxSuccessful()) {
                log.info("Password updated successfully for user: {}", user.getKeycloakId());

                user.setPassword(passwordEncoder.encode(password));
                userRepository.save(user);
                passwordResetToken.setActivated(true);
                passwordResetTokenRepository.save(passwordResetToken);

                return MessageResponse.builder()
                        .type(HttpStatus.OK)
                        .message("Password reset successfully")
                        .build();
            } else {
                log.error("Failed to update password for user: {}, status: {}", user.getKeycloakId(), updateResponse.getStatusCode());
                throw new MessagingException("Failed to update password for user: " + user.getKeycloakId());
            }
        } catch (Exception e) {
            logger.warning("Error Change Password : " + e.getMessage());
            return MessageResponse.builder()
                    .type(HttpStatus.BAD_REQUEST)
                    .message("Error Change Password")
                    .build();
        }
    }
}
