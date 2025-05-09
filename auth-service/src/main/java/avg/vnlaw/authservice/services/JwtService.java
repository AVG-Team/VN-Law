package avg.vnlaw.authservice.services;

import io.github.cdimascio.dotenv.Dotenv;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Service
public class JwtService {

    Dotenv dotenv = Dotenv.load();
    private final String JWT_SECRET = dotenv.get("JWT_SECRET");
    private final long JWT_EXPIRATION = 24 * 60 * 60 * 1000;

    public String extractUsername(String token){
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver){
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    public String generateToken(UserDetails userDetails){
        return generateToken(new HashMap<>(), userDetails);
    }

    public String generateToken(UserDetails userDetails, boolean rememberMe){
        return generateToken(new HashMap<>(), userDetails, rememberMe);
    }

    public String generateToken(
            Map<String, Object> extraClaims,
            UserDetails userDetails
    ){
        return buildToken(extraClaims, userDetails, JWT_EXPIRATION);
    }

    public String generateToken(
            Map<String, Object> extraClaims,
            UserDetails userDetails, boolean rememberMe
    ){
        if (rememberMe) {
            return buildToken(extraClaims, userDetails, JWT_EXPIRATION * 7);
        }
        return buildToken(extraClaims, userDetails, JWT_EXPIRATION);
    }

    public String generateRefreshToken(
            UserDetails userDetails
    ){
        long JWT_REFRESH_EXPIRATION = 30L * 24 * 60 * 60 * 1000;
        return buildToken(new HashMap<>(), userDetails, JWT_REFRESH_EXPIRATION);
    }

    private String buildToken(
            Map<String, Object> extraClaims,
            UserDetails userDetails,
            long expiration
    ){
        return Jwts
                .builder()
                .setClaims(extraClaims)
                .setSubject(userDetails.getUsername())
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSignInKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public boolean isTokenValid(String token, UserDetails userDetails){
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token){
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token){
        return extractClaim(token, Claims::getExpiration);
    }

    private Claims extractAllClaims(String token){
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private static String toHex(byte[] bytes) {
        StringBuilder hexString = new StringBuilder();
        for (byte b : bytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }

    private static String sha256Hex(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
        return toHex(hash);
    }

    private static String hexToHex(String input) throws NoSuchAlgorithmException {
        String md5Hex = sha256Hex(input);
        StringBuilder hexBuilder = new StringBuilder();
        for (char c : md5Hex.toCharArray()) {
            hexBuilder.append(Integer.toHexString(c));
        }
        return hexBuilder.toString();
    }

    private Key getSignInKey(){
        try {
            String key = hexToHex(JWT_SECRET);
            byte[] keyBytes = Decoders.BASE64.decode(key);
            return Keys.hmacShaKeyFor(keyBytes);
        } catch (NoSuchAlgorithmException e) {
            return null;
        }
    }
}