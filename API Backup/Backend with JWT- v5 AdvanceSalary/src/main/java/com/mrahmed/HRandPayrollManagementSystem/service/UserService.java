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

import java.time.LocalDate;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Service
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PhotoService photoService;

    public String saveProfileImage(MultipartFile file, String fullName) throws IOException {
        return photoService.savePhoto(file, fullName, "profilePhotos");
    }


//    @Value("${upload.directory}")
//    private String uploadDir;


//    public String saveProfileImage(MultipartFile file, String fullName) throws IOException {
//        Path uploadPath = Paths.get(uploadDir, "profilePhotos");
//        if (!Files.exists(uploadPath)) {
//            Files.createDirectories(uploadPath);
//        }
//        String originalFilename = file.getOriginalFilename();
//        String fileExtension = (originalFilename != null && originalFilename.contains("."))
//                ? originalFilename.substring(originalFilename.lastIndexOf("."))
//                : "";
//        String sanitizedFullName = fullName.replaceAll("[^a-zA-Z0-9]", "_");
//        if (sanitizedFullName.length() > 25) {
//            sanitizedFullName = sanitizedFullName.substring(0, 25);
//        }
//        String uniqueFilename = sanitizedFullName + "_" + UUID.randomUUID() + fileExtension;
//        Path filePath = uploadPath.resolve(uniqueFilename);
//        Files.copy(file.getInputStream(), filePath);
//        return uniqueFilename;
//    }


    public User findUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User Not Found"));
    }

    // update registration user
    @Transactional
    public void updateUser(Long id, User updatedUser, MultipartFile profilePhoto) throws IOException {
        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + id));
        existingUser.setName(updatedUser.getName());
        existingUser.setEmail(updatedUser.getEmail());
        existingUser.setAddress(updatedUser.getAddress());
        existingUser.setGender(updatedUser.getGender());
        existingUser.setDateOfBirth(updatedUser.getDateOfBirth());
        existingUser.setCell(updatedUser.getCell());
        existingUser.setBasicSalary(updatedUser.getBasicSalary());
        existingUser.setRole(updatedUser.getRole());
        if (profilePhoto != null && !profilePhoto.isEmpty()) {
            String profilePhotoFilename = saveProfileImage(profilePhoto, updatedUser.getName());
            existingUser.setProfilePhoto(profilePhotoFilename);
        }
        userRepository.save(existingUser);
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
