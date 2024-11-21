package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.repository.AdvanceSalaryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AdvanceSalaryService {

    @Autowired
    private AdvanceSalaryRepository advanceSalaryRepository;

    // Save new advance salary record
    public AdvanceSalary saveAdvanceSalary(AdvanceSalary advanceSalary) {
        return advanceSalaryRepository.save(advanceSalary);
    }

    // Update existing advance salary record
    public AdvanceSalary updateAdvanceSalary(AdvanceSalary advanceSalary) {
        if (advanceSalary.getId() != 0 && advanceSalaryRepository.existsById(advanceSalary.getId())) {
            return advanceSalaryRepository.save(advanceSalary);
        }
        throw new IllegalArgumentException("AdvanceSalary with ID " + advanceSalary.getId() + " does not exist.");
    }

    // Delete advance salary record by ID
    public void deleteAdvanceSalary(Long id) {
        if (advanceSalaryRepository.existsById(id)) {
            advanceSalaryRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("AdvanceSalary with ID " + id + " does not exist.");
        }
    }

//    // Find advance salary record by ID
//    public Optional<AdvanceSalary> getAdvanceSalaryById(Long id) {
//        return advanceSalaryRepository.findById(id);
//    }

    // Method to find an advance salary record by its ID
    public AdvanceSalary getAdvanceSalaryById(Long id) {
        Optional<AdvanceSalary> advanceSalaryOptional = advanceSalaryRepository.findById(id);
        if (advanceSalaryOptional.isPresent()) {
            return advanceSalaryOptional.get();
        } else {
            throw new IllegalArgumentException("AdvanceSalary with ID " + id + " not found.");
        }
    }

    // Find advance salaries within a specific date range
    public List<AdvanceSalary> getAdvanceSalariesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return advanceSalaryRepository.findByDateRange(startDate, endDate);
    }

    // Find latest advance salary record for a user
    public List<AdvanceSalary> findTop5ByUserIdOrderByAdvanceDateDesc(Long userId) {
        return advanceSalaryRepository.findTop5ByUserIdOrderByAdvanceDateDesc(userId);
    }

    // Find all advance salary records for a specific user ID
    public List<AdvanceSalary> findAllByUserId(Long userId) {
        return advanceSalaryRepository.findByUserId(userId);
    }

    // Find pending salary requests
    public List<AdvanceSalary> getPendingSalaryRequests() {
        return advanceSalaryRepository.findPendingSalaryRequests();
    }

    // Find rejected salary requests
    public List<AdvanceSalary> getRejectedSalaryRequests() {
        return advanceSalaryRepository.findRejectedSalaryRequests();
    }

    // Find approved salary records for a specific user
    public List<AdvanceSalary> getApprovedSalaryByUser (Long userId) {
        return advanceSalaryRepository.findApprovedSalaryByUser (userId);
    }

    // Find advance salary records for a specific user within a date range
    public List<AdvanceSalary> getAdvanceSalaryByUserAndDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        return advanceSalaryRepository.findAdvanceSalaryByUserAndDateRange(userId, startDate, endDate);
    }

}
