package com.mrahmed.HRandPayrollManagementSystem.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "salaries")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Salary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private LocalDateTime paymentDate;
    private double medicare;
    private double providentFund; // baseSalary * (2% = 0.02)
    private double insurance;
    private double transportAllowance;
    private double telephoneSubsidy;
    private double utilityAllowance;
    private double domesticAllowance;
    private double lunchAllowance;
    private double netSalary;
    private double tax;

    @OneToMany(fetch = FetchType.LAZY)
    @JoinColumn(name = "over_time")
    private List<Attendance> overTime; //Working hours are 8. If attendance checks over the 8 hours, it will count as overtime.
    //  Overtime salary calculation = (basicSalary from user divided 4 week * 5 days * 8 hours)

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.EAGER, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "advance_salary_id")
    private AdvanceSalary advanceSalary;

    @OneToMany (fetch = FetchType.LAZY, cascade = CascadeType.PERSIST)
    @JoinColumn(name = "bonus_id")
    private List<Bonus> bonuses;

    @OneToMany (fetch = FetchType.LAZY)
    @JoinColumn(name = "leave_id")
    private List<Leave> leaves;


}

