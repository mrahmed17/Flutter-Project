package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.repository.BonusRepository;
import com.mrahmed.HRandPayrollManagementSystem.service.BonusService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
    @Autowired
    private BonusRepository bonusRepository;

    // Create a new Bonus
    @PostMapping("/create")
    public ResponseEntity<Bonus> createBonus(@RequestBody Bonus bonus) {
        try {
            return ResponseEntity.ok(bonusService.saveBonus(bonus));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    // Update a Bonus
    @PutMapping("/update/{id}")
    public ResponseEntity<Bonus> updateBonus(@PathVariable Long id, @RequestBody Bonus updatedBonus) {
        try {
            return ResponseEntity.ok(bonusService.updateBonus(id, updatedBonus));
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    // Delete a Bonus
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteBonus(@PathVariable Long id) {
        try {
            bonusService.deleteBonus(id);
            return ResponseEntity.ok("Bonus deleted successfully.");
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Bonus not found.");
        }
    }

    // Get Bonus by ID
    @GetMapping("/find/{id}")
    public ResponseEntity<Bonus> getBonusById(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(bonusService.getBonusById(id));
        } catch (RuntimeException ex) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }

    // Get all Bonuses
    @GetMapping("/all")
    public ResponseEntity<List<Bonus>> getAllBonuses(@RequestParam(defaultValue = "0") int page,
                                                     @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(bonusRepository.findAll(pageable).getContent());
    }

    // Get total bonus for a user
    @GetMapping("/total/user/{userId}")
    public ResponseEntity<Double> getTotalBonusForUser(@PathVariable Long userId) {
        return ResponseEntity.ok(bonusService.getTotalBonusForUser(userId));
    }

    // Get bonuses between two dates
    @GetMapping("/between")
    public ResponseEntity<?> getBonusesBetweenDates(
            @RequestParam("startDate") String startDateStr,
            @RequestParam("endDate") String endDateStr) {
        try {
            LocalDateTime startDate = LocalDateTime.parse(startDateStr);
            LocalDateTime endDate = LocalDateTime.parse(endDateStr);
            return ResponseEntity.ok(bonusService.getBonusesBetweenDates(startDate, endDate));
        } catch (DateTimeParseException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("Invalid date format. Please use the correct format: yyyy-MM-ddTHH:mm:ss.");
        }
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

    // Get bonuses for a user (by User ID)
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Bonus>> getBonusesByUser(@PathVariable Long userId) {
        List<Bonus> bonuses = bonusRepository.findBonusesByUserId(userId);
        if (bonuses.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
        return ResponseEntity.ok(bonuses);
    }

}
