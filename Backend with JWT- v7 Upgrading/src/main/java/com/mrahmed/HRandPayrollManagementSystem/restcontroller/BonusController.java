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

    // Create a new Bonus
    @PostMapping("/create")
    public ResponseEntity<Bonus> createBonus(@RequestBody Bonus bonus) {
        return ResponseEntity.ok(bonusService.saveBonus(bonus));
    }

    // Update a Bonus
    @PutMapping("/update/{id}")
    public ResponseEntity<Bonus> updateBonus(@PathVariable Long id, @RequestBody Bonus updatedBonus) {
        return ResponseEntity.ok(bonusService.updateBonus(id, updatedBonus));
    }

    // Delete a Bonus
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteBonus(@PathVariable Long id) {
        bonusService.deleteBonus(id);
        return ResponseEntity.ok("Bonus deleted successfully.");
    }

    // Get Bonus by ID
    @GetMapping("/find/{id}")
    public ResponseEntity<Bonus> getBonusById(@PathVariable Long id) {
        return ResponseEntity.ok(bonusService.getBonusById(id));
    }

    // Get all Bonuses
    @GetMapping("/all")
    public ResponseEntity<List<Bonus>> getAllBonuses() {
        return ResponseEntity.ok(bonusService.findAllBonuses());
    }

    // Get total bonus for a user
    @GetMapping("/total/user/{userId}")
    public ResponseEntity<Double> getTotalBonusForUser(@PathVariable Long userId) {
        return ResponseEntity.ok(bonusService.getTotalBonusForUser(userId));
    }

    // Get bonuses between two dates
    @GetMapping("/between")
    public ResponseEntity<List<Bonus>> getBonusesBetweenDates(
            @RequestParam("startDate") String startDateStr,
            @RequestParam("endDate") String endDateStr) {
        LocalDateTime startDate = LocalDateTime.parse(startDateStr);
        LocalDateTime endDate = LocalDateTime.parse(endDateStr);
        return ResponseEntity.ok(bonusService.getBonusesBetweenDates(startDate, endDate));
    }

    // Get total bonus for a specific month and year
    @GetMapping("/monthly/{month}/{year}")
    public ResponseEntity<Double> getTotalBonusForMonth(@PathVariable int month, @PathVariable int year) {
        return ResponseEntity.ok(bonusService.getTotalBonusForMonth(month, year));
    }

    // Count bonuses for a user in a specific year
    @GetMapping("/count/user/{userId}/year/{year}")
    public ResponseEntity<Long> countBonusesForUserInYear(@PathVariable Long userId, @PathVariable int year) {
        return ResponseEntity.ok(bonusService.countBonusesForUserInYear(userId, year));
    }

}
