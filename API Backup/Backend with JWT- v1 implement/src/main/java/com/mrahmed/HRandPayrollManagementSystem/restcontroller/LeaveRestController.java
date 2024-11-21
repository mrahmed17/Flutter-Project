package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Leave;
import com.mrahmed.HRandPayrollManagementSystem.entity.LeaveType;
import com.mrahmed.HRandPayrollManagementSystem.service.LeaveService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/leaves")
@CrossOrigin("*")
public class LeaveRestController {

    @Autowired
    private LeaveService leaveService;

    // Save a leave request
    @PostMapping("/save")
    public ResponseEntity<Leave> saveLeaveRequest(@RequestBody Leave leave) {
        Leave savedLeave = leaveService.saveLeaveRequest(leave);
        return ResponseEntity.ok(savedLeave);
    }

    // Update a leave request
    @PutMapping("/update/{id}")
    public ResponseEntity<Leave> updateLeaveRequest(@PathVariable("id") Long id, @RequestBody Leave leave) {
        Leave updatedLeave = leaveService.updateLeaveRequest(id, leave);
        return ResponseEntity.ok(updatedLeave);
    }

    // Delete a leave by ID
    @DeleteMapping("/delete/{leaveId}")
    public ResponseEntity<Void> deleteLeave(@PathVariable Long leaveId) {
        leaveService.deleteLeave(leaveId);
        return ResponseEntity.noContent().build();
    }

    // Find a leave by ID
    @GetMapping("/find/{leaveId}")
    public ResponseEntity<Leave> getLeaveById(@PathVariable Long leaveId) {
        Optional<Leave> leave = leaveService.getLeaveById(leaveId);
        return leave.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    // Approve a leave request
    @PostMapping("/approve/{leaveId}")
    public ResponseEntity<Leave> approveLeaveRequest(@PathVariable Long leaveId) {
        Leave approvedLeave = leaveService.approveLeaveRequest(leaveId);
        return ResponseEntity.ok(approvedLeave);
    }

    // Reject a leave request
    @PostMapping("/reject/{leaveId}")
    public ResponseEntity<Leave> rejectLeaveRequest(@PathVariable Long leaveId) {
        Leave rejectedLeave = leaveService.rejectLeaveRequest(leaveId);
        return ResponseEntity.ok(rejectedLeave);
    }


    // Get all pending leave requests
    @GetMapping("/pending")
    public ResponseEntity<List<Leave>> getPendingLeaveRequests() {
        List<Leave> pendingLeaves = leaveService.getPendingLeaveRequests();
        return ResponseEntity.ok(pendingLeaves);
    }


    // Get all leaves by leave type
    @GetMapping("/type/{leaveType}")
    public ResponseEntity<List<Leave>> getLeavesByType(@PathVariable LeaveType leaveType) {
        List<Leave> leaves = leaveService.getLeavesByType(leaveType);
        return ResponseEntity.ok(leaves);
    }

    // getRejectedLeaveRequests
    @GetMapping("/rejected")
    public ResponseEntity<List<Leave>> getRejectedLeaveRequests() {
        List<Leave> rejectedLeaves = leaveService.getRejectedLeaveRequests();
        return ResponseEntity.ok(rejectedLeaves);
    }

    // Get approved leaves for a specific user
    @GetMapping("/user/{userId}/approved")
    public ResponseEntity<List<Leave>> getApprovedLeavesByUser(@PathVariable Long userId) {
        List<Leave> approvedLeaves = leaveService.getApprovedLeavesByUser(userId);
        return ResponseEntity.ok(approvedLeaves);
    }

    // Get leaves for a user in a specific date range
    @GetMapping("/user/{userId}/range")
    public ResponseEntity<List<Leave>> getLeavesByUserAndDateRange(
            @PathVariable Long userId,
            @RequestParam("startDate") LocalDate startDate,
            @RequestParam("endDate") LocalDate endDate) {
        List<Leave> leaves = leaveService.getLeavesByUserAndDateRange(userId, startDate, endDate);
        return ResponseEntity.ok(leaves);
    }

    // getLeavesByReason
    @GetMapping("/reason/{reason}")
    public ResponseEntity<List<Leave>> getLeavesByReason(@PathVariable String reason) {
        List<Leave> leaves = leaveService.getLeavesByReason(reason);
        return ResponseEntity.ok(leaves);
    }


}

