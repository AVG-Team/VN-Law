package avg.vnlaw.authservice.dto.responses;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class TokenValidationResponse {
    private boolean valid;
    private String username;
    private String email;
    private String role;
    private List<String> permissions;
    private String permissionLevel; // ADMIN, USER, GUEST
    private List<String> realmRoles;
    private Map<String, List<String>> resourceRoles;
    private boolean canRead;
    private boolean canWrite;
    private boolean canAdmin;
}
