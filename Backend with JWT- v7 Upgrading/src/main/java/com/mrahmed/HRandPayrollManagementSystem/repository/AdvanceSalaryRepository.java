package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.AdvanceSalary;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AdvanceSalaryRepository extends JpaRepository<AdvanceSalary, Long> {

    Optional<AdvanceSalary> findByUserIdAndStatus(Long userId, RequestStatus status);

    @Query("SELECT a FROM AdvanceSalary a WHERE a.status = :status")
    List<AdvanceSalary> findByStatus(@Param("status") RequestStatus status);

    List<AdvanceSalary> findByUserId(Long userId);

    @Query("SELECT a FROM AdvanceSalary a WHERE a.user.id = :userId AND a.status = 'APPROVED'")
    Optional<AdvanceSalary> findApprovedAdvanceSalaryByUserId(@Param("userId") Long userId);

    List<AdvanceSalary> findByUserAndIsPaidTrue(User user);

    @Query("SELECT a FROM AdvanceSalary a WHERE a.user = :user AND a.isPaid = true ORDER BY a.advanceDate DESC")
    AdvanceSalary findLatestAdvanceSalaryByUser(@Param("user") User user);

}
