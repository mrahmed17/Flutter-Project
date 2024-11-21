package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.*;
import com.mrahmed.HRandPayrollManagementSystem.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class SalaryService {

    @Autowired
    private SalaryRepository salaryRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private BonusRepository bonusRepository;

    @Autowired
    private AdvanceSalaryRepository advanceSalaryRepository;

    @Autowired
    private LeaveRepository leaveRepository;


    public Salary saveSalary(Salary salary) {
        return salaryRepository.save(salary);
    }

    // Update an existing salary record
    public Salary updateSalary(Long salaryId, Salary salary) {
        if (!salaryRepository.existsById(salaryId)) {
            throw new RuntimeException("Salary record not found for ID: " + salaryId);
        }
        salary.setId(salaryId);
        return salaryRepository.save(salary);
    }

    // Delete a salary record by ID
    public void deleteSalary(Long salaryId) {
        if (!salaryRepository.existsById(salaryId)) {
            throw new RuntimeException("Salary record not found for ID: " + salaryId);
        }
        salaryRepository.deleteById(salaryId);
    }

    // Get a salary record by ID
    public Salary getSalaryById(Long salaryId) {
        return salaryRepository.findById(salaryId)
                .orElseThrow(() -> new RuntimeException("Salary record not found for ID: " + salaryId));
    }


    // findAllSalary
    public List<Salary> getAllSalaries() {
        return salaryRepository.findAll();
    }

    // Get salaries within a specific date range
    public List<Salary> getSalariesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return salaryRepository.findSalariesByDateRange(startDate, endDate);
    }

    // Get the latest salary record for a specific user
    public List<Salary> getLatestSalaryByUser(Long userId) {
        return salaryRepository.findLatestSalaryByUser(userId);
    }


    public double calculateTotalSalary(long userId) {
        // Retrieve the user's salary entity
        Salary salary = salaryRepository.findBySalaryUserId(userId);

        if (salary == null) {
            throw new RuntimeException("Salary not found for user ID: " + userId);
        }

        double baseSalary = salary.getUser().getBasicSalary();
        double totalSalary = baseSalary;

        // 1. Overtime Calculation
        List<Attendance> overtimeAttendances = attendanceRepository.findOvertimeForUser(userId);
        totalSalary += calculateOvertimePay(overtimeAttendances, baseSalary);

        // 2. Bonus Calculation
        Optional<Bonus> bonuses = bonusRepository.findById(salary.getId());
        totalSalary += calculateBonusAmount(bonuses);

        // 3. Advance Salary Deduction
        if (salary.getAdvanceSalary() != null) {
            totalSalary -= salary.getAdvanceSalary().getAdvanceAmount();
        }

        // 4. Leave Deduction
        Optional<Leave> leaves = leaveRepository.findById(salary.getId());
        totalSalary -= calculateLeaveDeductions(leaves, baseSalary);

        return totalSalary;
    }

    private double calculateOvertimePay(List<Attendance> overtimeAttendances, double baseSalary) {
        double overtimeRate = baseSalary / (4 * 5 * 8); // Weekly 5 days, 8 hours per day
        double totalOvertimeHours = overtimeAttendances.stream()
                .mapToDouble(attendance -> {
                    Duration duration = Duration.between(attendance.getClockInTime(), attendance.getClockOutTime());
                    return Math.max(0, duration.toHours() - 8); // Subtract regular 8 hours
                })
                .sum();
        return totalOvertimeHours * overtimeRate;
    }

    private double calculateBonusAmount(Optional<Bonus> bonuses) {
        return bonuses.stream()
                .mapToDouble(Bonus::getBonusAmount)
                .sum();
    }

    private double calculateLeaveDeductions(Optional<Leave> leaves, double baseSalary) {
        double dailySalary = baseSalary / 30; // Assuming 30 days in a month
        long totalLeaveDays = leaves.stream()
                .mapToLong(leave -> Duration.between(leave.getStartDate().atStartOfDay(), leave.getEndDate().atStartOfDay()).toDays() + 1)
                .sum();
        return totalLeaveDays * dailySalary;
    }

}
