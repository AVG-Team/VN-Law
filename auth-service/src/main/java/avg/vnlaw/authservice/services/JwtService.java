package avg.vnlaw.authservice.services;

public interface JwtService {
    String generateToken(String email, String role);
    String getEmailFromToken(String token);
    boolean validateToken(String token);
    String generateRandomPassword();
}