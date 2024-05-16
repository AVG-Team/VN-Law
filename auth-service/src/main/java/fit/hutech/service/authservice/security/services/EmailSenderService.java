package fit.hutech.service.authservice.security.services;

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

    public void sendEmailWithToken(String to, String verificationCode){
        SimpleMailMessage mail = new SimpleMailMessage();
        mail.setTo(to);
        mail.setSubject("Kích hoạt tài khoản");
        mail.setText("Vui lòng nhấp vào liên kết để kích hoạt tài khoản: http://localhost:9001/api/auth/confirm?verificationCode=" + verificationCode);
        mailSender.send(mail);
    }
    public void sendSetPasswordEmail(String email, String resetPasswordToken) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage);
        mimeMessageHelper.setTo(email);
        mimeMessageHelper.setSubject("Đặt lại mật khẩu");
        mimeMessageHelper.setText(
                String.format(
                        "<div>" +
                                "Mã đặt lại mật khẩu của bạn là: <strong>%s</strong>" +
                                    "</div>",
                        resetPasswordToken
                ),
                true
        );
        mailSender.send(mimeMessage);
    }

}