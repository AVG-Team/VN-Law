package fit.hutech.service.authservice.controller;

import fit.hutech.service.authservice.models.User;
import fit.hutech.service.authservice.payloads.request.AuthenticationRequest;
import fit.hutech.service.authservice.payloads.response.AuthenticationResponse;
import fit.hutech.service.authservice.payloads.request.RegisterRequest;
import fit.hutech.service.authservice.repositories.TokenRepository;
import fit.hutech.service.authservice.repositories.UserRepository;
import fit.hutech.service.authservice.security.services.AuthenticationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("api/auth")
@RequiredArgsConstructor
public class AuthenticationController {

    private final AuthenticationService authService;
    private final UserRepository userRepository;
    @PostMapping("/register")
    public ResponseEntity<?> register(
            @RequestBody RegisterRequest request
    ) {
        try {
            AuthenticationResponse authResponse = authService.register(request);
            if (authResponse.getMessage().equals("Email is already registered")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(authResponse.getMessage());
            }
            return ResponseEntity.ok(authResponse);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Registration failed");
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(
            @RequestBody AuthenticationRequest request
    ) {
        try {
            AuthenticationResponse authResponse = authService.authenticate(request);
            if (authResponse.getMessage().equals("Account has not been activated")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(authResponse.getMessage());
            }
            return ResponseEntity.ok(authResponse);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Login failed");
        }
    }

    @PostMapping("/refresh-token")
    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException{
        authService.refreshToken(request,response);
    }

    @GetMapping("/confirm")
    public ResponseEntity<String> confirmAccount(
            @RequestParam("verificationCode")
            String verificationCode
    ){
        User user = userRepository.findByVerificationCode(verificationCode)
                .orElseThrow(() -> new IllegalStateException("Invalid code"));
        if(user.isEnabled()){
            return ResponseEntity.badRequest().body("Account is already activated");
        }
        user.setEnabled(true);
        user.setVerificationCode(verificationCode);
        userRepository.save(user);

        return ResponseEntity.ok("Account activated successfully");
    }
}
