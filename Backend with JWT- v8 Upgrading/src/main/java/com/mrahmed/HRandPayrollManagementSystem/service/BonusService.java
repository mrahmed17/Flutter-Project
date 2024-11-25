package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.entity.BonusType;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.BonusRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
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

    @Autowired
    private UserRepository userRepository;

    // Refactored to use enum-based validation
    private boolean isValidBonusType(BonusType bonusType) {
        return bonusType != null; // Enum ensures all types are valid
    }

    // Create a new Bonus
    public Bonus saveBonus(Bonus bonus) {
        if (!isValidBonusType(bonus.getBonusType())) {
            throw new IllegalArgumentException("Invalid bonus type.");
        }

        User user = userRepository.findById(bonus.getUser().getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + bonus.getUser().getId()));
        bonus.setBonusDate(LocalDateTime.now());  // Automatically set the date for creation
        bonus.setUser(user);
        return bonusRepository.save(bonus);
    }

    // Update an existing Bonus
    public Bonus updateBonus(Long id, Bonus updatedBonus) {
        Optional<Bonus> existingBonus = bonusRepository.findById(id);
        if (existingBonus.isPresent()) {
            Bonus bonus = existingBonus.get();
            bonus.setBonusAmount(updatedBonus.getBonusAmount());
            bonus.setBonusDate(LocalDateTime.now());  // Automatically update the date
            return bonusRepository.save(bonus);
        } else {
            throw new RuntimeException("Bonus not found with ID: " + id);
        }
    }

    // Delete a Bonus
    public void deleteBonus(Long id) {
        if (bonusRepository.existsById(id)) {
            bonusRepository.deleteById(id);
        } else {
            throw new RuntimeException("Bonus not found with ID: " + id);
        }
    }

    // Get Bonus by ID
    public Bonus getBonusById(Long id) {
        return bonusRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bonus not found with ID: " + id));
    }

    // Get total bonus for a user
    public double getTotalBonusForUser(Long userId) {
        return bonusRepository.getTotalBonusForUser(userId);
    }

    // Get bonuses between two dates
    public List<Bonus> getBonusesBetweenDates(LocalDateTime startDate, LocalDateTime endDate) {
        return bonusRepository.getBonusesBetweenDates(startDate, endDate);
    }

    // Get total bonus for a specific month and year
    public double getTotalBonusForMonth(int month, int year) {
        return bonusRepository.getTotalBonusForMonth(month, year);
    }

    // Count bonuses for a user in a specific year
    public long countBonusesForUserInYear(Long userId, int year) {
        return bonusRepository.countBonusesForUserInYear(userId, year);
    }

    private boolean isValidBonusType(String bonusType) {
        return "Performance".equalsIgnoreCase(bonusType) || "Annual".equalsIgnoreCase(bonusType)
                || "Festival".equalsIgnoreCase(bonusType) || "Promotional".equalsIgnoreCase(bonusType);
    }

}
