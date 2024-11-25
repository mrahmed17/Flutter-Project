package com.mrahmed.HRandPayrollManagementSystem.util;

/**
 * @Project: Backend with JWT- v3 Upgrading
 * @Author: M. R. Ahmed
 * @Created at: 11/12/2024
 */
public class EmailContentBuilder {
    public static String buildActivationEmail(String userName, String activationLink) {
        return "<html>"
                + "<body style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6;\">"
                + "<h3 style=\"color: #2a7ae2;\">Dear " + userName + ",</h3>"
                + "<p>Thank you for registering with the IsDB Scholarship Program.</p>"
                + "<p>Please click the link below to activate your account and complete your registration:</p>"
                + "<p><a href=\"" + activationLink + "\" style=\"color: #2a7ae2;\">Activate Account</a></p>"
                + "<p>If you did not initiate this request, please ignore this email.</p>"
                + "<br>"
                + "<p>Best regards,</p>"
                + "<p><strong>IsDB Scholarship Program</strong></p>"
                + "<p>HR and Payroll Management Team</p>"
                + "</body>"
                + "</html>";
    }

}
