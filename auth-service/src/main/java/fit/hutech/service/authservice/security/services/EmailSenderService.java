package fit.hutech.service.authservice.security.services;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
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
}