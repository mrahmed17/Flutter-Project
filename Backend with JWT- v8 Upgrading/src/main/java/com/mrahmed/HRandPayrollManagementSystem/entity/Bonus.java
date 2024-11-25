package com.mrahmed.HRandPayrollManagementSystem.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "bonuses")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = "user") //prevents infinite recursion due to bi-directional relationships.
public class Bonus {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(nullable = false)
    private double bonusAmount;

    @Column(nullable = false)
    private LocalDateTime bonusDate;

    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private BonusType bonusType;  // Performance, Annual, Festival, Promotional

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "salary_id")
    private Salary salary;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;


}
