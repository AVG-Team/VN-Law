package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.dto.ApiResponse;
import avg.vnlaw.authservice.dto.responses.CheckTokenResponse;
import avg.vnlaw.authservice.dto.requests.*;
import avg.vnlaw.authservice.dto.responses.*;
import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import avg.vnlaw.authservice.exception.AppException;
import avg.vnlaw.authservice.exception.ErrorCode;
import avg.vnlaw.authservice.services.AuthenticationService;
import avg.vnlaw.authservice.services.EmailService;
import avg.vnlaw.authservice.services.ReCaptchaService;
import avg.vnlaw.authservice.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.logging.Logger;

@Slf4j
@RestController
@RequestMapping("api/auth")
@RequiredArgsConstructor
@ResponseBody
public class AuthController {
    private final AuthenticationService authService;
    private final UserService userService;
    private final ReCaptchaService reCaptchaService;
    private final EmailService emailService;
    private final Logger logger = Logger.getLogger(AuthenticationService.class.getName());
    @Value("${spring.profiles.active}")
    private String activeProfile;


    @PostMapping("/register")
    public ApiResponse<?> register(
            @RequestBody RegisterRequest request
    ) {
        if (!"dev".equalsIgnoreCase(activeProfile)) {
            ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
            if (!reCaptchaResponse.isSuccess()) {
                throw new AppException(ErrorCode.RECAPCHA_INVALID);
            }
        }
        String message;
        AuthenticationResponse authResponse = authService.register(request);
        if (authResponse.getType() == AuthenticationResponseEnum.EMAIL_ALREADY_REGISTERED) {
            message = "Account is already registered";
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        } else {
            message = "Account registered successfully";
        }
        return ApiResponse.builder()
                .message(message)
                .data(authResponse)
                .build();

    }

    @PostMapping("/authenticate")
    public ApiResponse<?> authenticate(
            @RequestBody AuthenticationRequest request
    ) {
        if(!("dev".equalsIgnoreCase(activeProfile))) {
            ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
            if (!reCaptchaResponse.isSuccess()) {
                throw new AppException(ErrorCode.RECAPCHA_INVALID);
            }
        }

        String message;
        AuthenticationResponse authResponse = authService.authenticate(request);
        log.info("Authentication response: {}", authResponse);

        if (authResponse.getType() == AuthenticationResponseEnum.INVALID_CREDENTIALS) {
            message = "Invalid credentials";
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        } else if (authResponse.getType() == AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED) {
            message = "Account not activated";
            throw new AppException(ErrorCode.ACCOUNT_NOT_ACTIVATED);
        } else if (authResponse.getType() == AuthenticationResponseEnum.KEYCLOAK_ERROR) {
            message = authResponse.getMessage();
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        message = "Account authenticated successfully";
        return ApiResponse.builder()
                .message(message)
                .data(authResponse)
                .build();
    }

    @PostMapping("/google-token")
    public ResponseEntity<ApiResponse<?>> authenticateWithGoogleToken(@RequestBody GoogleTokenRequest request) {
        log.info("Google token: {}", request.getToken());
        log.info("Google provider: {}", request.getProvider());

        AuthenticationResponse authResponse = authService.authenticateWithGoogleToken(request.getProvider(), request.getToken());
        log.info("Authentication response: {}", authResponse);

        if (authResponse.getType() == AuthenticationResponseEnum.OK) {
            return ResponseEntity.ok(ApiResponse.builder()
                    .message("Account authenticated successfully")
                    .data(authResponse)
                    .build());
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.builder()
                            .message(authResponse.getMessage() != null ? authResponse.getMessage() : "Authentication failed")
                            .data(null)
                            .build());
        }
    }

    @PostMapping("/confirm-email")
    public ApiResponse<?> confirm(@RequestBody ConfirmEmailRequest request) {
        MessageResponse authResponse = authService.confirm(request.getToken());

        if(authResponse.getType() == HttpStatus.BAD_REQUEST) {
            return ApiResponse.builder()
                    .code(HttpStatus.BAD_REQUEST.value())
                    .message(authResponse.getMessage())
                    .data(null)
                    .build();
        }

        return ApiResponse.builder()
                .code(HttpStatus.OK.value())
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/forgot-password")
    public ApiResponse<?> forgotPassword(
            @RequestBody PasswordResetTokenRequest request
    ) {
//        Todo: Recaptcha
        if (!"dev".equalsIgnoreCase(activeProfile)) {
            ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
            if (!reCaptchaResponse.isSuccess()) {
                throw new AppException(ErrorCode.RECAPCHA_INVALID);
            }
        }

        MessageResponse authResponse = authService.forgotPassword(request.getEmail());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/change-password-with-token")
    public ApiResponse<?> changePassword(
            @RequestBody ChangePasswordRequest request
    ) {
//        Todo: Recaptcha
        if (!"dev".equalsIgnoreCase(activeProfile)) {
            ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
            if (!reCaptchaResponse.isSuccess()) {
                throw new AppException(ErrorCode.RECAPCHA_INVALID);
            }
        }
        MessageResponse authResponse = authService.changePassword(request.getToken(), request.getPassword());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/get-current-user")
    public ApiResponse<?> getCurrentUser(@RequestBody AccessTokenRequest request) {
        AuthenticationResponse response = authService.getCurrentUserByAccessToken(request.getToken());
        return ApiResponse.builder()
                .message("Profile retrieved successfully")
                .data(response)
                .build();
    }

    @GetMapping("/get-user-by-id/{userId}")
    public ApiResponse<?> getUserById(@PathVariable String userId) {
        log.info("Get user by ID request: {}", userId);
        UserDetailResponse userInfo = authService.getUserById(userId);
        return ApiResponse.builder()
                .message("Get User By User Id successfully")
                .data(userInfo)
                .build();
    }

    @PostMapping("/check-token-keycloak")
    public ApiResponse<?> checkTokenKeycloak(@RequestBody AccessTokenRequest request) {
        log.info("Check token request: {}", request);
        MessageResponse authResponse = authService.checkTokenKeycloak(request.getToken());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/validate-token")
    public ResponseEntity<CheckTokenResponse> validateToken(@RequestBody String token) {
        log.info("Received token validation request : {}", token);
        CheckTokenResponse response = authService.validateToken(token);
        log.info("Token validation response: {}", response);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/get-access-token-from-refresh-token")
    public ApiResponse<?> getAccessTokenFromRefreshToken(@RequestBody Map<String, String> request) {
        log.info("Get access token from refresh token request: {}", request);
        String token = request.get("token"); // Lấy chuỗi token từ JSON
        TokenExchangeResponse authResponse = authService.getAccessTokenFromRefreshToken(token);
        if (authResponse != null) {
            return ApiResponse.builder()
                    .message("Access token retrieved successfully")
                    .data(authResponse)
                    .build();
        } else {
            return ApiResponse.builder()
                    .message("Failed to get access token from refresh token")
                    .data(null)
                    .build();
        }
    }

    @PostMapping("/logout-keycloak")
    public ApiResponse<?> logoutKeycloak(@RequestBody AccessTokenRequest request) {
        log.info("Logout request: {}", request);
        MessageResponse authResponse = authService.logoutKeycloak(request.getToken());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }
}
