package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.service.BonusService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@RestController
@RequestMapping("/api/bonuses")
@CrossOrigin("*")
public class BonusController {

    @Autowired
    private BonusService bonusService;

    @PostMapping("/create")
    public ResponseEntity<?> createBonus(@RequestBody Bonus bonus) {
        try {
            Bonus savedBonus = bonusService.saveBonus(bonus);
            return ResponseEntity.ok(savedBonus);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }


//    @PostMapping("/create")
//    public ResponseEntity<Bonus> createBonus(@RequestBody Bonus bonus) {
//        Bonus savedBonus = bonusService.saveBonus(bonus);
//        return ResponseEntity.ok(savedBonus);
//    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateBonus(@PathVariable Long id, @RequestBody Bonus updatedBonus) {
        try {
            Bonus savedBonus = bonusService.updateBonus(id, updatedBonus);
            return ResponseEntity.ok(savedBonus);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Bonus with ID " + id + " not found.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }


    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteBonus(@PathVariable Long id) {
        try {
            bonusService.deleteBonus(id);
            return ResponseEntity.ok().build();
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Bonus with ID " + id + " not found.");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
        }
    }

    // Get an Bonus record by ID
    @GetMapping("/find/{id}")
    public ResponseEntity<Bonus> getAdvanceSalaryById(@PathVariable Long id) {
        try {
            Bonus bonus = bonusService.getBonusById(id);
            return ResponseEntity.ok(bonus);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Get All Bonus record
    @GetMapping("/all")
    public ResponseEntity<List<Bonus>> getAllAdvanceSalaries() {
        List<Bonus> bonuses = bonusService.findAllBonus();
        return ResponseEntity.ok(bonuses);
    }


    // Calculate the leave deduction for the bonus
    @GetMapping("/leave/{leaveDays}")
    public ResponseEntity<Double> calculateLeaveBonusDeduction(@PathVariable Integer leaveDays) {
        double deduction = bonusService.calculateLeaveBonusDeduction(leaveDays);
        return ResponseEntity.ok(deduction);
    }

    @GetMapping("/between")
    public ResponseEntity<List<Bonus>> getBonusesBetweenDates(@RequestParam("startDate") String startDateStr,
                                                              @RequestParam("endDate") String endDateStr) {
        try {
            LocalDateTime startDate = LocalDateTime.parse(startDateStr);
            LocalDateTime endDate = LocalDateTime.parse(endDateStr);
            List<Bonus> bonuses = bonusService.getBonusesBetweenDates(startDate, endDate);
            return ResponseEntity.ok(bonuses);
        } catch (DateTimeParseException e) {
            return ResponseEntity.badRequest().body(List.of());
        }
    }

    // Get total bonus for a user
    @GetMapping("/total/{userId}")
    public ResponseEntity<Double> getTotalBonusForUser(@PathVariable Long userId) {
        double totalBonus = bonusService.getTotalBonusForUser(userId);
        return ResponseEntity.ok(totalBonus);
    }

    // Get the latest bonus for a user
    @GetMapping("/latest/{userId}")
    public ResponseEntity<Bonus> getLatestBonusForUser(@PathVariable Long userId) {
        Bonus bonus = bonusService.getLatestBonusForUser(userId);
        return bonus != null ? ResponseEntity.ok(bonus) : ResponseEntity.notFound().build();
    }

    // Get the total bonus for a specific month and year
    @GetMapping("/monthly/{month}/{year}")
    public ResponseEntity<Double> getTotalBonusForMonth(@PathVariable int month, @PathVariable int year) {
        double totalBonus = bonusService.getTotalBonusForMonth(month, year);
        return ResponseEntity.ok(totalBonus);
    }


}
