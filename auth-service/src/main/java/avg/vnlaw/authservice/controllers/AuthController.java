package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.enums.AuthenticationResponseEnum;
import avg.vnlaw.authservice.requests.*;
import avg.vnlaw.authservice.responses.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/auth")
@RequiredArgsConstructor
@ResponseBody
public class AuthController {
    private final AuthenticationService authService;
    private final UserService userService;
    private final ReCaptchaService reCaptchaService;

    @PostMapping("/register")
    public ResponseEntity<?> register(
            @RequestBody RegisterRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            return ResponseHandler.responseBadRequest("Captcha verification failed, Please try again.");
        }
        String message;
        AuthenticationResponse authResponse = authService.register(request);
        if (authResponse.getType() == AuthenticationResponseEnum.EMAIL_ALREADY_REGISTERED) {
            message = "Account is already registered";
            return ResponseHandler.responseBuilder(message, HttpStatus.UNAUTHORIZED);
        }
        message = "Account registered successfully";
        return ResponseHandler.responseOk(message, authResponse);

    }

    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(
            @RequestBody AuthenticationRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            return ResponseHandler.responseBadRequest("Captcha verification failed, Please try again.");
        }
        String message;
        AuthenticationResponse authResponse = authService.authenticate(request);
        try {
            if (authResponse.getType() == AuthenticationResponseEnum.ACCOUNT_NOT_ACTIVATED) {
                message = "Account is not activated";
                return ResponseHandler.responseBadRequest(message);
            }

            message = "Account authenticated successfully";
            return ResponseHandler.responseOk(message, authResponse);
        } catch (Exception e) {
            message = "Account or password is incorrect";
            return ResponseHandler.responseBuilder(message, HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping("/confirm-email")
    public ResponseEntity<?> confirm(
            @RequestBody ConfirmEmailRequest request
    ) {
        MessageResponse authResponse = authService.confirm(request.getToken());
        return ResponseHandler.responseBuilder(authResponse.getMessage(), authResponse.getType());
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(
            @RequestBody PasswordResetTokenRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            return ResponseHandler.responseBadRequest("Captcha verification failed, Please try again.");
        }

        MessageResponse authResponse = authService.forgotPassword(request.getEmail());
        return ResponseHandler.responseBuilder(authResponse.getMessage(), authResponse.getType());
    }

    @PostMapping("/change-password")
    public ResponseEntity<?> changePassword(
            @RequestBody ChangePasswordRequest request
    ) {
        ReCaptchaResponse reCaptchaResponse = reCaptchaService.verify(request.getRecaptchaToken());
        if (!reCaptchaResponse.isSuccess()) {
            return ResponseHandler.responseBadRequest("Captcha verification failed, Please try again.");
        }
        MessageResponse authResponse = authService.changePassword(request.getToken(), request.getPassword());
        return ResponseHandler.responseBuilder(authResponse.getMessage(), authResponse.getType());
    }

    @PostMapping("/get-current-user")
    public ResponseEntity<?> getCurrentUser(@RequestBody AccessTokenRequest request) {
        GetCurrentUserByAccessTokenResponse response = authService.getCurrentUserByAccessToken(request.getToken());
        return ResponseHandler.responseOk("Profile retrieved successfully", response);
    }
}
