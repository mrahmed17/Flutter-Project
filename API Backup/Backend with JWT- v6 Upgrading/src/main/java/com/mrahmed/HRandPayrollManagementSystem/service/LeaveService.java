package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.*;
import com.mrahmed.HRandPayrollManagementSystem.repository.LeaveRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
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
            leaveBalance.put(leaveType, 0); // Deplete the balance for this leave type
        } else {
            leaveBalance.put(leaveType, remainingDays - duration);
        }

        Leave leave = new Leave();
        leave.setUser(user);
        leave.setLeaveType(leaveType);
        leave.setReason(reason);
        leave.setStartDate(startDate);
        leave.setEndDate(endDate);
        leave.setDuration(duration);
        leave.setRequestStatus(RequestStatus.PENDING);

        userRepository.save(user);
        return leaveRepository.save(leave);
    }


//    public boolean applyLeave(User user, LeaveType leaveType, int requestedDays) {
//        Map<LeaveType, Integer> leaveBalance = user.getLeaveBalance();
//        int remainingDays = leaveBalance.getOrDefault(leaveType, 0);
//
//        if (leaveType == LeaveType.UNPAID) {
//            double deduction = calculateSalaryDeduction(user, requestedDays);
//            user.setBasicSalary(user.getBasicSalary() - deduction);
//            return true;
//        }
//
//        if (remainingDays >= requestedDays) {
//            leaveBalance.put(leaveType, remainingDays - requestedDays);
//            userRepository.save(user);
//            return true;
//        }
//
//        throw new IllegalArgumentException("Not enough " + leaveType + " leave available.");
//    }


    public Map<LeaveType, Integer> getUserLeaveBalance(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
        return user.getLeaveBalance();
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

    //  update leave request
    public Leave updateLeaveRequest(Long id, Leave updatedLeave) {
        Leave existingLeave = leaveRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Leave request not found with ID: " + id));
        validateLeaveDates(updatedLeave.getStartDate(), updatedLeave.getEndDate());

        existingLeave.setStartDate(updatedLeave.getStartDate());
        existingLeave.setEndDate(updatedLeave.getEndDate());
        existingLeave.setReason(updatedLeave.getReason());
        existingLeave.setLeaveType(updatedLeave.getLeaveType());
        existingLeave.setRequestStatus(updatedLeave.getRequestStatus());
        return leaveRepository.save(existingLeave);
    }


    // Delete leave by ID
    public void deleteLeave(Long leaveId) {
        leaveRepository.deleteById(leaveId);
    }


    // Find leave by ID
    public Optional<Leave> getLeaveById(Long leaveId) {
        return leaveRepository.findById(leaveId);
    }
    
    
    // Find all Leave records
    public List<Leave> findAllLeave() {
        return leaveRepository.findAll();
    }

    public Leave approveLeaveRequest(Long leaveId) {
        Leave leave = getLeaveOrThrow(leaveId);
        leave.setRequestStatus(RequestStatus.APPROVED);
        return leaveRepository.save(leave);
    }

    public Leave rejectLeaveRequest(Long leaveId) {
        Leave leave = getLeaveOrThrow(leaveId);
        leave.setRequestStatus(RequestStatus.REJECTED);
        return leaveRepository.save(leave);
    }

    @Scheduled(cron = "0 0 0 1 1 *") // Reset leave balances on Jan 1st every year
    public void resetLeaveBalances() {
        List<User> users = userRepository.findAll();
        for (User user : users) {
            user.getLeaveBalance().put(LeaveType.SICK, 15);
            user.getLeaveBalance().put(LeaveType.RESERVE, 10);
            userRepository.save(user);
        }
    }


    public List<Leave> getPendingLeaveRequests() {
        return leaveRepository.findPendingLeaveRequests();
    }

    public List<Leave> getRejectedLeaveRequests() {
        return leaveRepository.findRejectedLeaveRequests();
    }

    public List<Leave> getApprovedLeavesByUser(Long userId) {
        return leaveRepository.findApprovedLeavesByUser(userId);
    }

    public List<Leave> getLeavesByType(LeaveType leaveType) {
        return leaveRepository.findLeavesByType(leaveType);
    }

    public List<Leave> getLeavesByUserAndDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        validateLeaveDates(startDate, endDate);
        return leaveRepository.findLeavesByUserAndDateRange(userId, startDate, endDate);
    }

    public List<Leave> getLeavesByReason(String reason) {
        return leaveRepository.findLeavesByReason(reason);
    }

    private int calculateRemainingLeaveDays(LocalDate startDate, LocalDate endDate) {
        return (int) (endDate.toEpochDay() - startDate.toEpochDay()) + 1;
    }

    private void validateLeaveDates(LocalDate startDate, LocalDate endDate) {
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date cannot be after end date.");
        }
    }

    private Leave getLeaveOrThrow(Long leaveId) {
        return leaveRepository.findById(leaveId)
                .orElseThrow(() -> new RuntimeException("Leave request not found with ID: " + leaveId));
    }

}
