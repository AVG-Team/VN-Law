package avg.vnlaw.authservice.config.securiy;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;

import java.io.IOException;

public class ApiKeyAuthFilter extends AbstractPreAuthenticatedProcessingFilter {

    private final String headerName;

    public ApiKeyAuthFilter(String headerName) {
        this.headerName = headerName;
    }

    @Override
    protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
        return request.getHeader(headerName);
    }

    @Override
    protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
        return "N/A";
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        super.doFilter(request, response, chain);
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, Authentication authResult) throws IOException, ServletException {
        super.successfulAuthentication(request, response, authResult);
    }

    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request, HttpServletResponse response,
                                              AuthenticationException failed) throws IOException, ServletException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");

        String errorMessage = "{\"error\": \"" + failed.getMessage() + "\"}";
        response.getWriter().write(errorMessage);
        response.getWriter().flush();
        response.getWriter().close();
        System.out.println("Failed authentication: " + failed.getMessage());
    }

    @Override
    protected boolean principalChanged(HttpServletRequest request, Authentication currentAuthentication) {
        Object principal = getPreAuthenticatedPrincipal(request);
        return principal == null || !principal.equals(currentAuthentication.getPrincipal());
    }
}

