package com.example.finsplore.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {
    private final JavaMailSender mailSender;
    
    @Value("${spring.mail.username}")
    private String fromEmail;

    public EmailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendVerificationCode(String toEmail, String verificationCode) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
        
        helper.setFrom(fromEmail);
        helper.setTo(toEmail);
        helper.setSubject("Finsplore - Email verification code");
        
        String htmlContent = ""
            + "<div style='max-width: 600px; margin: 0 auto; font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica, Arial, sans-serif;'>"
            + "  <div style='text-align: left; padding: 20px 0;'>"
            + "    <img src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTAiIGhlaWdodD0iNTAiIHZpZXdCb3g9IjAgMCA1MCA1MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIyNSIgY3k9IjI1IiByPSIyNSIgZmlsbD0iIzAwMCIvPjwvc3ZnPg==' alt='Logo' style='width: 50px; height: 50px;'/>"
            + "  </div>"
            + "  <div style='margin-top: 20px;'>Hi there,</div>"
            + "  <div style='margin-top: 20px;'>This is your one time verification code.</div>"
            + "  <div style='background-color: #f5f5f5; padding: 20px; margin: 20px 0; text-align: center;'>"
            + "    <div style='font-size: 32px; letter-spacing: 8px; font-weight: 500;'>" + verificationCode + "</div>"
            + "  </div>"
            + "  <div style='margin-top: 20px;'>This code is only active for the next 5 minutes. Once the code expires you will have to resubmit a request for a code.</div>"
            + "  <div style='margin-top: 40px;'>Welcome to Finsplore, where innovation meets intelligent financial management!</div>"
            + "  <div style='margin-top: 10px;'>Finsplore tech</div>"
            + "  <div style='text-align: center; margin-top: 40px;'>"
            + "    <img src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzAiIGhlaWdodD0iMzAiIHZpZXdCb3g9IjAgMCAzMCAzMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48Y2lyY2xlIGN4PSIxNSIgY3k9IjE1IiByPSIxNSIgZmlsbD0iIzAwMCIvPjwvc3ZnPg==' alt='Footer Logo' style='width: 30px; height: 30px;'/>"
            + "  </div>"
            + "</div>";
        
        helper.setText(htmlContent, true);
        mailSender.send(mimeMessage);
    }
}