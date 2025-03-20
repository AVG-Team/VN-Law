package avg.vnlaw.authservice.enums;

import lombok.Getter;
import lombok.Setter;

@Getter
public enum ContentEmailEnum {
    REGISTRATION("Registration Successful",
            "Congratulations on your Successful Registration!!!",
            "Thank you for registering on our platform. Please click the link below to verify your email address."),

    REGISTER_WITH_PASSWORD("Login Successful",
            "Congratulations on your Successful Login!!!",
            "Thank you for logging in with us. Your account has been successfully logged in and is now ready to use. We are delighted to have you on board and look forward to providing you with the best experience. Your Password is: `%s`; Please login now by clicking the button below."),

    FORGOT_PASSWORD("Password Reset Request",
            "Forgot Your Password?",
            "Please click the link below to reset your password.");

    private final String subject;
    private final String title;
    private final String message;

    ContentEmailEnum(String subject, String title, String message) {
        this.subject = subject;
        this.title = title;
        this.message = message;
    }

    public String getMessage(Object... args) {
        return String.format(message, args);
    }
}
