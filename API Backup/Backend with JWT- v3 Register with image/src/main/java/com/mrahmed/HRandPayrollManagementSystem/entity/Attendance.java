//package com.mrahmed.HRandPayrollManagementSystem.entity;
//
//import jakarta.persistence.*;
//import lombok.*;
//
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//
//@Entity
//@Table(name = "attendances")
//@Data
//@AllArgsConstructor
//@NoArgsConstructor
//public class Attendance {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private long id;
//
//    private LocalDate date;
//    private LocalDateTime clockInTime;
//    private LocalDateTime clockOutTime;
//
//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "user_id", nullable = false)
//    private User user;
//
//
//}
