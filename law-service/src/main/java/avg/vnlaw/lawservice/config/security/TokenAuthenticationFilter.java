package avg.vnlaw.lawservice.config.security;

import avg.vnlaw.lawservice.dto.response.TokenValidationResponse;
import avg.vnlaw.lawservice.services.AuthServiceClient;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
@Slf4j
public class TokenAuthenticationFilter extends OncePerRequestFilter {

    private final AuthServiceClient authServiceClient;
    private final List<String> publicPaths = new ArrayList<>();

    // Đảm bảo constructor được khai báo công khai
    public TokenAuthenticationFilter(AuthServiceClient authServiceClient) {
        this.authServiceClient = authServiceClient;

        // Danh sách các đường dẫn không cần xác thực
        publicPaths.add("/api/auth/google-token");
        publicPaths.add("/api/auth/");
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getRequestURI();

        for (String publicPath : publicPaths) {
            if (path.startsWith(publicPath)) {
                return true;
            }
        }

        return false;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        String token = authHeader.substring(7);

        try {
            TokenValidationResponse validationResponse = authServiceClient.validateToken(token);

            if (validationResponse != null && validationResponse.isActive()) {
                List<SimpleGrantedAuthority> authorities = extractAuthorities(validationResponse);
                log.info("Extracted authorities: {}", authorities);

                UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                        validationResponse.getPreferred_username(),
                        null,
                        authorities
                );

                SecurityContextHolder.getContext().setAuthentication(authentication);
                log.info("User authenticated: {}", validationResponse.getPreferred_username());
            }

        } catch (Exception e) {
            log.error("Failed to validate token: {}", e.getMessage());
            SecurityContextHolder.clearContext();
        }

        filterChain.doFilter(request, response);
    }

    private List<SimpleGrantedAuthority> extractAuthorities(TokenValidationResponse response) {
        log.info("Extracting authorities from token validation response : {}", response);
        Set<String> uniqueRoles = new LinkedHashSet<>();

        if (response.getRealm_access() != null && response.getRealm_access().getRoles() != null) {
            uniqueRoles.addAll(response.getRealm_access().getRoles());
        }

        if (response.getResource_access() != null) {
            response.getResource_access().forEach((key, value) -> {
                if (value != null && value.getRoles() != null) {
                    uniqueRoles.addAll(value.getRoles());
                }
            });
        }

        log.debug("Unique roles extracted: {}", uniqueRoles);

        // Chuyển đổi tên role để phù hợp với @PreAuthorize
        // Giữ nguyên tên gốc của role để đảm bảo khớp với @PreAuthorize
        List<SimpleGrantedAuthority> authorities = uniqueRoles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role))
                .collect(Collectors.toList());

        // Thêm các phiên bản chuyển đổi khác của role để hỗ trợ các định dạng khác nhau
        List<SimpleGrantedAuthority> additionalAuthorities = uniqueRoles.stream()
                .map(role -> new SimpleGrantedAuthority("ROLE_" + role.toUpperCase().replace("-", "_")))
                .toList();

        authorities.addAll(additionalAuthorities);

        // Loại bỏ trùng lặp trong authorities (nếu có)
        return authorities.stream()
                .distinct()
                .collect(Collectors.toList());
    }
}
