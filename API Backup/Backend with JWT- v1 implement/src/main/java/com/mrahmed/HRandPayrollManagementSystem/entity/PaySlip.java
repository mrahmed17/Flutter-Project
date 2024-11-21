package com.mrahmed.HRandPayrollManagementSystem.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "payslips")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class PaySlip {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private double totalAmount;

    @Column(nullable = false)
    private LocalDateTime billingDate;

    @Column(length = 20)
    private String paymentMethod; // Cash, Card

    @Column(nullable = false)
    private String status;  // PAID, UNPAID, CANCELLED

    // Manager who approves the salary
    @ManyToOne
    @JoinColumn(name = "managerId", nullable = false)
    private User paidBy;

    // User payslip belongs to a user who will get payment
    @ManyToOne
    @JoinColumn(name = "employeeId")
    private User receivedBy;

    //Payment is generated after one month
    @JsonBackReference
    @OneToOne
    @JoinColumn(name = "salaryId", nullable = false)
    private Salary salary;
}
