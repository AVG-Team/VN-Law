package fit.hutech.service.authservice.controller;

import fit.hutech.service.authservice.models.User;
import fit.hutech.service.authservice.payloads.request.AuthenticationRequest;
//import fit.hutech.service.authservice.payloads.request.ForgotPasswordRequest;
import fit.hutech.service.authservice.payloads.request.ForgotPasswordRequest;
import fit.hutech.service.authservice.payloads.response.AuthenticationResponse;
import fit.hutech.service.authservice.payloads.request.RegisterRequest;
import fit.hutech.service.authservice.payloads.response.ForgotPasswordResponse;
import fit.hutech.service.authservice.repositories.TokenRepository;
import fit.hutech.service.authservice.repositories.UserRepository;
import fit.hutech.service.authservice.security.services.AuthenticationService;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.UUID;

@RestController
@RequestMapping("/auth-service/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class AuthenticationController {

    private final AuthenticationService authService;
    private final UserRepository userRepository;
    @PostMapping("/register")
    public ResponseEntity<?> register(
            @RequestBody RegisterRequest request
    ) {
            AuthenticationResponse authResponse = authService.register(request);
            if (authResponse.getMessage().equals("Email đã được đăng ký")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(authResponse.getMessage());
            }
            return ResponseEntity.ok(authResponse);
    }

    @PostMapping("/authenticate")
    public ResponseEntity<?> authenticate(
            @RequestBody AuthenticationRequest request
    ) {
        try {
            AuthenticationResponse authResponse = authService.authenticate(request);
            if (authResponse.getMessage().equals("Tài khoản chưa được kích hoạt")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(authResponse.getMessage());
            }
            return ResponseEntity.ok(authResponse);
        } catch (DisabledException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Tài khoản chưa được kích hoạt");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body("Tài khoản hoặc mật khẩu không đúng");
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
        try{
            User user = userRepository.findByVerificationCode(verificationCode)
                    .orElseThrow(() -> new IllegalStateException("Tài khoản đã được kích hoạt hoặc chưa được đăng ký"));

            System.out.printf("hehe %s", user.getEmail());
            user.setEnabled(true);
            user.setVerificationCode(null);
            userRepository.save(user);

            return ResponseEntity.ok("Tài khoản được kích hoạt thành công");
        }catch (Exception ex){
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ex.getMessage());
        }
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@RequestBody ForgotPasswordRequest request) {
        try {
            ForgotPasswordResponse response = authService.forgotPassword(request);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ForgotPasswordResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ForgotPasswordResponse(e.getMessage()));
        }
    }

    @PostMapping("/verify-token")
    public ResponseEntity<?> verifyToken(@RequestBody ForgotPasswordRequest request){
        try{
            boolean isValid = authService.verifyResetPasswordToken(request);
            if(isValid){
                return ResponseEntity.ok("Xác thực thành công");
            }
            else {
                return ResponseEntity.badRequest().body("Mã xác thực không hợp lệ");
            }
        }catch (RuntimeException e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

    @PostMapping("/set-new-password")
    public ResponseEntity<?> setNewPassword(@RequestBody ForgotPasswordRequest request) {
        try {
//            return ResponseEntity.status(HttpStatus.OK).body(authService.setPassword(request));
            ForgotPasswordResponse response = authService.setPassword(request);
            return ResponseEntity.status(HttpStatus.OK).body(response);
        }catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ForgotPasswordResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @GetMapping("/test")
    public String test(){
        return "Hello";
    }


}
