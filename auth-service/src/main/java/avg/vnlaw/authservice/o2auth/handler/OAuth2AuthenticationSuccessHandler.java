package avg.vnlaw.authservice.o2auth.handler;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.o2auth.HttpCookieOAuth2AuthorizationRequestRepository;
import avg.vnlaw.authservice.o2auth.utils.CookieUtils;
import avg.vnlaw.authservice.services.JwtService;
import avg.vnlaw.authservice.services.TokenService;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.coyote.BadRequestException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;
import java.net.URI;
import java.util.Optional;

import static avg.vnlaw.authservice.o2auth.HttpCookieOAuth2AuthorizationRequestRepository.REDIRECT_URI_PARAM_COOKIE_NAME;

@Component
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final JwtService jwtService;
    private final HttpCookieOAuth2AuthorizationRequestRepository httpCookieOAuth2AuthorizationRequestRepository;
    private final TokenService tokenService;

    @Autowired
    public OAuth2AuthenticationSuccessHandler(JwtService jwtService,
                                              HttpCookieOAuth2AuthorizationRequestRepository httpCookieOAuth2AuthorizationRequestRepository, TokenService tokenService) {
        this.jwtService = jwtService;
        this.httpCookieOAuth2AuthorizationRequestRepository = httpCookieOAuth2AuthorizationRequestRepository;
        this.tokenService = tokenService;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        String targetUrl = determineTargetUrl(request, response, authentication);

        if (response.isCommitted()) {
            logger.debug("Response has already been committed. Unable to redirect to " + targetUrl);
            return;
        }

        clearAuthenticationAttributes(request, response);
        getRedirectStrategy().sendRedirect(request, response, targetUrl);
    }

    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        Optional<String> redirectUri = CookieUtils.getCookie(request, REDIRECT_URI_PARAM_COOKIE_NAME)
                .map(Cookie::getValue);

        if(redirectUri.isPresent() && !isAuthorizedRedirectUri(redirectUri.get())) {
            try {
                throw new BadRequestException("Sorry! We've got an Unauthorized Redirect URI and can't proceed with the authentication");
            } catch (BadRequestException e) {
                throw new RuntimeException(e);
            }
        }

        String targetUrl = redirectUri.orElse(getDefaultTargetUrl());

        CustomUserDetail customUserDetail = (CustomUserDetail) authentication.getPrincipal();
        User user = customUserDetail.getUser();

        var jwtToken = jwtService.generateToken(customUserDetail, true);
        var refreshToken = jwtService.generateRefreshToken(customUserDetail);

        tokenService.revokedAllUserTokens(user);
        tokenService.saveUserToken(user,jwtToken);

        return UriComponentsBuilder.fromUriString(targetUrl)
                .queryParam("token", jwtToken)
                .build().toUriString();
    }

    protected void clearAuthenticationAttributes(HttpServletRequest request, HttpServletResponse response) {
        super.clearAuthenticationAttributes(request);
        httpCookieOAuth2AuthorizationRequestRepository.removeAuthorizationRequestCookies(request, response);
    }

    private boolean isAuthorizedRedirectUri(String uri) {
        Dotenv dotenv = Dotenv.load();
        String AUTHORIZED_REDIRECT_URI = dotenv.get("AUTHORIZED_REDIRECT_URI");
        URI clientRedirectUri = URI.create(uri);

        URI authorizedURI = URI.create(AUTHORIZED_REDIRECT_URI);
        return authorizedURI.getHost().equalsIgnoreCase(clientRedirectUri.getHost())
                && authorizedURI.getPort() == clientRedirectUri.getPort();
    }
}