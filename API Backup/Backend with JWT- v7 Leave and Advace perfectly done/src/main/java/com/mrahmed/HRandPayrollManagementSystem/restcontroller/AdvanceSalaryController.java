package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.service.AdvanceSalaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/advanceSalaries")
@CrossOrigin("*")
public class AdvanceSalaryController {

    @Autowired
    private AdvanceSalaryService advanceSalaryService;

    @PostMapping("/apply")
    public ResponseEntity<AdvanceSalary> applyForAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
        System.out.println("Received request to apply for Advance Salary: " + advanceSalary);
        AdvanceSalary savedAdvanceSalary = advanceSalaryService.applyAdvanceSalary(advanceSalary);
        return ResponseEntity.ok(savedAdvanceSalary);
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<AdvanceSalary> approveAdvanceSalary(@PathVariable Long id) {
        System.out.println("Approving Advance Salary with ID: " + id);
        AdvanceSalary approvedAdvanceSalary = advanceSalaryService.approveAdvanceSalary(id);
        return ResponseEntity.ok(approvedAdvanceSalary);
    }

    @PatchMapping("/{id}/reject")
    public ResponseEntity<AdvanceSalary> getRejectedAdvanceSalary(@PathVariable Long id) {
        System.out.println("Rejecting Advance Salary with ID: " + id);
        AdvanceSalary rejectedAdvanceSalary = advanceSalaryService.getRejectedAdvanceSalary(id);
        return ResponseEntity.ok(rejectedAdvanceSalary);
    }

    @GetMapping("/pending")
    public ResponseEntity<List<AdvanceSalary>> getAllPendingAdvanceSalaries() {
        System.out.println("Fetching all pending advance salaries");
        List<AdvanceSalary> pendingAdvanceSalaries = advanceSalaryService.getAllPendingAdvanceSalary();
        return ResponseEntity.ok(pendingAdvanceSalaries);
    }

    @GetMapping("/user/{userId}/all")
    public ResponseEntity<List<AdvanceSalary>> getAllAdvanceSalariesByUser(@PathVariable Long userId) {
        System.out.println("Fetching all advance salaries for User ID: " + userId);
        List<AdvanceSalary> userAdvanceSalaries = advanceSalaryService.getAllAdvanceByUser(userId);
        return ResponseEntity.ok(userAdvanceSalaries);
    }

    @GetMapping("/all")
    public ResponseEntity<List<AdvanceSalary>> getAllAdvanceSalaries() {
        System.out.println("Fetching all advance salaries");
        List<AdvanceSalary> allAdvanceSalaries = advanceSalaryService.getAllAdvanceSalaries();
        return ResponseEntity.ok(allAdvanceSalaries);
    }

    @GetMapping("/user/{userId}/approved")
    public ResponseEntity<List<AdvanceSalary>> getApprovedAdvanceSalariesByUserId(@PathVariable Long userId) {
        System.out.println("Fetching approved advance salaries for User ID: " + userId);
        List<AdvanceSalary> approvedSalaries = advanceSalaryService.getApprovedAdvanceSalaryByUserId(userId);
        return ResponseEntity.ok(approvedSalaries);
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByStatus(@PathVariable RequestStatus status) {
        System.out.println("Fetching advance salaries by status: " + status);
        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesByStatus(status);
        return ResponseEntity.ok(advanceSalaries);
    }

    @GetMapping("/{id}")
    public ResponseEntity<AdvanceSalary> getAdvanceSalaryById(@PathVariable Long id) {
        AdvanceSalary advanceSalary = advanceSalaryService.getAdvanceSalaryById(id);
        return ResponseEntity.ok(advanceSalary);
    }

//    @GetMapping("/user/{userId}")
//    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByUserId(@PathVariable Long userId) {
//        List<AdvanceSalary> userAdvanceSalaries = advanceSalaryService.getAdvanceSalariesByUserId(userId);
//        return ResponseEntity.ok(userAdvanceSalaries);
//    }


//    @GetMapping("/user/{userId}/status/{status}")
//    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByUserAndStatus(
//            @PathVariable Long userId, @PathVariable RequestStatus status) {
//        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesByUserAndStatus(userId, status);
//        return ResponseEntity.ok(advanceSalaries);
//    }

}
