package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.AuthenticationResponse;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.service.AuthService;
import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

@RestController
@AllArgsConstructor
@CrossOrigin("*")
public class AuthenticationController {

    private final AuthService authService;
    private final UserService userService;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestPart User user,
                                                           @RequestParam(required = false) MultipartFile profilePhoto) {
        try {
            AuthenticationResponse response = authService.register(user, profilePhoto);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(new AuthenticationResponse("Error during registration: " + e.getMessage()));
        }
    }

//    @PostMapping("/register")
//    public ResponseEntity<AuthenticationResponse> register(@RequestBody User request) {
//        return ResponseEntity.ok(authService.register(request));
//    }

    @PostMapping("/register/admin")
    public ResponseEntity<AuthenticationResponse> registerAdmin(@RequestBody User request) {
        return ResponseEntity.ok(authService.registerAdmin(request));
    }

    @PostMapping("/register/manager")
    public ResponseEntity<AuthenticationResponse> registerManager(@RequestBody User request) {
        return ResponseEntity.ok(authService.registerManager(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponse> login(@RequestBody User request) {
        return ResponseEntity.ok(authService.authenticate(request));
    }

    @GetMapping("/activate/{id}")
    public ResponseEntity<String> activateUser(@PathVariable("id") long id) {
        String response = authService.activateUser(id);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/getAllManagers")
    public ResponseEntity<Page<User>> getAllManagers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> managers = userService.getAllManagers(PageRequest.of(page, size));
        return ResponseEntity.ok(managers);
    }

    @GetMapping("/getAllEmployees")
    public ResponseEntity<Page<User>> getAllEmployees(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> employees = userService.getAllEmployees(PageRequest.of(page, size));
        return ResponseEntity.ok(employees);
    }

    @GetMapping("/getUsersWithSalaryGreaterThanOrEqual")
    public ResponseEntity<Page<User>> getUsersWithSalaryGreaterThanOrEqual(
            @RequestParam double salary,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> users = userService.getUsersWithSalaryGreaterThanOrEqual(salary, PageRequest.of(page, size));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/getUsersWithSalaryLessThanOrEqual")
    public ResponseEntity<Page<User>> getUsersWithSalaryLessThanOrEqual(
            @RequestParam double salary,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> users = userService.getUsersWithSalaryLessThanOrEqual(salary, PageRequest.of(page, size));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/searchUsersByName")
    public ResponseEntity<Page<User>> searchUsersByName(
            @RequestParam String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> users = userService.searchUsersByName(name, PageRequest.of(page, size));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/getUsersByGender")
    public ResponseEntity<Page<User>> getUsersByGender(
            @RequestParam String gender,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> users = userService.getUsersByGender(gender, PageRequest.of(page, size));
        return ResponseEntity.ok(users);
    }

    @GetMapping("/getUsersByJoinedDate")
    public ResponseEntity<Page<User>> getUsersByJoinedDate(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate joinedDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Page<User> users = userService.getUsersByJoinedDate(joinedDate, PageRequest.of(page, size));
        return ResponseEntity.ok(users);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<String> forgotPassword(@RequestParam String email) {
        authService.forgotPassword(email);
        return ResponseEntity.ok("Password reset link sent to email");
    }

    @PostMapping("/reset-password")
    public ResponseEntity<String> resetPassword(
            @RequestParam String token,
            @RequestParam String newPassword
    ) {
        String response = authService.resetPassword(token, newPassword);
        return ResponseEntity.ok(response);
    }


}
