package avg.vnlaw.authservice.services;

import avg.vnlaw.authservice.dto.responses.MessageResponse;
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {
    private final Dotenv dotenv = Dotenv.load();
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;
    private final String url = dotenv.get("FRONTEND_URL");
    private final IdentityClient identityClient;

    private void themeSendEmail(String email, ContentEmailEnum emailEnum, String name, String url, String textBtn, Object... args) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject(emailEnum.getSubject());

        Context thymeleafContext = new Context();
        thymeleafContext.setVariable("title", emailEnum.getTitle());
        thymeleafContext.setVariable("message", emailEnum.getMessage(args));
        thymeleafContext.setVariable("name", name);
        thymeleafContext.setVariable("url", url);
        thymeleafContext.setVariable("textBtn", textBtn);
        thymeleafContext.setVariable("year", String.valueOf(java.time.Year.now().getValue()));
        thymeleafContext.setVariable("signature", dotenv.get("APP_SIGNATURE_EMAIL"));
        String htmlBody = templateEngine.process("mail-template_vi", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    public void sendEmailRegister(String email, String name, String token) throws MessagingException {
        String verifyUrl = this.url + "/confirm?token=" + token + "&type=verify-email-success";
        themeSendEmail(email, ContentEmailEnum.REGISTRATION, name, verifyUrl, "Đăng ký tài khoản");
    }

    public MessageResponse verifyEmail(String userId, String adminToken) throws MessagingException {
        try {
            // Lấy thông tin người dùng hiện tại
            ResponseEntity<Map<String, Object>> userResponse = identityClient.getUserByUserId(userId, "Bearer " + adminToken);

            if (userResponse.getStatusCode().is2xxSuccessful()) {
                Map<String, Object> user = userResponse.getBody();
                if (user == null) {
                    log.error("User data is null for userId: {}", userId);
                    throw new MessagingException("User data is null for userId: " + userId);
                }

                // Safely handle requiredActions
                Object requiredActionsObj = user.get("requiredActions");
                List<String> requiredActions;

                if (requiredActionsObj instanceof List) {
                    requiredActions = (List<String>) requiredActionsObj;
                } else {
                    requiredActions = new ArrayList<>();
                }

                // Chuẩn bị dữ liệu cập nhật
                Map<String, Object> userUpdate = new HashMap<>();
                userUpdate.put("emailVerified", true);

                if (requiredActions.contains("VERIFY_EMAIL")) {
                    requiredActions.remove("VERIFY_EMAIL");
                    userUpdate.put("requiredActions", requiredActions);
                } else {
                    userUpdate.put("requiredActions", new ArrayList<>());
                }

                // Cập nhật thông tin người dùng
                ResponseEntity<?> updateResponse = identityClient.updateUser(userId, "Bearer " + adminToken, userUpdate);
                if (updateResponse.getStatusCode().is2xxSuccessful()) {
                    log.info("Email verified and required action removed for user: {}", userId);
                    return MessageResponse.builder()
                            .message("Email verified successfully")
                            .build();
                } else {
                    log.error("Failed to update user: {}, status: {}", userId, updateResponse.getStatusCode());
                    throw new MessagingException("Failed to update user: " + userId);
                }
            } else {
                log.error("Failed to get user: {}, status: {}", userId, userResponse.getStatusCode());
                throw new MessagingException("Failed to get user: " + userId);
            }
        } catch (Exception e) {
            log.error("Error verifying email for user: {}", userId, e);
            throw new MessagingException("Error verifying email for user: " + userId, e);
        }
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
        String resetUrl = this.url + "/forgot-password?token=" + token + "&type=change-password";
        themeSendEmail(email, ContentEmailEnum.FORGOT_PASSWORD, name, resetUrl, "Đặt lại mật khẩu");
    }
}
