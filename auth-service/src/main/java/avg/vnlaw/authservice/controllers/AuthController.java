package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.requests.LoginRequest;
import avg.vnlaw.authservice.requests.RegisterRequest;
import avg.vnlaw.authservice.responses.AuthResponse;
import avg.vnlaw.authservice.services.EmailService;
import avg.vnlaw.authservice.services.JwtService;
import avg.vnlaw.authservice.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;
    private final JwtService jwtService;
    private final EmailService emailService;
    private final AuthenticationManager authenticationManager;

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        User user = userService.registerUser(request.getEmail(), request.getPassword(), "USER");
        emailService.sendVerificationEmail(user.getEmail());
        return ResponseEntity.ok("Verification code sent to " + user.getEmail());
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );
        User user = userService.findByEmail(request.getEmail());
        String token = jwtService.generateToken(user.getEmail(), user.getRole().getName().name());
        return ResponseEntity.ok(new AuthResponse(token));
    }

    @GetMapping("/verify-email")
    public ResponseEntity<?> verifyEmail(@RequestParam String email, @RequestParam String code) {
        boolean verified = emailService.verifyEmail(email, code);
        if (verified) {
            userService.verifyUserEmail(email);
            return ResponseEntity.ok("Email verified successfully");
        }
        return ResponseEntity.badRequest().body("Invalid verification code");
    }
}