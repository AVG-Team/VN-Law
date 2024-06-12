package fit.hutech.service.authservice.security.services;

import fit.hutech.service.authservice.models.User;
import fit.hutech.service.authservice.repositories.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailSenderService {
    private final JavaMailSender mailSender;


    public void sendEmailWithToken(String email, String verificationCode) throws MessagingException{
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage);
        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Kích hoạt tài khoản");
        mimeMessageHelper.setText(
                String.format(
                        "<html>" +
                                "<body>" +
                                    "<p>Vui lòng nhấn vào nút bên dưới để kích hoạt tài khoản:</p>" +
                                    "<a href='http://localhost:3000/dang-nhap?verificationCode=%s' style='display: inline-block; padding: 10px 20px; background-color: blue; color: white; text-decoration: none; border-radius: 4px;'>Kích hoạt tài khoản</a>" +
                                "</body>" +
                        "</html>",
                        verificationCode
                ),
                true
        );
        mailSender.send(mimeMessage);
    }
    public void sendSetPasswordEmail(String email, String resetPasswordToken) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage);
        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Quên mật khẩu");
        mimeMessageHelper.setText(
                String.format(
                        "<div>" +
                                "Mã xác thực:  <strong>%s</strong>" +
                        "</div>",
                        resetPasswordToken
                ),
                true
        );
        mailSender.send(mimeMessage);
    }
}