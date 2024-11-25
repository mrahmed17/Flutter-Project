package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {

    List<Attendance> findBySalaryId(long salaryId);

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = :date")
    List<Attendance> findByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId")
    List<Attendance> findAllByUserId(@Param("userId") Long userId);

    @Query("SELECT COUNT(a) FROM Attendance a WHERE a.user.id = :userId AND MONTH(a.date) = MONTH(:date)")
    long countMonthlyAttendance(@Param("userId") Long userId, @Param("date") LocalDate date);

    @Query("SELECT a FROM Attendance a WHERE a.date = :date")
    List<Attendance> findByDate(@Param("date") LocalDate date);

    List<Attendance> findByUserAndSalaryIsNull(User user);


}
