package fit.hutech.service.lawservice.config.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.ArrayList;
import java.util.Arrays;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final AuthorizationFilterChain  authorizationFilterChain;
    private final UserDetailService userDetailService;
    private final AuthenticationConfiguration authenticationConfiguration;

    @Value("${app.cors.allowed-domain}")
    private String allowDomain;

    @Bean
    public CorsConfigurationSource corsConfigurationSource(){
        ArrayList<String> allowDomains = new ArrayList<>();
        allowDomains.add(allowDomain);
        CorsConfiguration corsConfiguration = new CorsConfiguration();
        corsConfiguration.setAllowedOrigins(allowDomains);
        corsConfiguration.addAllowedMethod(Arrays.asList("GET","POST","PUT","PATCH","DELETE","OPTIONS").toString());
        corsConfiguration.addAllowedHeader("*");
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**",corsConfiguration);
        return source;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
        return httpSecurity
                .cors(httpSecurityCorsConfigurer ->
                        httpSecurityCorsConfigurer.configurationSource(corsConfigurationSource()))
                .csrf(AbstractHttpConfigurer::disable) // Temporarily :))
                .authorizeHttpRequests(
                        requests->
                                requests
                                        .requestMatchers("/","/law-service/auth/**", "/swagger-ui/**", "/law-service/**").permitAll()
                                        .requestMatchers(new AntPathRequestMatcher("/law/api/v1/user/**")).hasAnyAuthority("USER", "ADMIN")
                                        .requestMatchers(new AntPathRequestMatcher("/law/api/v1/admin/**")).hasAuthority("ADMIN")
                                        .anyRequest().authenticated()
                )
                .userDetailsService(userDetailService)
                .authenticationManager(authenticationManager(authenticationConfiguration))
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(authorizationFilterChain, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }
    @Bean
    AuthenticationProvider authenticationProvider(){
        DaoAuthenticationProvider authenticationProvider = new DaoAuthenticationProvider();
        authenticationProvider.setPasswordEncoder(new BCryptPasswordEncoder());
        authenticationProvider.setUserDetailsService(userDetailService);
        return authenticationProvider;
    }
    @Bean
    BCryptPasswordEncoder bCryptPasswordEncoder(){
        return new BCryptPasswordEncoder();
    }
}
