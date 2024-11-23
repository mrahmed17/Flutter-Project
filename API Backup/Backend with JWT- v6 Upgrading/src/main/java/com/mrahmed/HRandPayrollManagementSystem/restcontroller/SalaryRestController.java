package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
import com.mrahmed.HRandPayrollManagementSystem.service.SalaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/salaries")
@CrossOrigin(origins = "*")
public class SalaryRestController {

    @Autowired
    private SalaryService salaryService;

    @PostMapping("/create")
    public ResponseEntity<Salary> createSalary(@RequestBody Salary salaryRequest) {
        // Validate user existence
        if (salaryRequest.getUser() == null || salaryRequest.getUser().getId() == null) {
            throw new RuntimeException("User ID must be provided to calculate salary.");
        }

        // Calculate the salary for the given user
        double calculatedNetSalary = salaryService.calculateSalary(salaryRequest.getUser().getId());

        // Set the calculated net salary and other details
        salaryRequest.setNetSalary(calculatedNetSalary);
        salaryRequest.setPaymentDate(LocalDateTime.now()); // Set the payment date to now
        salaryRequest.setSalaryStatus("PENDING"); // Default status

        // Save the salary entity
        Salary createdSalary = salaryService.saveSalary(salaryRequest);
        return new ResponseEntity<>(createdSalary, HttpStatus.CREATED);
    }

//
//    @GetMapping("/latest/{userId}")
//    public ResponseEntity<Salary> getLatestSalary(@PathVariable Long userId) {
//        Salary salary = salaryService.getLatestSalaryForUser(userId)
//                .orElseThrow(() -> new RuntimeException("No salary record found for user ID: " + userId));
//        return ResponseEntity.ok(salary);
//    }

    @PutMapping("/update/{salaryId}")
    public ResponseEntity<Salary> updateSalary(
            @PathVariable Long salaryId,
            @RequestBody Salary salary) {
        Salary updatedSalary = salaryService.updateSalary(salaryId, salary);
        return ResponseEntity.ok(updatedSalary);
    }


    @DeleteMapping("/delete/{salaryId}")
    public ResponseEntity<Void> deleteSalary(@PathVariable Long salaryId) {
        salaryService.deleteSalary(salaryId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/find/{salaryId}")
    public ResponseEntity<Salary> getSalaryById(@PathVariable Long salaryId) {
        Salary salary = salaryService.getSalaryById(salaryId);
        return ResponseEntity.ok(salary);
    }

    @GetMapping("/all")
    public ResponseEntity<List<Salary>> getAllSalaries() {
        List<Salary> salaries = salaryService.getAllSalaries();
        return ResponseEntity.ok(salaries);
    }

    @GetMapping("/status")
    public ResponseEntity<List<Salary>> getSalariesByStatus(@RequestParam String status) {
        List<Salary> salaries = salaryService.getSalariesByStatus(status);
        return ResponseEntity.ok(salaries);
    }
//
//    @GetMapping("/dateRange")
//    public ResponseEntity<List<Salary>> getSalariesByDateRange(
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
//        List<Salary> salaries = salaryService.getSalariesByDateRange(startDate, endDate);
//        return ResponseEntity.ok(salaries);
//    }

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<String> handleRuntimeException(RuntimeException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
    }

}
