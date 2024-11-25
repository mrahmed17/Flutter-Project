package com.mrahmed.HRandPayrollManagementSystem.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "advancesalaries")
@Data
//@Getter
//@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = "user")
public class AdvanceSalary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;

    @NotNull(message = "Advance amount is required")
    @Positive(message = "Advance amount must be greater than zero")
    private double advanceAmount;

    private String reason;

    private LocalDateTime advanceDate = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    private RequestStatus status = RequestStatus.PENDING;

    private boolean isPaid = false;

    private LocalDateTime paidDate;

    public void setIsPaid(boolean isPaid) {
        this.isPaid = isPaid;
    }

}

