package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SalaryRepository extends JpaRepository<Salary, Long> {

    // Find the latest salary for a user
    Optional<Salary> findFirstByUser_IdOrderByPaymentDateDesc(Long userId);

    // Salaries within a specific date range
    List<Salary> findByPaymentDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    // Salaries by status
    List<Salary> findBySalaryStatus(String status);

}


