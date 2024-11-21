package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.Role;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Value("${upload.directory}")
    private String uploadDir;

    // Method to save the image to the file system
    public String saveProfileImage(MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            throw new RuntimeException("File is empty.");
        }

        // Create the directory if it doesn't exist
        Path path = Paths.get(uploadDir);
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }

        // Generate a unique filename for the uploaded file
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
        Path targetPath = path.resolve(fileName);
        Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);

        return fileName;
    }

    // Fetch all managers with pagination
    public Page<User> getAllManagers(Pageable pageable) {
        return userRepository.findAllByRole(Role.MANAGER, pageable);
    }

    // Fetch all employees with pagination
    public Page<User> getAllEmployees(Pageable pageable) {
        return userRepository.findAllByRole(Role.EMPLOYEE, pageable);
    }


    // Load user by username for Spring Security
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with this username: " + username));
    }


    // Fetch users with a basic salary greater than or equal to a specified amount
    public Page<User> getUsersWithSalaryGreaterThanOrEqual(double salary, Pageable pageable) {
        return userRepository.findUsersWithSalaryGreaterThanOrEqual(salary, pageable);
    }

    // Fetch users with a basic salary less than or equal to a specified amount
    public Page<User> getUsersWithSalaryLessThanOrEqual(double salary, Pageable pageable) {
        return userRepository.findUsersWithSalaryLessThanOrEqual(salary, pageable);
    }

    // Search users by a partial or full name match
    public Page<User> searchUsersByName(String name, Pageable pageable) {
        return userRepository.findByFullNameContaining(name, pageable);
    }

    // Fetch users by gender with pagination
    public Page<User> getUsersByGender(String gender, Pageable pageable) {
        return userRepository.findByGender(gender, pageable);
    }

    // Fetch users by joined date with pagination
    public Page<User> getUsersByJoinedDate(LocalDate joinedDate, Pageable pageable) {
        return userRepository.findByJoinedDate(joinedDate, pageable);
    }

}
