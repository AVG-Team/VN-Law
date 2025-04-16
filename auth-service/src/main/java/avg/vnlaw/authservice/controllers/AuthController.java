package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.dto.ApiResponse;
import avg.vnlaw.authservice.dto.requests.*;
import avg.vnlaw.authservice.dto.responses.*;
import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import avg.vnlaw.authservice.exception.AppException;
import avg.vnlaw.authservice.exception.ErrorCode;
import avg.vnlaw.authservice.services.AuthenticationService;
import avg.vnlaw.authservice.services.ReCaptchaService;
import avg.vnlaw.authservice.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/auth")
@RequiredArgsConstructor
@ResponseBody
public class AuthController {
    private final AuthenticationService authService;
    private final UserService userService;
    private final ReCaptchaService reCaptchaService;
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
        }
        message = "Account registered successfully";
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
        try {
            if (authResponse.getType() == AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED)
                throw new AppException(ErrorCode.ACCOUNT_NOT_ACTIVATED);

            message = "Account authenticated successfully";
            return ApiResponse.builder()
                    .message(message)
                    .data(authResponse)
                    .build();
        } catch (Exception e) {
            throw new AppException(ErrorCode.PASSWORD_INCORRECT);
        }
    }

    @PostMapping("/confirm-email")
    public ApiResponse<?> confirm(
            @RequestBody ConfirmEmailRequest request
    ) {
        MessageResponse authResponse = authService.confirm(request.getToken());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/forgot-password")
    public ApiResponse<?> forgotPassword(
            @RequestBody PasswordResetTokenRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            throw new AppException(ErrorCode.RECAPCHA_INVALID);
        }

        MessageResponse authResponse = authService.forgotPassword(request.getEmail());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/change-password")
    public ApiResponse<?> changePassword(
            @RequestBody ChangePasswordRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            throw new AppException(ErrorCode.RECAPCHA_INVALID);
        }
        MessageResponse authResponse = authService.changePassword(request.getToken(), request.getPassword());
        return ApiResponse.builder()
                .message(authResponse.getMessage())
                .data(authResponse.getType())
                .build();
    }

    @PostMapping("/get-current-user")
    public ApiResponse<?> getCurrentUser(@RequestBody AccessTokenRequest request) {
        GetCurrentUserByAccessTokenResponse response = authService.getCurrentUserByAccessToken(request.getToken());
        return ApiResponse.builder()
                .message("Profile retrieved successfully")
                .data(response)
                .build();
    }
}
