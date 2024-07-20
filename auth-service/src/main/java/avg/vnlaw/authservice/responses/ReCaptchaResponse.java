package avg.vnlaw.authservice.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ReCaptchaResponse {
    @JsonProperty("score")
    private float score;
    private boolean action;
    @JsonProperty("challenge_ts")
    private String challengeTs;
    private String hostname;
    @JsonProperty("error-codes")
    private String errorCodes;
    @JsonProperty("type")
    private boolean success;
}
