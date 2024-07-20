package avg.vnlaw.authservice.services;


import avg.vnlaw.authservice.entities.User;

public interface TokenService {
    void revokedAllUserTokens(User user);
    void saveUserToken(User user, String jwtToken);
    User getUserByToken(String token);
}
