//package com.mrahmed.HRandPayrollManagementSystem.entity;
//
///**
// * @Project: Backend
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//import jakarta.persistence.*;
//import lombok.AllArgsConstructor;
//import lombok.Data;
//import lombok.NoArgsConstructor;
//
//@Entity
//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//@Table(name = "departments")
//public class Department {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private  int id;
//
//    private  String name;
//    private  String depImage;
//    private  String cell;
//    private  String email;
//    private  int employeeNum;
//
//    @ManyToOne(fetch = FetchType.EAGER)
//    @JoinColumn(name = "branchId")
//    private  Branch branch;
//
//}
