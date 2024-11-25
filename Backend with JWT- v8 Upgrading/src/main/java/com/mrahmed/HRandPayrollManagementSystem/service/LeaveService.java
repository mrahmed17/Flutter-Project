package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.*;
import com.mrahmed.HRandPayrollManagementSystem.repository.LeaveRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class LeaveService {

    @Autowired
    private LeaveRepository leaveRepository;

    @Autowired
    private UserRepository userRepository;

    public Leave applyLeave(Long userId, LeaveType leaveType, String reason, LocalDate startDate, LocalDate endDate) {

        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date must be provided.");
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date cannot be after end date.");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));

        int duration = calculateLeaveDuration(startDate, endDate);
        Map<LeaveType, Integer> leaveBalance = user.getLeaveBalance();
        int remainingDays = leaveBalance.getOrDefault(leaveType, 0);

        if (leaveType == LeaveType.UNPAID || remainingDays < duration) {
            if (remainingDays < duration) {
                throw new IllegalArgumentException("Insufficient leave balance for " + leaveType);
            }
            double salaryDeduction = calculateSalaryDeduction(user, duration - remainingDays);
            user.setBasicSalary(user.getBasicSalary() - salaryDeduction);
            leaveBalance.put(leaveType, 0);
        } else {
            leaveBalance.put(leaveType, remainingDays - duration);
        }

        Leave leave = new Leave();
        leave.setUser(user);
        leave.setLeaveType(leaveType);
        leave.setReason(reason);
        leave.setStartDate(startDate);
        leave.setEndDate(endDate);
        leave.setRequestDate(LocalDateTime.now()); // Automatically set the date
        leave.setRequestStatus(RequestStatus.PENDING);

        userRepository.save(user);
        return leaveRepository.save(leave);
    }

    private int calculateLeaveDuration(LocalDate startDate, LocalDate endDate) {
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date cannot be after end date.");
        }
        return (int) (endDate.toEpochDay() - startDate.toEpochDay()) + 1;
    }

    private double calculateSalaryDeduction(User user, int unpaidDays) {
        return unpaidDays * (user.getBasicSalary() / 30.0); // Assuming a 30-day month
    }

    public List<Leave> getAllPendingLeaves() {
        return leaveRepository.findByRequestStatus(RequestStatus.PENDING);
    }

    public List<Leave> getAllLeavesByUser(Long userId) {
        return leaveRepository.findLeavesByUserId(userId);
    }

    public List<Leave> getLeavesByUserAndDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        return leaveRepository.findByUserIdAndStartDateBetween(userId, startDate, endDate);
    }

    public Leave approveLeave(Long leaveId) {
        Leave leave = findLeaveOrThrow(leaveId);
        leave.setRequestStatus(RequestStatus.APPROVED);
        return leaveRepository.save(leave);
    }

    public Leave rejectLeave(Long leaveId) {
        Leave leave = findLeaveOrThrow(leaveId);
        leave.setRequestStatus(RequestStatus.REJECTED);
        return leaveRepository.save(leave);
    }

    public List<Leave> getUserLeaves(Long userId) {
        return leaveRepository.findByUserIdAndRequestStatus(userId, RequestStatus.APPROVED);
    }

    private Leave findLeaveOrThrow(Long leaveId) {
        return leaveRepository.findById(leaveId)
                .orElseThrow(() -> new RuntimeException("Leave not found"));
    }
}
