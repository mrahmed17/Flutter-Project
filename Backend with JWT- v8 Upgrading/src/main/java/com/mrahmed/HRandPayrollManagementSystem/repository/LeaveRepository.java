package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Leave;
import com.mrahmed.HRandPayrollManagementSystem.entity.LeaveType;
import com.mrahmed.HRandPayrollManagementSystem.entity.RequestStatus;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface LeaveRepository extends JpaRepository<Leave, Long> {

    List<Leave> findBySalaryId(long salaryId);

    List<Leave> findByRequestStatus(RequestStatus status);

    List<Leave> findByUserIdAndRequestStatus(Long userId, RequestStatus status);

    List<Leave> findByUserIdAndStartDateBetween(Long userId, LocalDate startDate, LocalDate endDate);

    @Query("SELECT l FROM Leave l WHERE l.user.id = :userId")
    List<Leave> findLeavesByUserId(@Param("userId") Long userId);

    List<Leave> findByUserAndSalaryIsNull(User user);


}
