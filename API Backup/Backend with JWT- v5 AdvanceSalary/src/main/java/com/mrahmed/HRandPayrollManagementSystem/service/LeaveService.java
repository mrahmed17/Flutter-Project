package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.Leave;
import com.mrahmed.HRandPayrollManagementSystem.entity.LeaveType;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.repository.LeaveRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class LeaveService {

    @Autowired
    private LeaveRepository leaveRepository;

    // Save leave request
    public Leave saveLeaveRequest(Leave leave) {
        int remainingDays = calculateRemainingLeaveDays(leave.getStartDate(), leave.getEndDate());
        leave.setRemainingLeave(remainingDays);
        return leaveRepository.save(leave);
    }

    //  update leave request
    public Leave updateLeaveRequest(Long id, Leave updatedLeave) {
        Optional<Leave> existingLeaveOpt = leaveRepository.findById(id);
        if (existingLeaveOpt.isPresent()) {
            Leave existingLeave = existingLeaveOpt.get();
            existingLeave.setStartDate(updatedLeave.getStartDate());
            existingLeave.setEndDate(updatedLeave.getEndDate());
            existingLeave.setRequestDate(updatedLeave.getRequestDate());
            existingLeave.setReason(updatedLeave.getReason());
            existingLeave.setRemainingLeave(updatedLeave.getRemainingLeave());
            existingLeave.setLeaveType(updatedLeave.getLeaveType());
            existingLeave.setRequestStatus(updatedLeave.getRequestStatus());
            existingLeave.setUser(updatedLeave.getUser());
            return leaveRepository.save(existingLeave);
        }
        throw new RuntimeException("Leave request not found with ID: " + id);
    }


    // Delete leave by ID
    public void deleteLeave(Long leaveId) {
        leaveRepository.deleteById(leaveId);
    }

    // Find leave by ID
    public Optional<Leave> getLeaveById(Long leaveId) {
        return leaveRepository.findById(leaveId);
    }

    // Approve a pending leave request
    public Leave approveLeaveRequest(Long leaveId) {
        Optional<Leave> leaveOpt = leaveRepository.findById(leaveId);
        if (leaveOpt.isPresent()) {
            Leave leave = leaveOpt.get();
            leave.setRequestStatus(RequestStatus.APPROVED);
            return leaveRepository.save(leave);
        }
        throw new RuntimeException("Leave request not found with ID: " + leaveId);
    }

    // Reject a leave request
    public Leave rejectLeaveRequest(Long leaveId) {
        Optional<Leave> leaveOpt = leaveRepository.findById(leaveId);
        if (leaveOpt.isPresent()) {
            Leave leave = leaveOpt.get();
            leave.setRequestStatus(RequestStatus.REJECTED);
            return leaveRepository.save(leave);
        }
        throw new RuntimeException("Leave request not found with ID: " + leaveId);
    }


    // Get all pending leave requests
    public List<Leave> getPendingLeaveRequests() {
        return leaveRepository.findPendingLeaveRequests();
    }


    // Get leaves by leave type
    public List<Leave> getLeavesByType(LeaveType leaveType) {
        return leaveRepository.findLeavesByType(leaveType);
    }

    //findRejectedLeaveRequests
    public List<Leave> getRejectedLeaveRequests() {
        return leaveRepository.findRejectedLeaveRequests();
    }

    // Get approved leaves for a specific user
    public List<Leave> getApprovedLeavesByUser(Long userId) {
        return leaveRepository.findApprovedLeavesByUser(userId);
    }

    // Get leaves for a specific user in a date range
    public List<Leave> getLeavesByUserAndDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        return leaveRepository.findLeavesByUserAndDateRange(userId, startDate, endDate);
    }

    // findLeavesByReason
    public List<Leave> getLeavesByReason(String reason) {
        return leaveRepository.findLeavesByReason(reason);
    }

    // Calculate remaining leaves based on start and end dates (helper method)
    public int calculateRemainingLeaveDays(LocalDate startDate, LocalDate endDate) {
        return (int) (endDate.toEpochDay() - startDate.toEpochDay());
    }

}
