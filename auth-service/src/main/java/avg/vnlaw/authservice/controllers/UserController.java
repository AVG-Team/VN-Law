package avg.vnlaw.authservice.controllers;

import avg.vnlaw.authservice.entities.CustomUserDetail;
import avg.vnlaw.authservice.entities.User;
import avg.vnlaw.authservice.o2auth.services.OAuth2Service;
import avg.vnlaw.authservice.services.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private static final Logger logger = LoggerFactory.getLogger(OAuth2Service.class);

    @Operation(summary = "Get current user information")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User found successfully"),
            @ApiResponse(responseCode = "401", description = "User not authenticated"),
            @ApiResponse(responseCode = "404", description = "User not found"),
            @ApiResponse(responseCode = "500", description = "Internal server error")
    })
    @PreAuthorize("isAuthenticated()")
    @GetMapping("/get-current-user")
    public ResponseEntity<User> getCurrentUser(@AuthenticationPrincipal CustomUserDetail userDetail) {
        if (userDetail == null) {
            logger.error("No authenticated user found");
            return ResponseEntity.status(401).body(null); // Trả về 401 Unauthorized nếu userDetail null
        }
        logger.info("Getting current user {}", userDetail);
        User user = userService.findByEmail(userDetail.getUsername());
        logger.info("User found {}, Email checked data {}", user, userDetail.getUsername());
        return ResponseEntity.ok(user);
    }
}