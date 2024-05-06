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
    public ResponseEntity<AuthenticationResponse> register(
            @RequestBody RegisterRequest request
    ){
        if(userRepository.findByEmail(request.getEmail()).isPresent()){
            System.out.println("Email is already registered");
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(authService.register(request));
    }

    @PostMapping("/authenticate")
    public ResponseEntity<AuthenticationResponse> authenticate(
            @RequestBody AuthenticationRequest request
    ){
        return ResponseEntity.ok(authService.authenticate(request));
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
//        User user = userRepository.findByVerificationCode(verificationCode)
//                .orElseThrow(() -> new IllegalStateException("Invalid code"));
//        if(user.isEnabled()){
//            return ResponseEntity.badRequest().body("Account is already activated");
//        }
//        user.setEnabled(true);
//        user.setVerificationCode(verificationCode);
//        userRepository.save(user);

        return ResponseEntity.ok("Account activated successfully");
    }
}
