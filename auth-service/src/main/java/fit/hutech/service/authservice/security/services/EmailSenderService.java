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
        mail.setSubject("Account Activation");
        mail.setText("Please click the link to activate your account: http://localhost:9001/api/auth/confirm?verificationCode=" + verificationCode);
        mailSender.send(mail);

        System.out.println("Email has been sent");
    }
}