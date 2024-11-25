package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface SalaryRepository extends JpaRepository<Salary, Long> {

    Optional<Salary> findByUserId(long userId);

    List<Salary> findByPaymentDateBetween(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT s FROM Salary s WHERE s.salaryStatus = :status")
    List<Salary> findBySalaryStatus(RequestStatus status);

    @Query("SELECT s FROM Salary s WHERE s.user.id = :userId AND s.paymentDate BETWEEN :startDate AND :endDate")
    List<Salary> findByUserIdAndPaymentDateBetween(
            @Param("userId") Long userId,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );
}
