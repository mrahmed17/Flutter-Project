package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.AuthenticationResponse;
import com.mrahmed.HRandPayrollManagementSystem.entity.Role;
import com.mrahmed.HRandPayrollManagementSystem.entity.Token;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.jwt.JwtService;
import com.mrahmed.HRandPayrollManagementSystem.repository.TokenRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import jakarta.mail.MessagingException;
import lombok.AllArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TokenRepository tokenRepository;
    private final AuthenticationManager authenticationManager;
    private final EmailService emailService;


    private void saveUserToken(String jwt, User user) {
        Token token = new Token();
        token.setToken(jwt);
        token.setLoggedOut(false);
        token.setUser(user);

        tokenRepository.save(token);
    }

    private void revokeAllTokenByUser(User user) {

        List<Token> validTokens = tokenRepository.findAllTokensByUser(user.getId());
        if (validTokens.isEmpty()) {
            return;
        }

        // Set all valid tokens for the user to logged out
        validTokens.forEach(t -> {
            t.setLoggedOut(true);
        });

        // Save the changes to the tokens in the token repository
        tokenRepository.saveAll(validTokens);
    }


    public AuthenticationResponse register(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "Employee already exists");
        }

        // Create a new user entity and save it to the database
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("EMPLOYEE"));
//        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "Employee registration was successful");
    }

    public AuthenticationResponse registerAdmin(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "Admin already exists");
        }

        // Create a new user entity and save it to the database

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("ADMIN"));
//        user.setLock(true);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "ADMIN registration was successful");
    }

    public AuthenticationResponse registerManager(User user) {

        // Check if the user already exists
        if (userRepository.findByEmail(user.getUsername()).isPresent()) {
            return new AuthenticationResponse(null, "MANAGER already exists");
        }

        // Create a new user entity and save it to the database
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole(Role.valueOf("MANAGER"));
//        user.setLock(false);
        user.setActive(false);

        userRepository.save(user);

        // Generate JWT token for the newly registered user
        String jwt = jwtService.generateToken(user);

        // Save the token to the token repository
        saveUserToken(jwt, user);
        sendActivationEmail(user);

        return new AuthenticationResponse(jwt, "MANAGER registration was successful");
    }


    // Method to authenticate a user
    public AuthenticationResponse authenticate(User request) {

        // Authenticate user credentials using Spring Security's AuthenticationManager
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));

        // Retrieve the user from the database
        User user = userRepository.findByEmail(request.getUsername()).orElseThrow();

        // Generate JWT token for the authenticated user
        String jwt = jwtService.generateToken(user);

        // Revoke all existing tokens for this user
        revokeAllTokenByUser(user);

        // Save the new token to the token repository
        saveUserToken(jwt, user);

        return new AuthenticationResponse(jwt, "Employee login is successful");
    }

    private void sendActivationEmail(User user) {
        String activationLink = "http://localhost:8080/activate/" + user.getId();

        String mailText = "<html>" + "<body style=\"font-family: Arial, sans-serif; color: #333; line-height: 1.6;\">" + "<h3 style=\"color: #2a7ae2;\">Dear " + user.getName() + ",</h3>" + "<p>Thank you for registering with the IsDB Scholarship Program.</p>" + "<p>Please click the link below to activate your account and complete your registration:</p>" + "<p><a href=\"" + activationLink + "\" style=\"color: #2a7ae2;\">Activate Account</a></p>" + "<p>If you did not initiate this request, please ignore this email.</p>" + "<br>" + "<p>Best regards,</p>" + "<p><strong>IsDB Scholarship Program</strong></p>" + "<p>HR and Payroll Management Team</p>" + "</body>" + "</html>";

        String subject = "Activate Your Account – IsDB Scholarship Program";

        try {
            emailService.sendSimpleEmail(user.getEmail(), subject, mailText);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }


//    private void sendActivationEmail(User user) {
//        String activationLink = "http://localhost:8080/activate/" + user.getId();
//
//        String mailText = "<h3>Dear " + user.getName()
//                + ",</h3>"
//                + "<p>Please click on the following link to confirm your account:</p>"
//                + "<a href=\"" + activationLink + "\">Activate Account</a>"
//                + "<br><br>Regards,<br> From, IsDB Scholarship Program"
//                + "<br><br>HR and Payroll Management";
//
//        String subject = "Please, Confirm Your User Account!!";
//
//        try {
//
//            emailService.sendSimpleEmail(user.getEmail(), subject, mailText);
//
//        } catch (MessagingException e) {
//            throw new RuntimeException(e);
//        }
//    }

    // Activate user based on the token
    public String activateUser(long id) {

        User user = userRepository.findById(id).orElseThrow(() -> new RuntimeException("Employee not Found with this ID"));

        if (user != null) {

            user.setActive(true);
            //  user.setActivationToken(null); // Clear token after activation
            userRepository.save(user);
            return "Employee activation successfully!";
        } else {
            return "Invalid activation token!";
        }
    }

}
