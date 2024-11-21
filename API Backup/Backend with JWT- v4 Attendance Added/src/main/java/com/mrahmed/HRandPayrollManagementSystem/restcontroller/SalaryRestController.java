//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
//import com.mrahmed.HRandPayrollManagementSystem.service.SalaryService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.format.annotation.DateTimeFormat;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/salaries")
//@CrossOrigin("*")
//public class SalaryRestController {
//
//
//    @Autowired
//    private SalaryService salaryService;
//
//    @PostMapping("/create")
//    public ResponseEntity<Salary> createSalary(@RequestBody Salary salary) {
//        Salary createdSalary = salaryService.saveSalary(salary);
//        return ResponseEntity.ok(createdSalary);
//    }
//
//    @PutMapping("/update/{salaryId}")
//    public ResponseEntity<Salary> updateSalary(@PathVariable Long salaryId,
//                                               @RequestBody Salary salary) {
//        Salary updatedSalary = salaryService.updateSalary(salaryId, salary);
//        return ResponseEntity.ok(updatedSalary);
//    }
//
//
//    @DeleteMapping("/delete/{salaryId}")
//    public ResponseEntity<Void> deleteSalary(@PathVariable Long salaryId) {
//        salaryService.deleteSalary(salaryId);
//        return ResponseEntity.noContent().build();
//    }
//
//    @GetMapping("/find/{salaryId}")
//    public ResponseEntity<Salary> getSalaryById(@PathVariable Long salaryId) {
//        Salary salary = salaryService.getSalaryById(salaryId);
//        return ResponseEntity.ok(salary);
//    }
//
//    @GetMapping("/range")
//    public ResponseEntity<List<Salary>> getSalariesByDateRange(
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
//        List<Salary> salaries = salaryService.getSalariesByDateRange(startDate, endDate);
//        return ResponseEntity.ok(salaries);
//    }
//
//    // Get the latest salary record for a specific user
//    @GetMapping("/latest/{userId}")
//    public ResponseEntity<List<Salary>> getLatestSalaryByUser(@PathVariable Long userId) {
//        List<Salary> latestSalaries = salaryService.getLatestSalaryByUser(userId);
//        return ResponseEntity.ok(latestSalaries);
//    }
//
//    // Get total overtime hours in a specific period for a user
//    @GetMapping("/overtime/range")
//    public ResponseEntity<Double> getTotalOvertimeHoursByDateRange(
//            @RequestParam Long userId,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
//        double totalOvertime = salaryService.getTotalOvertimeHoursByDateRange(userId, startDate, endDate);
//        return ResponseEntity.ok(totalOvertime);
//    }
//
//    // Get total overtime hours for a specific user across all dates
//    @GetMapping("/overtime/user/{userId}")
//    public ResponseEntity<Double> getTotalOvertimeHoursByUser(@PathVariable Long userId) {
//        double totalOvertime = salaryService.getTotalOvertimeHoursByUser(userId);
//        return ResponseEntity.ok(totalOvertime);
//    }
//
//    // Calculate total overtime hours based on working hours within a date range
//    @GetMapping("/overtime/range-and-hours")
//    public ResponseEntity<Double> getTotalOvertimeHoursByDateRangeAndWorkingHours(
//            @RequestParam Long userId,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startTime,
//            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endTime) {
//        double totalOvertime = salaryService.getTotalOvertimeHoursByDateRangeAndWorkingHours(userId, startDate, endDate, startTime, endTime);
//        return ResponseEntity.ok(totalOvertime);
//    }
//
//
//}
