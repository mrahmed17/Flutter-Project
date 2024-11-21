//package com.mrahmed.HRandPayrollManagementSystem.repository;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.Param;
//import org.springframework.stereotype.Repository;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Repository
//public interface SalaryRepository extends JpaRepository<Salary, Long> {
//
//    // Get the latest salary record for a user
//    @Query("SELECT s FROM Salary s WHERE s.user.id = :userId ORDER BY s.paymentDate DESC")
//    List<Salary> findLatestSalaryByUser(@Param("userId") Long userId);
//
//    // Get salaries within a specific date range
//    @Query("SELECT s FROM Salary s WHERE s.paymentDate BETWEEN :startDate AND :endDate")
//    List<Salary> findSalariesByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
//
//
//    // Get total overtime hours in a specific period
//    @Query(value = "SELECT SUM(TIMESTAMPDIFF(HOUR, a.clockInTime, a.clockOutTime) - 8) " +
//            "FROM Attendance a WHERE a.user_id = :userId AND a.date BETWEEN :startDate AND :endDate " +
//            "AND TIMESTAMPDIFF(HOUR, a.clockInTime, a.clockOutTime) > 8",
//            nativeQuery = true)
//    double getTotalOvertimeHoursByDateRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
//
//
//    // Get total overtime hours for a user
//    @Query(value = "SELECT SUM(TIMESTAMPDIFF(HOUR, a.clockInTime, a.clockOutTime) - 8) " +
//            "FROM Attendance a WHERE a.user_id = :userId) > 8",
//            nativeQuery = true)
//    double getTotalOvertimeHoursByUser(@Param("userId") Long userId);
//
//
//    // Calculate total overtime hours from working hours
//    @Query(value = "SELECT SUM(TIMESTAMPDIFF(HOUR, a.clockInTime, a.clockOutTime) - 8) " +
//            "FROM Attendance a WHERE a.user_id = :userId AND a.date BETWEEN :startDate AND :endDate " +
//            "AND TIMESTAMPDIFF(HOUR, a.clockInTime, a.clockOutTime) > 8 AND a.clockInTime BETWEEN :startTime AND :endTime",
//            nativeQuery = true)
//    double getTotalOvertimeHoursByDateRangeAndWorkingHours(@Param("startDate") LocalDateTime startDate,
//                                                           @Param("endDate") LocalDateTime endDate,
//                                                           @Param("startTime") LocalDateTime startTime,
//                                                           @Param("endTime") LocalDateTime endTime);
//
//
//}
