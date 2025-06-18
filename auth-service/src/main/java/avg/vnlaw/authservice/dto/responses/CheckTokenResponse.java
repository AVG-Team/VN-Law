package avg.vnlaw.authservice.dto.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import java.util.List;
import java.util.Map;

@Data
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategy.SnakeCaseStrategy.class)
public class CheckTokenResponse {
        private boolean active;
        private Long exp;
        private Long iat;
        private String jti;
        private String iss;
        private Object aud;
        private String sub;
        private String typ;
        private String azp;
        private String session_state;
        private String name;
        private String given_name;
        private String family_name;
        private String preferred_username;
        private String email;
        private Boolean email_verified;
        private String acr;
        private String sid;
        private String username;
        private String client_id;
        private String scope;
        @JsonProperty("allowed-origins")
        private List<String> allowedOrigins;
        private RealmAccess realm_access;
        private Map<String, ResourceAccess> resource_access;
        // Inner classes cho phân quyền
        @Data
        @NoArgsConstructor
        @AllArgsConstructor
        public static class RealmAccess {
                private List<String> roles;
        }

        @Data
        @NoArgsConstructor
        @AllArgsConstructor
        public static class ResourceAccess {
                private List<String> roles;
        }

        // HELPER METHODS để lấy roles dễ dàng
        public List<String> getRealmRoles() {
                return realm_access != null ? realm_access.getRoles() : List.of();
        }

        public List<String> getResourceRoles(String clientId) {
                if (resource_access != null && resource_access.containsKey(clientId)) {
                        return resource_access.get(clientId).getRoles();
                }
                return List.of();
        }

        public boolean hasRealmRole(String role) {
                return getRealmRoles().contains(role);
        }

        public boolean hasResourceRole(String clientId, String role) {
                return getResourceRoles(clientId).contains(role);
        }
}
