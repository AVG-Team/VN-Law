package avg.vnlaw.authservice.services.impl;

import avg.vnlaw.authservice.enums.ContentEmailEnum;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final Dotenv dotenv = Dotenv.load();
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;
    private final String url = dotenv.get("FRONTEND_URL");

    private void themeSendEmail(String email, ContentEmailEnum emailEnum, String url, Object... args) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject(emailEnum.getSubject());

        Context thymeleafContext = new Context();
        thymeleafContext.setVariable("title", emailEnum.getTitle());
        thymeleafContext.setVariable("message", emailEnum.getMessage(args));
        thymeleafContext.setVariable("url", url);

        String htmlBody = templateEngine.process("mail-template", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    public void sendEmailRegister(String email, String name, String token) throws MessagingException {
        String verifyUrl = this.url + "/thong-bao?token=" + token + "&type=verifyEmailSuccess";
        themeSendEmail(email, ContentEmailEnum.REGISTRATION, verifyUrl);
    }

    public void sendEmailRegisterWithPassword(String email, String name, String password) throws MessagingException {
        String loginUrl = this.url + "/login";
        themeSendEmail(email, ContentEmailEnum.REGISTER_WITH_PASSWORD, loginUrl, password);
    }

    public void sendEmailForgotPassword(String email, String name, String token) throws MessagingException {
        String resetUrl = this.url + "/quen-mat-khau?token=" + token + "&type=doi-mat-khau";
        themeSendEmail(email, ContentEmailEnum.FORGOT_PASSWORD, resetUrl);
    }
}
