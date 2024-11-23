package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
import com.mrahmed.HRandPayrollManagementSystem.service.SalaryService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @PostMapping("/calculate/{userId}")
    public ResponseEntity<Salary> calculateAndSaveSalary(@PathVariable Long userId) {
        try {
            // Calculate salary
            Salary salary = salaryService.calculateSalary(userId);

            // Save the calculated salary
            salary = salaryService.saveSalary(salary);

            return ResponseEntity.ok(salary);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

//    @PostMapping("/calculate/{userId}")
//    public ResponseEntity<Salary> calculateSalary(@PathVariable Long userId) {
//        try {
//            Salary salary = salaryService.calculateSalary(userId);
//            return ResponseEntity.ok(salary);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
//        }
//    }

//    @PostMapping("/calculate/{userId}")
//    public ResponseEntity<Salary> calculateAndSaveSalary(@PathVariable Long userId) {
//        Salary salary = new Salary();
//        salary.setPaymentDate(LocalDateTime.now());
//        double netSalary = salaryService.calculateSalary(userId);
//        salary.setNetSalary(netSalary);
//        salary.setTax(netSalary * 0.05);
//        salary.setProvidentFund(netSalary * 0.02);
//
//        Salary savedSalary = salaryService.saveSalary(salary);
//        return new ResponseEntity<>(savedSalary, HttpStatus.CREATED);
//    }

    @GetMapping("/find/{id}")
    public ResponseEntity<Salary> getSalaryById(@PathVariable Long id) {
        return salaryService.getSalaryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/all")
    public ResponseEntity<List<Salary>> getAllSalaries() {
        return ResponseEntity.ok(salaryService.getAllSalaries());
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Salary> updateSalary(@PathVariable Long id, @RequestBody Salary salary) {
        try {
            Salary updatedSalary = salaryService.updateSalary(id, salary);
            return ResponseEntity.ok(updatedSalary);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteSalary(@PathVariable Long id) {
        try {
            salaryService.deleteSalary(id);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("/status")
    public ResponseEntity<List<Salary>> getSalariesByStatus(@RequestParam RequestStatus status) {
        return ResponseEntity.ok(salaryService.getSalariesByStatus(status));
    }

    @GetMapping("/user/{userId}/range")
    public ResponseEntity<List<Salary>> getSalariesByUserAndDateRange(
            @PathVariable Long userId,
            @RequestParam LocalDateTime startDate,
            @RequestParam LocalDateTime endDate) {
        return ResponseEntity.ok(salaryService.getSalariesByUserAndDateRange(userId, startDate, endDate));
    }

    @GetMapping("/date-range")
    public ResponseEntity<List<Salary>> getSalariesByDateRange(
            @RequestParam LocalDateTime startDate,
            @RequestParam LocalDateTime endDate) {
        return ResponseEntity.ok(salaryService.getSalariesByDateRange(startDate, endDate));
    }


}
