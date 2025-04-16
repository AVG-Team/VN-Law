package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.requests.LoginRequest;
import avg.vnlaw.authservice.requests.RegisterRequest;
import avg.vnlaw.authservice.responses.AuthResponse;
import avg.vnlaw.authservice.services.EmailService;
import avg.vnlaw.authservice.services.JwtService;
import avg.vnlaw.authservice.services.UserService;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.http.javanet.NetHttpTransport;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);
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

    //    Google Mobile :
    @PostMapping("/google-mobile")
    public ResponseEntity<?> googleMobileLogin(@RequestBody Map<String, String> body) {
        String idToken = body.get("token");
        log.info("Received ID token: " + idToken);

        try {
            log.info("Verifying ID token...");
            GoogleIdToken googleIdToken = verifyIdToken(idToken);

            if (googleIdToken != null) {
                log.info("ID token verified successfully.");
                GoogleIdToken.Payload payload = googleIdToken.getPayload();
                String email = payload.getEmail();
                String name = (String) payload.get("name");
                String googleId = payload.getSubject();

                log.info("Email: " + email + ", Name: " + name + ", Google ID: " + googleId);

                User user = userService.findByEmail(email);
                if (user == null) {
                    log.info("User not found. Creating new user...");
                    user = new User();
                    user.setEmail(email);
                    user.setName(name);
                    user.setGoogleId(googleId);
                    userService.registerUser(user);
                    log.info("New user registered: " + email);
                } else {
                    log.info("User found: " + email);
                }

                String role = user.getRole().getName().name();
                String jwtToken = jwtService.generateToken(email, role);
                Map<String, String> responseData = new HashMap<>();
                responseData.put("token", jwtToken);
                responseData.put("name", user.getName()); // Lấy từ User entity
                responseData.put("role", role);
                responseData.put("email", email);
                return ResponseEntity.ok(responseData);
            } else {
                log.warn("Invalid ID token received.");
                return ResponseEntity.status(401).body("Invalid ID token");
            }
        } catch (Exception e) {
            log.error("Error verifying ID token: " + e.getMessage(), e);
            return ResponseEntity.status(500).body("Error verifying ID token: " + e.getMessage());
        }
    }

    private GoogleIdToken verifyIdToken(String idTokenString) throws Exception {
        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance())
                .setAudience(Collections.singletonList("582983299080-q2vslpu7dbdvj9udjdllpot6p8ihr2ge.apps.googleusercontent.com")) //Todo Thay bằng Client ID của bạn
                .build();
        return verifier.verify(idTokenString);
    }
}