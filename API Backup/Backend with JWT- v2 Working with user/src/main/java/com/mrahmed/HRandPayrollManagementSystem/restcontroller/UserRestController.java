//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Role;
//import com.mrahmed.HRandPayrollManagementSystem.entity.User;
//import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
//import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.PageRequest;
//import org.springframework.data.domain.Pageable;
//
//import java.io.IOException;
//import java.time.LocalDate;
//import java.util.List;
//import java.util.Optional;
//
//@RestController
//@RequestMapping("/api/users")
//@CrossOrigin("*")
//public class UserRestController {
//
//    @Autowired
//    private UserService userService;
//
//
//    @GetMapping("/all")
//    public ResponseEntity<List<User>> getAllUsers() {
//        List<User> users = userService.getAllUsers();
//        return ResponseEntity.ok(users);
//    }
//
//
//}
//
