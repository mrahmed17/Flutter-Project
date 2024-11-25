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
        advanceSalary.setStatus(RequestStatus.PENDING);    // Default status is PENDING
        return advanceSalaryRepository.save(advanceSalary);
    }

    public AdvanceSalary approveAdvanceSalary(Long id) {
        AdvanceSalary advanceSalary = findAdvanceOrThrow(id);
        advanceSalary.setStatus(RequestStatus.APPROVED);
        advanceSalary.setIsPaid(true);
        advanceSalary.setPaidDate(LocalDateTime.now()); // Automatically set paid date
        return advanceSalaryRepository.save(advanceSalary);
    }

    public AdvanceSalary getRejectedAdvanceSalary(Long id) {
        AdvanceSalary advanceSalary = findAdvanceOrThrow(id);
        advanceSalary.setStatus(RequestStatus.REJECTED);
        return advanceSalaryRepository.save(advanceSalary);
    }

    public List<AdvanceSalary> getAllPendingAdvanceSalary() {
        return advanceSalaryRepository.findByStatus(RequestStatus.PENDING);
    }

    public List<AdvanceSalary> getAllAdvanceByUser(Long userId) {
        return advanceSalaryRepository.findByUserId(userId);
    }

    public List<AdvanceSalary> getAllAdvanceSalaries() {
        return advanceSalaryRepository.findAll();
    }

    public List<AdvanceSalary> getApprovedAdvanceSalaryByUserId(Long userId) {
        return advanceSalaryRepository.findApprovedAdvanceSalaryByUserId(userId);
    }

    public List<AdvanceSalary> getAdvanceSalariesByStatus(RequestStatus status) {
        return advanceSalaryRepository.findByStatus(status);
    }

    private AdvanceSalary findAdvanceOrThrow(Long advanceId) {
        return advanceSalaryRepository.findById(advanceId)
                .orElseThrow(() -> new RuntimeException("Advance Salary not found with ID: " + advanceId));
    }

    public AdvanceSalary getAdvanceSalaryById(Long id) {
        return findAdvanceOrThrow(id);
    }

    //    public List<AdvanceSalary> getAdvanceSalariesByUserAndStatus(Long userId, RequestStatus status) {
//        return advanceSalaryRepository.findByUserIdAndStatus(userId, status);
//    }

    //    public List<AdvanceSalary> getAdvanceSalariesByUserId(Long userId) {
//        return advanceSalaryRepository.findByUserId(userId);
//    }

}
