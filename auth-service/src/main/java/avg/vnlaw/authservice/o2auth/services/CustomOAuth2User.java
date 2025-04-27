package avg.vnlaw.authservice.o2auth.services;


import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Map;

// Class hỗ trợ để lưu thông tin OAuth2User
public class CustomOAuth2User implements OAuth2User {
    private final String email;
    private final String role;
    private final Map<String, Object> attributes;

    public CustomOAuth2User(String email, String role, Map<String, Object> attributes) {
        this.email = email;
        this.role = role;
        this.attributes = attributes;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return attributes;
    }

    @Override
    public java.util.Collection<? extends org.springframework.security.core.GrantedAuthority> getAuthorities() {
        return java.util.Collections.singletonList(
                new org.springframework.security.core.authority.SimpleGrantedAuthority("ROLE_" + role)
        );
    }

    @Override
    public String getName() {
        return email;
    }
}
