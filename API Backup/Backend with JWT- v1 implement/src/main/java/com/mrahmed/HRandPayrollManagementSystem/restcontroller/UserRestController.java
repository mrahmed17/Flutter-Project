package com.mrahmed.HRandPayrollManagementSystem.restcontroller;


import com.mrahmed.HRandPayrollManagementSystem.entity.Role;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
@CrossOrigin("*")
public class UserRestController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/create")
    public ResponseEntity<String> createUser(
            @RequestPart("user") User user,
            @RequestPart(value = "profilePhoto", required = false) MultipartFile profilePhoto
    ) {
        try {
            userService.saveUser(user, profilePhoto);
            return new ResponseEntity<>("User created successfully with profile photo.", HttpStatus.CREATED);
        } catch (IOException e) {
            return new ResponseEntity<>("Failed to upload profile photo: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateUser(
            @PathVariable Long id,
            @RequestPart("user") User user,
            @RequestPart(value = "profilePhoto", required = false) MultipartFile profilePhoto
    ) {
        try {
            userService.updateUser(id, user, profilePhoto);
            return new ResponseEntity<>("User updated successfully.", HttpStatus.OK);
        } catch (IOException e) {
            return new ResponseEntity<>("Failed to update user: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @GetMapping("/all")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/find/{id}")
    public ResponseEntity<User> findUserById(@PathVariable Long id) {
        try {
            User user = userService.findUserById(id);
            return ResponseEntity.ok(user);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable Long id) {
        Optional<User> user = userRepository.findById(id);
        if (!user.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found.");
        }
        userRepository.deleteById(id);
        return ResponseEntity.ok("User successfully deleted.");
    }


    @GetMapping("/email/{email}")
    public ResponseEntity<User> getUserByEmail(@PathVariable("email") String email) {
        Optional<User> userOptional = userService.getUserByEmail(email);
        return userOptional.map(user -> new ResponseEntity<>(user, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }


    @GetMapping("/salary/greaterThanOrEqual")
    public ResponseEntity<Page<User>> getUsersWithSalaryGreaterThanOrEqual(
            @RequestParam("salary") double salary,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> users = userService.getUsersWithSalaryGreaterThanOrEqual(salary, pageable);
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    // Get Users with Salary Less Than or Equal with Pagination
    @GetMapping("/salary/lessThanOrEqual")
    public ResponseEntity<Page<User>> getUsersWithSalaryLessThanOrEqual(
            @RequestParam("salary") double salary,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> users = userService.getUsersWithSalaryLessThanOrEqual(salary, pageable);
        return new ResponseEntity<>(users, HttpStatus.OK);
    }


    // Get Users by Role with Pagination
    @GetMapping("/role/{role}")
    public ResponseEntity<Page<User>> getUsersByRole(
            @PathVariable String role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        try {
            Role userRole = Role.valueOf(role.toUpperCase());
            Pageable pageable = PageRequest.of(page, size);
            Page<User> users = userService.getUsersByRole(userRole, pageable);
            return new ResponseEntity<>(users, HttpStatus.OK);
        } catch (IllegalArgumentException e) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }


    // Search Users by Name with Pagination
    @GetMapping("/search/name/{name}")
    public ResponseEntity<Page<User>> getUsersByFullNamePart(
            @PathVariable("name") String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> users = userService.getUsersByFullNamePart(name, pageable);
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    // Search Users by Gender with Pagination
    @GetMapping("/gender/{gender}")
    public ResponseEntity<Page<User>> getUsersByGender(
            @PathVariable("gender") String gender,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> users = userService.getUsersByGender(gender, pageable);
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    // Search Users by Joined Date with Pagination
    @GetMapping("/joinedDate/{joinedDate}")
    public ResponseEntity<Page<User>> getUsersByJoinedDate(
            @PathVariable("joinedDate") LocalDate joinedDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Pageable pageable = PageRequest.of(page, size);
        Page<User> users = userService.getUsersByJoinedDate(joinedDate, pageable);
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
}

