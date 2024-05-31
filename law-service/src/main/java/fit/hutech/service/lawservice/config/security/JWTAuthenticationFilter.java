package fit.hutech.service.lawservice.config.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class JWTAuthenticationFilter extends OncePerRequestFilter {


    private final String jwtSecret= "404E635266556A586E3272357538782F413F4428472B4B6250645367566B5970";
    private final UserDetailsService userDetailsService;

    public JWTAuthenticationFilter() {
        this.userDetailsService = null;
    }
    public JWTAuthenticationFilter(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String jwt = getJWTFromRequest(request);

        if(StringUtils.hasText(jwt) && validateJWT(jwt)){
            String username = getUsernameFromJWT(jwt);
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            if(userDetails != null){
                UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(userDetails,null,userDetails.getAuthorities());
                authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        }
        filterChain.doFilter(request,response);
    }

    private String getJWTFromRequest(HttpServletRequest request){
        String bearerToken = request.getHeader("Authorization");
        if(bearerToken != null && bearerToken.startsWith("Bearer ")){
            return bearerToken.substring(7);
        }
        return null;
    }

    private String getUsernameFromJWT(String jwt){
        Claims claims = Jwts.parser()
                .setSigningKey(jwtSecret)
                .parseClaimsJws(jwt)
                .getBody();

        return claims.getSubject();

    }

    private boolean validateJWT(String jwt){
        try{
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(jwt);
            return true;
        }catch (Exception e){
            throw new RuntimeException("Invalid JWT token");
        }
    }
}
