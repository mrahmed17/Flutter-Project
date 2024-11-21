//package com.mrahmed.HRandPayrollManagementSystem.repository;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.PaySlip;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.stereotype.Repository;
//
//import java.time.LocalDateTime;
//import java.util.List;
//import java.util.Optional;
//
//@Repository
//public interface PaySlipRepository extends JpaRepository<PaySlip, Long> {
//
//    List<PaySlip> findByReceivedById(Long employeeId);
//
//    List<PaySlip> findByPaidById(Long managerId);
//
//    List<PaySlip> findByStatus(String status);
//
//    List<PaySlip> findByBillingDateBetween(LocalDateTime startDate, LocalDateTime endDate);
//
//    Optional<PaySlip> findBySalaryId(Long salaryId);
//
//    List<PaySlip> findByPaymentMethod(String paymentMethod);
//
//    List<PaySlip> findByReceivedByIdAndStatus(Long employeeId, String status);
//
//    Long countByStatus(String status);
//
//
//}
