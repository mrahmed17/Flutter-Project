package com.mrahmed.HRandPayrollManagementSystem.service;


import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.AllArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class EmailService {


    private final JavaMailSender javaMailSender;

    public void sendHtmlEmail(String to, String subject, String htmlContent) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, "utf-8");

        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(htmlContent, true);

        javaMailSender.send(message);
    }

    public void sendSimpleEmail(String to, String subject, String text) throws MessagingException {
        MimeMessage mes = javaMailSender.createMimeMessage();
        MimeMessageHelper message = new MimeMessageHelper(mes, true);
        message.setTo(to);
        message.setSubject(subject);
        message.setText(text);

        javaMailSender.send(mes);
    }
}
