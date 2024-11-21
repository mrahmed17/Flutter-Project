package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.service.BonusService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/bonuses")
@CrossOrigin("*")
public class BonusRestController {

    @Autowired
    private BonusService bonusService;

    @PostMapping("/create")
    public ResponseEntity<Bonus> createBonus(@RequestBody Bonus bonus) {
        Bonus savedBonus = bonusService.saveBonus(bonus);
        return ResponseEntity.ok(savedBonus);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<Bonus> updateBonus(
            @PathVariable Long id,
            @RequestBody Bonus updatedBonus
    ) {
        Bonus bonus = bonusService.updateBonus(id, updatedBonus);
        return ResponseEntity.ok(bonus);
    }

    // calculateLeaveBonusDeduction
    @GetMapping("/leave/{leaveDays}")
    public double calculateLeaveBonusDeduction(@PathVariable Integer leaveDays) {
        return bonusService.calculateLeaveBonusDeduction(leaveDays);
    }

    // Get all bonuses between two dates
    @GetMapping("/between")
    public ResponseEntity<List<Bonus>> getBonusesBetweenDates(
            @RequestParam("startDate") LocalDateTime startDate,
            @RequestParam("endDate") LocalDateTime endDate
    ) {
        List<Bonus> bonuses = bonusService.getBonusesBetweenDates(startDate, endDate);
        return ResponseEntity.ok(bonuses);
    }

    // getTotalBonusForUser
    @GetMapping("/total/{userId}")
    public double getTotalBonusForUser(@PathVariable Long userId) {
        return bonusService.getTotalBonusForUser(userId);
    }


    // Get the latest bonus for a specific user
    @GetMapping("/latest/{userId}")
    public ResponseEntity<Bonus> getLatestBonusForUser(@PathVariable Long userId) {
        Bonus bonus = bonusService.getLatestBonusForUser(userId);
        return ResponseEntity.ok(bonus);
    }


}
