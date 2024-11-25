//package com.mrahmed.HRandPayrollManagementSystem.entity;
//
///**
// * @Project: Backend
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//import com.fasterxml.jackson.annotation.JsonFormat;
//import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
//import jakarta.persistence.*;
//import jakarta.validation.constraints.Email;
//import jakarta.validation.constraints.NotBlank;
//import jakarta.validation.constraints.Pattern;
//import lombok.AllArgsConstructor;
//import lombok.*;
//import lombok.NoArgsConstructor;
//
//import java.time.LocalDateTime;
//
//@Entity
//@Getter
//@Setter
//@NoArgsConstructor
//@AllArgsConstructor
//@Table(name = "departments")
//public class Department {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private  long id;
//
//    @Column(nullable = false, unique = true)
//    @NotBlank(message = "Department name cannot be blank")
//    private String name;
//
//    @Email(message = "Invalid email address")
//    @Column(unique = true, nullable = false)
//    @NotBlank(message = "Email cannot be blank")
//    private String email;
//
//    @Pattern(regexp = "^\\+?[0-9]{10,15}$", message = "Invalid phone number")
//    @Column(length = 15, unique = true, nullable = false)
//    private String cell;
//
//    private  String depImage;
//
//    @Column(name = "employee_count", nullable = false)
//    private int employeeNum;
//
//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "branch_id", nullable = false)
//    @JsonIgnoreProperties("departments")
//    private Branch branch;
//
//    @Column(updatable = false)
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//    private LocalDateTime createdAt;
//
//    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
//    private LocalDateTime updatedAt;
//
//    @PrePersist
//    public void prePersist() {
//        this.createdAt = LocalDateTime.now();
//    }
//
//    @PreUpdate
//    public void preUpdate() {
//        this.updatedAt = LocalDateTime.now();
//    }
//
//
//}
