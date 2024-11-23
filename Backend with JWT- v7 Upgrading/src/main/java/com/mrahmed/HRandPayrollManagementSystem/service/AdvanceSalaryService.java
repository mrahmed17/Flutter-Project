package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.AdvanceSalaryRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AdvanceSalaryService {

    @Autowired
    private AdvanceSalaryRepository advanceSalaryRepository;

    @Autowired
    private UserRepository userRepository;

    public AdvanceSalary applyAdvanceSalary(AdvanceSalary advanceSalary) {
        User user = userRepository.findById(advanceSalary.getUser().getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + advanceSalary.getUser().getId()));

        advanceSalary.setUser(user);
        advanceSalary.setAdvanceDate(LocalDateTime.now()); // Automatically set the date
        return advanceSalaryRepository.save(advanceSalary);
    }


//    public AdvanceSalary applyAdvanceSalary(AdvanceSalary advanceSalary) {
//        return advanceSalaryRepository.save(advanceSalary);
//    }

    public AdvanceSalary updateAdvanceSalary(AdvanceSalary advanceSalary) {
        return advanceSalaryRepository.save(advanceSalary);
    }

    public AdvanceSalary approveAdvanceSalary(Long id) {
        AdvanceSalary advanceSalary = advanceSalaryRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("AdvanceSalary with ID " + id + " not found"));
        advanceSalary.setStatus(RequestStatus.APPROVED);
        advanceSalary.setIsPaid(true);
        advanceSalary.setPaidDate(java.time.LocalDateTime.now());
        return advanceSalaryRepository.save(advanceSalary);
    }

    public AdvanceSalary getAdvanceSalaryById(Long id) {
        return advanceSalaryRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("AdvanceSalary with ID " + id + " not found"));
    }

    // Get all AdvanceSalary records
    public List<AdvanceSalary> getAllAdvanceSalaries() {
        return advanceSalaryRepository.findAll();
    }

    // Get AdvanceSalaries by User ID
    public List<AdvanceSalary> getAdvanceSalariesByUserId(Long userId) {
        return advanceSalaryRepository.findByUserId(userId);
    }

    // Delete AdvanceSalary by ID
    public void deleteAdvanceSalary(Long id) {
        if (advanceSalaryRepository.existsById(id)) {
            advanceSalaryRepository.deleteById(id);
        } else {
            throw new IllegalArgumentException("AdvanceSalary with ID " + id + " does not exist.");
        }
    }

    public Optional<AdvanceSalary> getApprovedAdvanceSalaryByUserId(Long userId) {
        return advanceSalaryRepository.findApprovedAdvanceSalaryByUserId(userId);
    }

    public Optional<AdvanceSalary> getAdvanceSalariesByUserAndStatus(Long userId, RequestStatus status) {
        return advanceSalaryRepository.findByUserIdAndStatus(userId, status);
    }

    public List<AdvanceSalary> getAdvanceSalariesByStatus(RequestStatus status) {
        return advanceSalaryRepository.findByStatus(status);
    }
}
