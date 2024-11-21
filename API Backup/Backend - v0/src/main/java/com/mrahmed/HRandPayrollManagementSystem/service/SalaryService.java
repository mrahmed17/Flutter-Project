package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.*;
import com.mrahmed.HRandPayrollManagementSystem.repository.SalaryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SalaryService {

    @Autowired
    private SalaryRepository salaryRepository;


    public Salary saveSalary(Salary salary) {
        return salaryRepository.save(salary);
    }

    // Update an existing salary record
    public Salary updateSalary(Long salaryId, Salary salary) {
        if (!salaryRepository.existsById(salaryId)) {
            throw new RuntimeException("Salary record not found.");
        }
        salary.setId(salaryId);
        return salaryRepository.save(salary);
    }

    // Delete a salary record by ID
    public void deleteSalary(Long salaryId) {
        if (!salaryRepository.existsById(salaryId)) {
            throw new RuntimeException("Salary record not found.");
        }
        salaryRepository.deleteById(salaryId);
    }

    // Get a salary record by ID
    public Salary getSalaryById(Long salaryId) {
        return salaryRepository.findById(salaryId)
                .orElseThrow(() -> new RuntimeException("Salary record not found."));
    }

    // Get salaries within a specific date range
    public List<Salary> getSalariesByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return salaryRepository.findSalariesByDateRange(startDate, endDate);
    }

    // Get the latest salary record for a specific user
    public List<Salary> getLatestSalaryByUser(Long userId) {
        return salaryRepository.findLatestSalaryByUser(userId);
    }

    // Get total overtime hours in a specific period
    public double getTotalOvertimeHoursByDateRange(Long userId, LocalDateTime startDate, LocalDateTime endDate) {
        return salaryRepository.getTotalOvertimeHoursByDateRange(startDate, endDate);
    }

    // Get total overtime hours for a specific user
    public double getTotalOvertimeHoursByUser(Long userId) {
        return salaryRepository.getTotalOvertimeHoursByUser(userId);
    }

    // Calculate total overtime hours based on working hours within a date range
    public double getTotalOvertimeHoursByDateRangeAndWorkingHours(Long userId, LocalDateTime startDate,
                                                                  LocalDateTime endDate, LocalDateTime startTime,
                                                                  LocalDateTime endTime) {
        return salaryRepository.getTotalOvertimeHoursByDateRangeAndWorkingHours(startDate, endDate, startTime, endTime);
    }

}
