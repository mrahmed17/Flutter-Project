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

    @PostMapping("/apply/{userId}")
    public ResponseEntity<?> applyLeave(@PathVariable Long userId, @RequestBody Leave leaveRequest) {
        try {
        Leave leave = leaveService.applyLeave(
                userId,
                leaveRequest.getLeaveType(),
                leaveRequest.getReason(),
                leaveRequest.getStartDate(),
                leaveRequest.getEndDate()
        );
        return ResponseEntity.ok(leave);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateLeave(@PathVariable Long id, @RequestBody Leave leave) {
        try {
            Leave updatedLeave = leaveService.updateLeave(id, leave);
            return ResponseEntity.ok(updatedLeave);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

//    @PutMapping("/update/{id}")
//    public ResponseEntity<Leave> updateLeave(@PathVariable Long id, @RequestBody Leave leave) {
//        return ResponseEntity.ok(leaveService.updateLeave(id, leave));
//    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteLeave(@PathVariable Long id) {
        leaveService.deleteLeave(id);
        return ResponseEntity.ok("Leave deleted successfully");
    }

    @GetMapping("/pending")
    public ResponseEntity<List<Leave>> getAllPendingLeaves() {
        return ResponseEntity.ok(leaveService.getAllPendingLeaves());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Leave>> getUserLeaves(@PathVariable Long userId) {
        return ResponseEntity.ok(leaveService.getUserLeaves(userId));
    }

    @GetMapping("/user/{userId}/all")
    public ResponseEntity<List<Leave>> getAllLeavesByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(leaveService.getAllLeavesByUser(userId));
    }

    @GetMapping("/user/{userId}/range")
    public ResponseEntity<List<Leave>> getLeavesByUserAndDateRange(
            @PathVariable Long userId,
            @RequestParam LocalDate startDate,
            @RequestParam LocalDate endDate) {
        List<Leave> leaves = leaveService.getLeavesByUserAndDateRange(userId, startDate, endDate);
        return ResponseEntity.ok(leaves);
    }

    @PatchMapping("/{id}/approve")
    public ResponseEntity<Leave> approveLeave(@PathVariable Long id) {
        return ResponseEntity.ok(leaveService.approveLeave(id));
    }

    @PatchMapping("/{id}/reject")
    public ResponseEntity<Leave> rejectLeave(@PathVariable Long id) {
        return ResponseEntity.ok(leaveService.rejectLeave(id));
    }

}
