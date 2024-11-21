package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.repository.BonusRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class BonusService {
    @Autowired
    private BonusRepository bonusRepository;

    public Bonus saveBonus(Bonus bonus) {
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

    // Deduction logic for unpaid leave days
    public double calculateLeaveBonusDeduction(int totalUnpaidLeaveDays) {
        double deductionPerDay = 50.0;
        return deductionPerDay * totalUnpaidLeaveDays;
    }

    // Get bonuses between a date range
    public List<Bonus> getBonusesBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return bonusRepository.getBonusesBetweenDates(startDate, endDate);
    }

    //getTotalBonusForUser
    public double getTotalBonusForUser(Long userId) {
        return bonusRepository.getTotalBonusForUser(userId);
    }

    // Get the latest bonus for a user
    public Bonus getLatestBonusForUser(Long userId) {
        Pageable pageable = PageRequest.of(0, 1);  // Get the latest bonus
        List<Bonus> bonuses = bonusRepository.getLatestBonusForUser(userId, pageable);
        return bonuses.isEmpty() ? null : bonuses.get(0);  // Return the first bonus or null if not found
    }

}
