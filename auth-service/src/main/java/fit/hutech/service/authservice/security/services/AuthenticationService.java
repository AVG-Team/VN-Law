package fit.hutech.service.authservice.security.services;

import com.fasterxml.jackson.databind.ObjectMapper;

import fit.hutech.service.authservice.payloads.request.AuthenticationRequest;
import fit.hutech.service.authservice.payloads.request.ForgotPasswordRequest;
import fit.hutech.service.authservice.payloads.response.AuthenticationResponse;
import fit.hutech.service.authservice.payloads.request.RegisterRequest;
import fit.hutech.service.authservice.enums.Role;
import fit.hutech.service.authservice.enums.TokenType;
import fit.hutech.service.authservice.models.Token;
import fit.hutech.service.authservice.models.User;
import fit.hutech.service.authservice.payloads.response.ForgotPasswordResponse;
import fit.hutech.service.authservice.repositories.TokenRepository;
import fit.hutech.service.authservice.repositories.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthenticationService {
    private final JwtService jwtService;
    private final UserRepository repository;
    private final TokenRepository tokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailSenderService emailSenderService;
    private final AuthenticationManager authenticationManager;

    public AuthenticationResponse register(RegisterRequest request) {
        if (repository.findByEmail(request.getEmail()).isPresent()) {
            return AuthenticationResponse.builder()
                    .message("Email đã được đăng ký")
                    .build();
        }

        var user = User.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER) // or .role(request.getRole())
                .build();
        var savedUser = repository.save(user);
        var jwtToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        saveUserToken(savedUser,jwtToken);

        String verificationCode = UUID.randomUUID().toString();
        user.setVerificationCode(verificationCode);
        user.setEnabled(false);
        repository.save(savedUser);

        Thread emailThread = new Thread(() -> {
            emailSenderService.sendEmailWithToken(savedUser.getEmail(),verificationCode);
        });
        emailThread.start();

        return AuthenticationResponse.builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .message("Đăng ký thành công. Hãy kiểm tra email để kích hoạt tài khoản của bạn.")
                .build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail(),
                        request.getPassword()
                )
        );
        var user = repository.findByEmail(request.getEmail()).orElseThrow();
        if(!user.isEnabled()){
            return AuthenticationResponse.builder()
                    .message("Tài khoản chưa được kích hoạt")
                    .build();
        }

        var jwtToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);

        revokedAllUserTokens(user);
        saveUserToken(user,jwtToken);
        return AuthenticationResponse.builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .message("Đăng nhập thành công")
                .build();
    }
    private void saveUserToken(User user, String jwtToken) {
        var token = Token.builder()
                .user(user)
                .token(jwtToken)
                .tokenType(TokenType.BEARER)
                .expired(false)
                .revoked(false)
                .build();
        tokenRepository.save(token);
    }

    private void revokedAllUserTokens(User user) {
        var validUserTokens = tokenRepository.findAllValidTokenByUser(user.getId());
        if(validUserTokens.isEmpty())
            return;
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }
    public void refreshToken(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if(authHeader == null || !authHeader.startsWith("Bearer")){
            return;
        }
        refreshToken = authHeader.substring(7);
        userEmail = jwtService.extractUsername(refreshToken);
        if(userEmail != null){
            var user = this.repository.findByEmail(userEmail).orElseThrow();
            if (jwtService.isTokenValid(refreshToken,user)){
                var accessToken = jwtService.generateToken(user);
                revokedAllUserTokens(user);
                saveUserToken(user,accessToken);
                var authResponse = AuthenticationResponse.builder()
                        .accessToken(accessToken)
                        .refreshToken(refreshToken)
                        .build();
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }

    public ForgotPasswordResponse forgotPassword(ForgotPasswordRequest request) {
        try {
            User user = repository.findByEmail(request.getEmail())
                    .orElseThrow(
                            () -> new RuntimeException("Email " + request.getEmail() + " chưa được đăng ký")
                    );
            if(!user.isEnabled()){
                throw new RuntimeException("Tài khoản chưa được kích hoạt");
            }

            String resetToken = UUID.randomUUID().toString();
            user.setResetPasswordToken(resetToken);
            repository.save(user);

            Thread emailThread = new Thread(() -> {
                try {
                    emailSenderService.sendSetPasswordEmail(user.getEmail(),resetToken);
                } catch (MessagingException e) {
                    throw new RuntimeException(e);
                }
            });
            emailThread.start();

            return ForgotPasswordResponse
                    .builder()
                    .message("Mã xác thực đã được gửi")
                    .build();
        }catch (Exception e){
            throw e;
        }
    }
    public boolean verifyResetPasswordToken(ForgotPasswordRequest request){
        User user = repository.findByEmail(request.getEmail())
                .orElseThrow(
                        () -> new RuntimeException("User not found with this email: " + request.getResetPasswordToken())
                );
        if (user.getResetPasswordToken() == null) {
            throw new RuntimeException("User has not requested a password reset.");
        }
        if(!request.getResetPasswordToken().equals(user.getResetPasswordToken())){
            throw new RuntimeException("Mã xác thực không hợp lệ");
        }
        return true;
    }
    public ForgotPasswordResponse setPassword(ForgotPasswordRequest request) {
        User user = repository.findByEmail(request.getEmail())
                .orElseThrow(
                        () -> new RuntimeException("User not found with this email: " + request.getEmail())
                );

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        verifyResetPasswordToken(request);
        user.setResetPasswordToken(null);
        repository.save(user);
        return ForgotPasswordResponse
                .builder()
                .message("Thay đổi mật khẩu thành công.")
                .build();
    }
}