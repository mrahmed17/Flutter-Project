package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.service.AdvanceSalaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/advanceSalaries")
@CrossOrigin("*")
public class AdvanceSalaryController {

    @Autowired
    private AdvanceSalaryService advanceSalaryService;

    // Apply for advance salary
    @PostMapping("/apply")
    public ResponseEntity<AdvanceSalary> applyForAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
        try {
            AdvanceSalary savedAdvanceSalary = advanceSalaryService.applyAdvanceSalary(advanceSalary);
            return ResponseEntity.ok(savedAdvanceSalary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateAdvanceSalary(@PathVariable Long id, @RequestBody AdvanceSalary advanceSalary) {
        try {
            advanceSalary.setId(id);
            AdvanceSalary updatedAdvanceSalary = advanceSalaryService.updateAdvanceSalary(advanceSalary);
            return ResponseEntity.ok(updatedAdvanceSalary);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }


    // Delete an advance salary record by ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteAdvanceSalary(@PathVariable Long id) {
        try {
            advanceSalaryService.deleteAdvanceSalary(id);
            return ResponseEntity.noContent().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Approve advance salary
    @PutMapping("/approve/{id}")
    public ResponseEntity<AdvanceSalary> approveAdvanceSalary(@PathVariable Long id) {
        try {
            AdvanceSalary approvedAdvanceSalary = advanceSalaryService.approveAdvanceSalary(id);
            return ResponseEntity.ok(approvedAdvanceSalary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    // Get an advance salary record by ID
    @GetMapping("/find/{id}")
    public ResponseEntity<AdvanceSalary> getAdvanceSalaryById(@PathVariable Long id) {
        try {
            AdvanceSalary advanceSalary = advanceSalaryService.getAdvanceSalaryById(id);
            return ResponseEntity.ok(advanceSalary);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build(); // Return not found if ID doesn't exist
        }
    }

    // Get advance salaries for a user
    @GetMapping("/all")
    public ResponseEntity<List<AdvanceSalary>> getAllAdvanceSalaries() {
        List<AdvanceSalary> advanceSalaries = advanceSalaryService.findAllAdvanceSalary();
        return ResponseEntity.ok(advanceSalaries);
    }

//    // Get approved advance salary records for a user
//    @GetMapping("/user/{userId}/latest")
//    public ResponseEntity<List<AdvanceSalary>> getLatestAdvanceSalaries(@PathVariable Long userId) {
//        List<AdvanceSalary> latestAdvances = advanceSalaryService.findTop5ByUserIdOrderByAdvanceDateDesc(userId).getContent();
//        return new ResponseEntity<>(latestAdvances, HttpStatus.OK);
//    }

    // getAdvanceSalariesStatus
    @GetMapping("/status/{userId}")
    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesStatus(@PathVariable Long userId) {
        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesStatus(userId);
        return ResponseEntity.ok(advanceSalaries);
    }

//    // Get advance salaries within a specific date range
//    @GetMapping("/date-range")
//    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByDateRange(
//            @RequestParam LocalDateTime startDate,
//            @RequestParam LocalDateTime endDate) {
//        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesByDateRange(startDate, endDate);
//        return ResponseEntity.ok(advanceSalaries);
//    }

    // Get pending salary requests
    @GetMapping("/pending")
    public ResponseEntity<List<AdvanceSalary>> getPendingSalaryRequests() {
        List<AdvanceSalary> pendingSalaries = advanceSalaryService.getPendingSalaryRequests();
        return ResponseEntity.ok(pendingSalaries);
    }

    // Get rejected salary requests
    @GetMapping("/rejected")
    public ResponseEntity<List<AdvanceSalary>> getRejectedSalaryRequests() {
        List<AdvanceSalary> rejectedSalaries = advanceSalaryService.getRejectedSalaryRequests();
        return ResponseEntity.ok(rejectedSalaries);
    }

    // Get approved salary records for a specific user
    @GetMapping("/approved/user/{id}")
    public ResponseEntity<List<AdvanceSalary>> getApprovedSalaryByUser (@PathVariable Long id) {
        List<AdvanceSalary> approvedSalaries = advanceSalaryService.getApprovedSalaryByUser (id);
        return ResponseEntity.ok(approvedSalaries);
    }

//    @GetMapping("/userDate-range/{id}")
//    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalaryByUserAndDateRange(
//            @PathVariable Long id,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
//
//        List<AdvanceSalary> advanceSalaries =
//                advanceSalaryService.getAdvanceSalaryByUserAndDateRange(id, startDate, endDate);
//        return ResponseEntity.ok(advanceSalaries);
//    }

}
