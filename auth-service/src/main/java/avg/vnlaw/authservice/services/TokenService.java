package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.entities.Token;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.repositories.TokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class TokenService {

    private final TokenRepository tokenRepository;

    public void saveUserToken(User user, String jwtToken) {
        var token = Token.builder()
                .user(user)
                .token(jwtToken)
                .expired(false)
                .revoked(false)
                .build();
        tokenRepository.save(token);
    }

    
    public void revokedAllUserTokens(User user) {
        var validUserTokens = tokenRepository.findAllValidTokenByUser(user.getId());
        if(validUserTokens.isEmpty()) return;

        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }

    
    public User getUserByToken(String token) {
        return tokenRepository.findByToken(token)
                .map(Token::getUser)
                .orElse(null);
    }
}
