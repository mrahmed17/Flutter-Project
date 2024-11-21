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
    private LeaveRepository leaveRepository;

    @Autowired
    private AdvanceSalaryRepository advanceSalaryRepository;

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

    public List<Salary> getAllSalaries() {
        return salaryRepository.findAll();
    }

    public Salary getSalaryById(Long salaryId) {
        return salaryRepository.findById(salaryId)
                .orElseThrow(() -> new RuntimeException("Salary not found for ID: " + salaryId));
    }

//    public List<Salary> getSalariesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
//        return salaryRepository.findByPaymentDateBetween(startDate, endDate);
//    }
//
//    public Optional<Salary> getLatestSalaryForUser(Long userId) {
//        return salaryRepository.findFirstByUser_IdOrderByPaymentDateDesc(userId);
//    }

    public List<Salary> getSalariesByStatus(String status) {
        return salaryRepository.findBySalaryStatus(status);
    }

    public double calculateSalary(long userId) {
        // Fetch the salary entity for calculations
        Salary salary = salaryRepository.findFirstByUser_IdOrderByPaymentDateDesc(userId)
                .orElseThrow(() -> new RuntimeException("Salary not found for user ID: " + userId));

        double baseSalary = salary.getUser().getBasicSalary();
        double netSalary = baseSalary;

        System.out.println("Base Salary: " + baseSalary); // Log base salary

        // 1. Overtime Calculation
        List<Attendance> overtimeRecords = attendanceRepository.findOvertimeForUser(userId);
        double overtimePay = calculateOvertimePay(overtimeRecords, baseSalary);
        System.out.println("Overtime Pay: " + overtimePay); // Log overtime

        netSalary += overtimePay;

        // 2. Bonuses
        double bonusAmount = salary.getBonuses().stream()
                .mapToDouble(Bonus::getBonusAmount)
                .sum();
        System.out.println("Bonuses: " + bonusAmount); // Log bonuses

        netSalary += bonusAmount;

        // 3. Advance Salary Deduction
        if (salary.getAdvanceAmount() != null) {
            double advanceDeduction = salary.getAdvanceAmount().getAdvanceAmount();
            System.out.println("Advance Deduction: " + advanceDeduction); // Log advance salary
            netSalary -= advanceDeduction;
        }

        // 4. Leave Deductions
        double leaveDeductions = calculateLeaveDeductions(salary.getLeaves(), baseSalary);
        System.out.println("Leave Deductions: " + leaveDeductions); // Log leave deductions

        netSalary -= leaveDeductions;

        // 5. Tax and Provident Fund
        double providentFund = baseSalary * 0.02;
        double tax = baseSalary * 0.05;
        System.out.println("Provident Fund: " + providentFund); // Log provident fund
        System.out.println("Tax: " + tax); // Log tax

        salary.setProvidentFund(providentFund);
        salary.setTax(tax);

        netSalary -= providentFund + tax;

        salary.setNetSalary(netSalary);

        return netSalary;
    }


    private double calculateOvertimePay(List<Attendance> overtimeRecords, double baseSalary) {
        double hourlyRate = baseSalary / (4 * 5 * 8); // Weekly 5 days, 8 hours/day
        return overtimeRecords.stream()
                .mapToDouble(att -> {
                    Duration duration = Duration.between(att.getClockInTime(), att.getClockOutTime());
                    return Math.max(0, duration.toHours() - 8); // Overtime hours
                })
                .sum() * hourlyRate;
    }

    private double calculateLeaveDeductions(List<Leave> leaves, double baseSalary) {
        double dailyRate = baseSalary / 30;
        return leaves.stream()
                .mapToDouble(leave -> Duration.between(leave.getStartDate().atStartOfDay(), leave.getEndDate().atStartOfDay()).toDays() * dailyRate)
                .sum();
    }

}
