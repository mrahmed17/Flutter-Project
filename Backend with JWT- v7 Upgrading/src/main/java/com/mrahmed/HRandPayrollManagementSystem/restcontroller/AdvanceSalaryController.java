package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.service.AdvanceSalaryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/advanceSalaries")
@CrossOrigin("*")
public class AdvanceSalaryController {
    @Autowired
    private AdvanceSalaryService advanceSalaryService;

    @PostMapping("/apply")
    public ResponseEntity<AdvanceSalary> applyForAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
        return ResponseEntity.ok(advanceSalaryService.applyAdvanceSalary(advanceSalary));
    }

    @PostMapping("/update")
    public ResponseEntity<AdvanceSalary> saveAdvanceSalary(@RequestBody AdvanceSalary advanceSalary) {
        AdvanceSalary savedAdvanceSalary = advanceSalaryService.updateAdvanceSalary(advanceSalary);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedAdvanceSalary);
    }

    // Delete AdvanceSalary by ID
//    @DeleteMapping("/delete/{id}")
//    public ResponseEntity<Void> deleteAdvanceSalary(@PathVariable Long id) {
//        advanceSalaryService.deleteAdvanceSalary(id);
//        return ResponseEntity.noContent().build();
//    }
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteAdvanceSalary(@PathVariable Long id) {
        advanceSalaryService.deleteAdvanceSalary(id);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Message", "AdvanceSalary Deleted Successfully");
        return ResponseEntity.noContent().headers(headers).build();
    }


    @PutMapping("/approve/{id}")
    public ResponseEntity<AdvanceSalary> approveAdvanceSalary(@PathVariable Long id) {
        return ResponseEntity.ok(advanceSalaryService.approveAdvanceSalary(id));
    }

    @GetMapping("/find/{id}")
    public ResponseEntity<AdvanceSalary> getAdvanceSalaryById(@PathVariable Long id) {
        AdvanceSalary advanceSalary = advanceSalaryService.getAdvanceSalaryById(id);
        return ResponseEntity.ok(advanceSalary);
    }

    @GetMapping("/all")
    public ResponseEntity<List<AdvanceSalary>> getAllAdvanceSalaries() {
        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAllAdvanceSalaries();
        return ResponseEntity.ok(advanceSalaries);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByUserId(@PathVariable Long userId) {
        List<AdvanceSalary> advanceSalaries = advanceSalaryService.getAdvanceSalariesByUserId(userId);
        return ResponseEntity.ok(advanceSalaries);
    }

    @GetMapping("/approved/{userId}")
    public ResponseEntity<Optional<AdvanceSalary>> getApprovedAdvanceSalaryByUserId(@PathVariable Long userId){
        return ResponseEntity.ok(advanceSalaryService.getApprovedAdvanceSalaryByUserId(userId));
    }


    @GetMapping("/user/{userId}/status/{status}")
    public ResponseEntity<Optional<AdvanceSalary>> getAdvanceSalariesByUserAndStatus(
            @PathVariable Long userId, @PathVariable RequestStatus status) {
        return ResponseEntity.ok(advanceSalaryService.getAdvanceSalariesByUserAndStatus(userId, status));
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<AdvanceSalary>> getAdvanceSalariesByStatus(@PathVariable RequestStatus status) {
        return ResponseEntity.ok(advanceSalaryService.getAdvanceSalariesByStatus(status));
    }

}
