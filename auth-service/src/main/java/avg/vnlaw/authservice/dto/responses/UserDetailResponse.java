package avg.vnlaw.authservice.dto.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
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
public class UserDetailResponse {
    @JsonProperty("id")
    private String id;

    @JsonProperty("createdTimestamp")
    private Long createdTimestamp;

    @JsonProperty("username")
    private String username;

    @JsonProperty("enabled")
    private Boolean enabled;

    @JsonProperty("totp")
    private Boolean totp;

    @JsonProperty("emailVerified")
    private Boolean emailVerified;

    @JsonProperty("firstName")
    private String firstName;

    @JsonProperty("lastName")
    private String lastName;

    @JsonProperty("email")
    private String email;

    @JsonProperty("disableableCredentialTypes")
    private List<String> disableableCredentialTypes;

    @JsonProperty("requiredActions")
    private List<String> requiredActions;

    @JsonProperty("federatedIdentities")
    private List<Object> federatedIdentities;

    @JsonProperty("notBefore")
    private Integer notBefore;

    @JsonProperty("access")
    private Map<String, Boolean> access;
}