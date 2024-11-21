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
    private double totalAmount;  // Total salary to be paid, after deductions, allowances, etc.

    @Column(nullable = false)
    private LocalDateTime billingDate;  // The date of salary generation (usually a monthly date)

    @Column(length = 20)
    private String paymentMethod; // Cash, Bank, etc.

    @Column(nullable = false)
    private String status;  // PAID, UNPAID, CANCELLED

    // Manager who approves the salary
    @ManyToOne
    @JoinColumn(name = "managerId", nullable = false)
    private User paidBy;  // This is the manager who approves and processes the payslip

    // User (employee) who receives the payslip
    @ManyToOne
    @JoinColumn(name = "employeeId", nullable = false)
    private User receivedBy;  // The employee receiving the salary

    // Payment is generated based on salary (typically for the month)
    @JsonBackReference
    @OneToOne
    @JoinColumn(name = "salaryId", nullable = false)
    private Salary salary;  // The associated salary record for the employee's payment

}
