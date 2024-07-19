package avg.vnlaw.authservice.services.impl;

import avg.vnlaw.authservice.services.EmailService;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.context.Context;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {
    private final Dotenv dotenv = Dotenv.load();
    private final JavaMailSender mailSender;
    private final SpringTemplateEngine templateEngine;
    private final String url = dotenv.get("Frontend_URL");

    @Override
    public void sendEmailRegister(String email, String name, String token) throws MessagingException {

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Registration Successful");

        Context thymeleafContext = new Context();

        String title = "Congratulations on your Successful Registration!!! ";
        String message = "Thank you for registering with us. Your account has been successfully created and is now ready to use. We are delighted to have you on board and look forward to providing you with the best experience. Please confirm your email by clicking the confirmation button below to complete the registration process and start using your account.";
        String url = this.url + "/thong-bao?token=" + token + "&type=verifyEmailSuccess";

        thymeleafContext.setVariable("title", title);
        thymeleafContext.setVariable("message", message);
        thymeleafContext.setVariable("url", url);
        thymeleafContext.setVariable("name", name);
        thymeleafContext.setVariable("textBtn", "Register Now");

        String htmlBody = templateEngine.process("mail-template", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    @Override
    public void sendEmailRegisterWithPassword(String email, String name, String password) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Login Successful");

        Context thymeleafContext = new Context();

        String title = "Congratulations on your Successful Login!!! ";
        String message = "Thank you for logging in with us. Your account has been successfully logged in and is now ready to use. We are delighted to have you on board and look forward to providing you with the best experience. Your Password is: `" + password + "`; Please login now by clicking the button below.";
        String url = this.url + "/login";

        thymeleafContext.setVariable("title", title);
        thymeleafContext.setVariable("message", message);
        thymeleafContext.setVariable("url", url);
        thymeleafContext.setVariable("textBtn", "Login Now");
        thymeleafContext.setVariable("name", name);

        String htmlBody = templateEngine.process("mail-template", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }

    @Override
    public void sendEmailForgotPassword(String email, String name, String token) throws MessagingException {

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Forgot Password");

        Context thymeleafContext = new Context();

        String title = "Forgot Password!!! ";
        String message = "You have requested to reset your password. Please click the button below to reset your password.";
        String url = this.url + "/change-password?token=" + token;

        thymeleafContext.setVariable("title", title);
        thymeleafContext.setVariable("message", message);
        thymeleafContext.setVariable("url", url);
        thymeleafContext.setVariable("name", name);
        thymeleafContext.setVariable("textBtn", "Reset Password");

        String htmlBody = templateEngine.process("mail-template", thymeleafContext);
        mimeMessageHelper.setText(htmlBody, true);

        mailSender.send(mimeMessage);
    }
}
