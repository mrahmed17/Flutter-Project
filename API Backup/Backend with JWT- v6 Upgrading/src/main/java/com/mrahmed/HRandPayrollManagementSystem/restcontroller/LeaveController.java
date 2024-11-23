package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.entity.Leave;
import com.mrahmed.HRandPayrollManagementSystem.entity.LeaveType;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.service.LeaveService;
import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/leaves")
@CrossOrigin("*")
public class LeaveController {

    @Autowired
    private LeaveService leaveService;
    @Autowired
    private UserService userService;

    @PostMapping("/apply")
    public ResponseEntity<Leave> applyLeave(@RequestBody Leave leaveRequest) {
        Leave leave = leaveService.applyLeave(
                leaveRequest.getId(),
                leaveRequest.getLeaveType(),
                leaveRequest.getReason(),
                leaveRequest.getStartDate(),
                leaveRequest.getEndDate()
        );
        return ResponseEntity.ok(leave);
    }


    @PutMapping("update/{id}")
    public ResponseEntity<Leave> updateLeaveRequest(@PathVariable Long id, @RequestBody Leave leave) {
        Leave updatedLeave = leaveService.updateLeaveRequest(id, leave);
        return ResponseEntity.ok(updatedLeave);
    }

    @DeleteMapping("delete/{leaveId}")
    public ResponseEntity<String> deleteLeave(@PathVariable Long leaveId) {
        leaveService.deleteLeave(leaveId);
        return ResponseEntity.ok("Leave deleted successfully.");
    }

    // Find a leave by ID
    @GetMapping("/find/{leaveId}")
    public ResponseEntity<Leave> getLeaveById(@PathVariable Long leaveId) {
        Optional<Leave> leave = leaveService.getLeaveById(leaveId);
        return leave.map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    // Get All Bonus record
    @GetMapping("/all")
    public ResponseEntity<List<Leave>> getAllLeave() {
        List<Leave> leaves = leaveService.findAllLeave();
        return ResponseEntity.ok(leaves);
    }

    @GetMapping("/balance/{userId}")
    public ResponseEntity<Map<LeaveType, Integer>> getUserLeaveBalance(@PathVariable Long userId) {
        Map<LeaveType, Integer> leaveBalance = leaveService.getUserLeaveBalance(userId);
        return ResponseEntity.ok(leaveBalance);
    }

    @PatchMapping("/approve/{leaveId}")
    public ResponseEntity<Leave> approveLeaveRequest(@PathVariable Long leaveId) {
        Leave approvedLeave = leaveService.approveLeaveRequest(leaveId);
        return ResponseEntity.ok(approvedLeave);
    }

    @PatchMapping("/reject/{leaveId}")
    public ResponseEntity<Leave> rejectLeaveRequest(@PathVariable Long leaveId) {
        Leave rejectedLeave = leaveService.rejectLeaveRequest(leaveId);
        return ResponseEntity.ok(rejectedLeave);
    }



    @GetMapping("/pending")
    public ResponseEntity<List<Leave>> getPendingLeaveRequests() {
        return ResponseEntity.ok(leaveService.getPendingLeaveRequests());
    }

    @GetMapping("/rejected")
    public ResponseEntity<List<Leave>> getRejectedLeaveRequests() {
        return ResponseEntity.ok(leaveService.getRejectedLeaveRequests());
    }

    @GetMapping("/user/{userId}/approved")
    public ResponseEntity<List<Leave>> getApprovedLeavesByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(leaveService.getApprovedLeavesByUser(userId));
    }

    @GetMapping("/user/{userId}/range")
    public ResponseEntity<List<Leave>> getLeavesByUserAndDateRange(
            @PathVariable Long userId,
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate) {
        return ResponseEntity.ok(leaveService.getLeavesByUserAndDateRange(userId, startDate, endDate));
    }

    @GetMapping("/type/{leaveType}")
    public ResponseEntity<List<Leave>> getLeavesByType(@PathVariable LeaveType leaveType) {
        return ResponseEntity.ok(leaveService.getLeavesByType(leaveType));
    }

    @GetMapping("/reason/{reason}")
    public ResponseEntity<List<Leave>> getLeavesByReason(@PathVariable String reason) {
        return ResponseEntity.ok(leaveService.getLeavesByReason(reason));
    }

}
