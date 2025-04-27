package avg.vnlaw.authservice.services;

import jakarta.mail.MessagingException;

public interface EmailService {
    void sendEmailRegister(String email, String name, String token) throws MessagingException;
    void sendEmailRegisterWithPassword(String email, String name, String password) throws MessagingException;
    void sendEmailForgotPassword(String email, String name, String token) throws MessagingException;
    String sendVerificationEmail(String email);
    void sendPasswordEmail(String email, String subject, String content);
    boolean verifyEmail(String email, String token);
}
