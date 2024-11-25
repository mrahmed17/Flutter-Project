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
    private UserRepository userRepository;

    @Autowired
    private AdvanceSalaryRepository advanceSalaryRepository;

    @Autowired
    private BonusRepository bonusRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private LeaveRepository leaveRepository;

    @Autowired
    private SalaryRepository salaryRepository;

    public Salary saveSalary(Salary salary) {
        return salaryRepository.save(salary);
    }

    public Salary calculateSalary(Long userId) {
        // Fetch user
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        double basicSalary = user.getBasicSalary();

        // 1. Deduct Advance Salary
        double totalAdvance = advanceSalaryRepository.findByUserAndIsPaidTrue(user)
                .stream()
                .mapToDouble(AdvanceSalary::getAdvanceAmount)
                .sum();

        // 2. Add Bonuses
        double totalBonus = bonusRepository.findByUserAndSalaryIsNull(user)
                .stream()
                .mapToDouble(Bonus::getBonusAmount)
                .sum();

        // 3. Add Overtime Payments
        double overtimePayment = attendanceRepository.findByUserAndSalaryIsNull(user)
                .stream()
                .mapToDouble(this::calculateOvertimePayment)
                .sum();

        // 4. Deduct Leave Deductions
        double leaveDeduction = leaveRepository.findByUserAndSalaryIsNull(user)
                .stream()
                .mapToDouble(leave -> calculateLeaveDeduction(leave, basicSalary / 30)) // Assuming 30 days in a month
                .sum();

        // 5. Apply Taxes and Provident Fund
        double tax = calculateTax(basicSalary); // Example: Flat rate or tiered system
        double providentFund = calculateProvidentFund(basicSalary); // Example: 10% of basic salary

        // Calculate net salary
        double netSalary = basicSalary - totalAdvance + totalBonus + overtimePayment - leaveDeduction - tax - providentFund;

        // Create Salary entity
        Salary salary = new Salary();
        salary.setUser(user);
        salary.setNetSalary(netSalary);
        salary.setTax(tax);
        salary.setProvidentFund(providentFund);
        salary.setPaymentDate(LocalDateTime.now());
        salary.setSalaryStatus(RequestStatus.PENDING);

        // Link advance salary, bonuses, attendances, and leaves to this salary
        salary.setAdvanceSalary(advanceSalaryRepository.findLatestAdvanceSalaryByUser(user));
        salary.setBonuses(bonusRepository.findByUserAndSalaryIsNull(user));
        salary.setOverTime(attendanceRepository.findByUserAndSalaryIsNull(user));
        salary.setLeaves(leaveRepository.findByUserAndSalaryIsNull(user));

        // Save salary
        return salaryRepository.save(salary);
    }

    private double calculateOvertimePayment(Attendance attendance) {
        // Example: Overtime payment = $10/hour
        long hours = Duration.between(attendance.getClockOutTime(), attendance.getClockInTime()).toHours();
        return hours * 10.0;
    }

    private double calculateLeaveDeduction(Leave leave, double dailySalary) {
        // Example: Deduct daily salary for every day of leave that exceeds balance
        return leave.getLeaveType().equals(LeaveType.UNPAID) ? dailySalary : 0;
    }

    private double calculateTax(double salary) {
        // Example: 10% tax on the salary
        return salary * 0.10;
    }

    private double calculateProvidentFund(double salary) {
        // Example: 10% of basic salary as provident fund
        return salary * 0.10;
    }

//    public double calculateSalary(long userId) {
//        double baseSalary = salaryRepository.findFirstByUserIdOrderByPaymentDateDesc(userId)
//                .map(Salary::getUser)
//                .map(User::getBasicSalary)
//                .orElseThrow(() -> new RuntimeException("Base salary not found for user ID: " + userId));
//
//        double overtimePay = calculateOvertimePay(userId);
//        double bonuses = calculateBonuses(userId);
//        double advanceDeduction = calculateAdvanceDeduction(userId);
//        double leaveDeductions = calculateLeaveDeductions(userId, baseSalary);
//
//        double providentFund = baseSalary * 0.02;
//        double tax = baseSalary * 0.05;
//
//        double netSalary = baseSalary + overtimePay + bonuses - advanceDeduction - leaveDeductions - providentFund - tax;
//        return netSalary;
//    }
//
//    private double calculateOvertimePay(long userId) {
//        return attendanceRepository.findAttendancesWithClockOutByUserId(userId).stream()
//                .mapToDouble(this::calculateOvertimePayForAttendance)
//                .sum();
//    }
//
//    private double calculateOvertimePayForAttendance(Attendance attendance) {
//        double hourlyRate = attendance.getUser().getBasicSalary() / (4 * 5 * 8); // Monthly rate divided by work hours.
//        Duration duration = Duration.between(attendance.getClockInTime(), attendance.getClockOutTime());
//        long overtimeHours = Math.max(0, duration.toHours() - 8);
//        return overtimeHours * hourlyRate;
//    }
//
//    private double calculateBonuses(long userId) {
//        return bonusRepository.findBonusesByUserId(userId).stream()
//                .mapToDouble(Bonus::getBonusAmount)
//                .sum();
//    }
//
//    private double calculateAdvanceDeduction(long userId) {
//        return advanceSalaryRepository.findByUserIdAndStatus(userId, RequestStatus.APPROVED)
//                .map(AdvanceSalary::getAdvanceAmount)
//                .orElse(0.0);
//    }
//
//    private double calculateLeaveDeductions(long userId, double baseSalary) {
//        double dailyRate = baseSalary / 30;
//        return leaveRepository.findLeavesByUserId(userId).stream()
//                .mapToDouble(leave -> {
//                    long days = Duration.between(leave.getStartDate().atStartOfDay(), leave.getEndDate().atStartOfDay())
//                            .toDays();
//                    return days * dailyRate;
//                })
//                .sum();
//    }

    // Get salary by ID
    public Optional<Salary> getSalaryById(Long id) {
        return salaryRepository.findById(id);
    }

    // Get all salaries
    public List<Salary> getAllSalaries() {
        return salaryRepository.findAll();
    }

    // Update salary
    public Salary updateSalary(Long id, Salary salary) {
        if (!salaryRepository.existsById(id)) {
            throw new RuntimeException("Salary not found with ID: " + id);
        }
        salary.setId(id);
        return salaryRepository.save(salary);
    }

    // Delete salary
    public void deleteSalary(Long id) {
        salaryRepository.deleteById(id);
    }

    // Get salaries by status
    public List<Salary> getSalariesByStatus(RequestStatus status) {
        return salaryRepository.findBySalaryStatus(status);
    }

    public List<Salary> getSalariesByUserAndDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        return salaryRepository.findByUserIdAndPaymentDateBetween(userId, startDate, endDate);
    }

    public List<Salary> getSalariesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return salaryRepository.findByPaymentDateBetween(startDate, endDate);
    }

}
