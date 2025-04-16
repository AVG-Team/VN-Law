package avg.vnlaw.authservice.config.securiy;

import avg.vnlaw.authservice.config.securiy.JwtAuthenticationFilter;
import avg.vnlaw.authservice.o2auth.services.CustomOAuth2User;
import avg.vnlaw.authservice.o2auth.services.OAuth2Service;
import avg.vnlaw.authservice.services.JwtService;
import avg.vnlaw.authservice.services.LogoutService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.web.HttpSessionOAuth2AuthorizationRequestRepository;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;

import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private static final Logger logger = LoggerFactory.getLogger(SecurityConfig.class);

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final AuthenticationProvider authenticationProvider;
    private final LogoutService logoutService;
    private final OAuth2Service oAuth2Service;
    private final JwtService jwtService;

    private static final String[] WHITE_LIST_URL = {
            "/api/auth/register",
            "/api/auth/login",
            "/api/auth/verify-email",
            "/api/auth/logout",
            "/api/auth/forgot-password",
            "/api/auth/reset-password",
            "/api/auth/google-mobile",
            "test",
            "/oauth2/**",
            "/swagger-ui/**",
            "/v3/api-docs/**"
    };

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
//                .cors(cors -> cors.configurationSource(request -> new org.springframework.web.cors.CorsConfiguration().applyPermitDefaultValues()))
                .cors(cors -> cors.configurationSource(request -> {
                    CorsConfiguration config = new CorsConfiguration();
                    config.setAllowedOrigins(List.of("*")); // Cho phép tất cả các nguồn gốc
                    config.setAllowedMethods(List.of("*")); // Cho phép tất cả các phương thức
                    config.setAllowedHeaders(List.of("*")); // Cho phép tất cả các tiêu đề
                    config.setAllowCredentials(true); // Cho phép thông tin xác thực
                    return config;
                }))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(WHITE_LIST_URL).permitAll()
                        .requestMatchers("/api/admin/**").hasRole("ADMIN")
                        .requestMatchers("/api/superuser/**").hasRole("SUPER_USER")
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                .logout(logout -> logout
                        .logoutUrl("/api/auth/logout")
                        .addLogoutHandler(logoutService)
                        .logoutSuccessHandler((req, res, auth) -> res.setStatus(200))
                )
                .oauth2Login(oauth2 -> oauth2
                        .authorizationEndpoint(auth -> auth
                                .authorizationRequestRepository(new HttpSessionOAuth2AuthorizationRequestRepository())
                                .baseUri("/oauth2/authorize")
                        )
                        .redirectionEndpoint(redir -> redir
                                .baseUri("/oauth2/callback/*")
                        )
                        .userInfoEndpoint(userInfo -> userInfo.userService(oAuth2Service))
                        .successHandler((req, res, auth) -> {
                            logger.info("OAuth2 login successful, processing user: {}", auth.getPrincipal());
                            CustomOAuth2User oAuth2User = (CustomOAuth2User) auth.getPrincipal();
                            String email = oAuth2User.getName();
                            String role = oAuth2User.getAuthorities().iterator().next().getAuthority().replace("ROLE_", "");
                            String token = jwtService.generateToken(email, role);

                            // Kiểm tra loại client từ query parameter hoặc header
                            String clientType = req.getParameter("client_type"); // Ví dụ: ?client_type=web hoặc ?client_type=mobile
                            if (clientType == null) {
                                clientType = req.getHeader("X-Client-Type"); // Hoặc dùng header
                            }

                            if ("mobile".equals(clientType)) {
                                // Trả về JSON cho Flutter (mobile)
                                res.setContentType("application/json");
                                res.getWriter().write("{\"token\": \"" + token + "\"}");
                                res.setStatus(200);
                            } else {
                                // Redirect cho ReactJS (web), mặc định nếu không có client_type
                                String redirectUrl = "http://localhost:5173/oauth2/callback?token=" + token;
                                logger.info("Redirecting to: {}", redirectUrl);
                                res.sendRedirect(redirectUrl);
                            }
                        })
                        .failureHandler((req, res, exception) -> {
                            logger.error("OAuth2 login failed: {}", exception.getMessage());
                            res.sendError(HttpServletResponse.SC_UNAUTHORIZED, "OAuth2 Authentication Failed");
                        })
                );

        return http.build();
    }
}