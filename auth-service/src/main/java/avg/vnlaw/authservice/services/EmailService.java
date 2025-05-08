package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.enums.ContentEmailEnum;
import avg.vnlaw.authservice.repositories.IdentityClient;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;
import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final Dotenv dotenv = Dotenv.load();
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;
    private final String url = dotenv.get("FRONTEND_URL");
    private final IdentityClient identityClient;
    private final Logger logger = Logger.getLogger(AuthenticationService.class.getName());

    private void themeSendEmail(String email, ContentEmailEnum emailEnum, String name, String url, Object... args) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject(emailEnum.getSubject());

        Context thymeleafContext = new Context();
        thymeleafContext.setVariable("title", emailEnum.getTitle());
        thymeleafContext.setVariable("message", emailEnum.getMessage(args));
        thymeleafContext.setVariable("name", name);
        thymeleafContext.setVariable("url", url);
        thymeleafContext.setVariable("textBtn", "Đăng Kí Ngay");
        thymeleafContext.setVariable("year", String.valueOf(java.time.Year.now().getValue()));
        thymeleafContext.setVariable("signature", dotenv.get("APP_SIGNATURE_EMAIL"));
        String htmlBody = templateEngine.process("mail-template_vi", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    public void sendEmailRegister(String email, String name, String token) throws MessagingException {
        String verifyUrl = this.url + "/thong-bao?token=" + token + "&type=verifyEmailSuccess";
        themeSendEmail(email, ContentEmailEnum.REGISTRATION, name, verifyUrl);
    }

    public void verifyEmail(String userId, String adminToken) throws MessagingException {
        Map<String, Object> userUpdate = new HashMap<>();
        userUpdate.put("emailVerified", true);
        ResponseEntity<?> response = identityClient.updateUser(userId, "Bearer " + adminToken, userUpdate);
    }

    public void sendEmailRegisterKeycloak(String userId, String adminToken) {
        try {
            String[] actions = {"VERIFY_EMAIL"};
            ResponseEntity<?> response = identityClient.executeActionsEmail(userId,
                    "Bearer " + adminToken,
                    actions);
            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("Email verification request sent for user: {}", userId);
            } else {
                log.error("Failed to send email verification for user: {}, status: {}",
                        userId, response.getStatusCode());
            }
        } catch (Exception e) {
            log.error("Error sending email verification for user: {}", userId, e);
        }
    }

    public void sendEmailRegisterWithPassword(String email, String name, String password) throws MessagingException {
        String loginUrl = this.url + "/login";
        themeSendEmail(email, ContentEmailEnum.REGISTER_WITH_PASSWORD, name, loginUrl, password);
    }

    public void sendEmailForgotPassword(String email, String name, String token) throws MessagingException {
        String resetUrl = this.url + "/quen-mat-khau?token=" + token + "&type=doi-mat-khau";
        themeSendEmail(email, ContentEmailEnum.FORGOT_PASSWORD, name, resetUrl);
    }
}
