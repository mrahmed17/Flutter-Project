package com.mrahmed.HRandPayrollManagementSystem.entity;

import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.KeyDeserializer;
import jakarta.persistence.*;
import lombok.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "salaries")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"user", "bonuses", "leaves", "overTime"})
public class Salary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private LocalDateTime paymentDate;
    private double netSalary;
    private double tax;
    private double providentFund;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private RequestStatus salaryStatus;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "advance_salary_id")
    private AdvanceSalary advanceSalary;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "salary")
    private List<Bonus> bonuses;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "salary")
    private List<Leave> leaves;

    @OneToMany(fetch = FetchType.EAGER, mappedBy = "salary")
    private List<Attendance> overTime;



//    double? medicare;
//    double? insurance;
//    double? transportAllowance;
//    double? telephoneSubsidy;
//    double? utilityAllowance;
//    double? domesticAllowance;
//    double? lunchAllowance;

    public static class LeaveTypeKeyDeserializer extends KeyDeserializer {
        @Override
        public Object deserializeKey(String key, DeserializationContext context) throws IOException {
            return LeaveType.valueOf(key.replace("LeaveType.", ""));
        }
    }
}

