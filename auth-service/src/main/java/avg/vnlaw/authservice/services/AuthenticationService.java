package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.requests.AuthenticationRequest;
import avg.vnlaw.authservice.requests.RegisterRequest;
import avg.vnlaw.authservice.responses.AuthenticationResponse;
import avg.vnlaw.authservice.responses.GetCurrentUserByAccessTokenResponse;
import avg.vnlaw.authservice.responses.MessageResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

public interface AuthenticationService {
    AuthenticationResponse register(RegisterRequest request);
    AuthenticationResponse authenticate(AuthenticationRequest request);
    void refreshToken(HttpServletRequest request, HttpServletResponse response) throws IOException, NoSuchAlgorithmException;
    MessageResponse confirm(String token);
    GetCurrentUserByAccessTokenResponse getCurrentUserByAccessToken(String token);
    MessageResponse forgotPassword(String email);
    MessageResponse changePassword(String token, String password);
}
