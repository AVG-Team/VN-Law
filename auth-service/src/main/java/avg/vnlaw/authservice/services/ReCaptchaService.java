package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.responses.ReCaptchaResponse;

public interface ReCaptchaService {
    ReCaptchaResponse verify(String response);
}
