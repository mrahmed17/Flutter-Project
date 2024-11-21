//package com.mrahmed.HRandPayrollManagementSystem.entity;
//
//import jakarta.persistence.*;
//import lombok.*;
//
//import java.time.LocalDateTime;
//
//@Entity
//@Table(name = "advancesalaries")
//@Data
//@AllArgsConstructor
//@NoArgsConstructor
//public class AdvanceSalary {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private long id;
//    private double advanceSalary;
//    private String reason;
//    private LocalDateTime advanceDate;
//
//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "user_id")
//    private User user;
//}
