package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.repository.BonusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class BonusService {
    @Autowired
    private BonusRepository bonusRepository;

    public Bonus saveBonus(Bonus bonus) {
        // Optional: Validate bonus type before saving (e.g., "Performance", "Annual", etc.)
        if (!isValidBonusType(bonus.getBonusType())) {
            throw new IllegalArgumentException("Invalid bonus type.");
        }
        return bonusRepository.save(bonus);
    }

    public Bonus updateBonus(Long id, Bonus updatedBonus) {
        if (bonusRepository.existsById(id)) {
            updatedBonus.setId(id); // Ensure the ID is set for the update
            return bonusRepository.save(updatedBonus);
        } else {
            throw new RuntimeException("Bonus not found with id " + id);
        }
    }

    public void deleteBonus(Long id) {
        Optional<Bonus> bonus = bonusRepository.findById(id);
        if (bonus.isPresent()) {
            bonusRepository.delete(bonus.get());
        } else {
            throw new RuntimeException("Bonus not found with id " + id);
        }
    }

    // Find Bonus records by id
    public Bonus getBonusById(Long id) {
        return bonusRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bonus not found with ID: " + id));
    }

    // Find all Bonus records
    public List<Bonus> findAllBonus() {
        return bonusRepository.findAll();
    }

    // Deduction logic for unpaid leave days
    public double calculateLeaveBonusDeduction(int totalUnpaidLeaveDays) {
        double deductionPerDay = 100.0; // Example deduction value
        return deductionPerDay * totalUnpaidLeaveDays;
    }

    // Get bonuses between a date range
    public List<Bonus> getBonusesBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return bonusRepository.getBonusesBetweenDates(startDate, endDate);
    }

    // Get total bonus for a specific user
    public double getTotalBonusForUser(Long userId) {
        return bonusRepository.getTotalBonusForUser(userId);
    }

    // Get the latest bonus for a specific user
    public Bonus getLatestBonusForUser(Long userId) {
        Pageable pageable = PageRequest.of(0, 1);  // Get the latest bonus
        List<Bonus> bonuses = bonusRepository.getLatestBonusForUser(userId, pageable);
        return bonuses.isEmpty() ? null : bonuses.get(0);
    }

    // Get total bonus for a specific month and year
    public double getTotalBonusForMonth(int month, int year) {
        return bonusRepository.getTotalBonusForMonth(month, year);
    }

    private boolean isValidBonusType(String bonusType) {
        // Add bonus type validation logic here (e.g., Performance, Annual, etc.)
        return "Performance".equalsIgnoreCase(bonusType) || "Annual".equalsIgnoreCase(bonusType)
                || "Festival".equalsIgnoreCase(bonusType) || "Promotional".equalsIgnoreCase(bonusType);
    }

//    getTotalBonusInMonth

//    countBonusesForUserInYear


}
