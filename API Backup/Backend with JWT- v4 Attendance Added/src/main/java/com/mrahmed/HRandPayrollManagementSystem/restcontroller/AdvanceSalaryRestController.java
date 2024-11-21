//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
//import com.mrahmed.HRandPayrollManagementSystem.service.AdvanceSalaryService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.math.BigDecimal;
//import java.time.LocalDateTime;
//import java.util.List;
//import java.util.Optional;
//
//@RestController
//@RequestMapping("/api/advanceSalaries")
//@CrossOrigin("*")
//public class AdvanceSalaryRestController {
//
//    @Autowired
//    private AdvanceSalaryService advanceSalaryService;
//
//    // Create a new advance salary record
//
//    @PostMapping("/create")
//    public ResponseEntity<?> createAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
//        try {
//            AdvanceSalary savedAdvanceSalary = advanceSalaryService.saveAdvanceSalary(advanceSalary);
//            return ResponseEntity.ok(savedAdvanceSalary);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An unexpected error occurred");
//        }
//    }
//
//    // Update an existing advance salary record
//    @PutMapping("/update/{id}")
//    public ResponseEntity<AdvanceSalary> updateAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
//        try {
//            AdvanceSalary updatedAdvanceSalary = advanceSalaryService.updateAdvanceSalary(advanceSalary);
//            return ResponseEntity.ok(updatedAdvanceSalary);
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.notFound().build();
//        }
//    }
//
//    // Delete an advance salary record by ID
//    @DeleteMapping("/delete/{id}")
//    public ResponseEntity<Void> deleteAdvanceSalary(@PathVariable Long id) {
//        try {
//            advanceSalaryService.deleteAdvanceSalary(id);
//            return ResponseEntity.noContent().build();
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.notFound().build();
//        }
//    }
//
//    // Get an advance salary record by ID
//    @GetMapping("/find/{id}")
//    public ResponseEntity<AdvanceSalary> getAdvanceSalaryById(@PathVariable Long id) {
//        Optional<AdvanceSalary> advanceSalary = advanceSalaryService.getAdvanceSalaryById(id);
//        return advanceSalary.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
//    }
//
//
//    // Get advance salaries within a specific date range
//    @GetMapping("/date-range")
//    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByDateRange(
//            @RequestParam LocalDateTime startDate,
//            @RequestParam LocalDateTime endDate) {
//        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesByDateRange(startDate, endDate);
//        return ResponseEntity.ok(advanceSalaries);
//    }
//
//
//    // Get the latest advance salary record for a user
//    @GetMapping("/latest/user/{userId}")
//    public ResponseEntity<List<AdvanceSalary>> getLatestAdvanceSalaryByUser(@PathVariable Long userId) {
//        List<AdvanceSalary> latestAdvanceSalaries = advanceSalaryService.getLatestAdvanceSalaryByUser(userId);
//        return ResponseEntity.ok(latestAdvanceSalaries);
//    }
//
//}
