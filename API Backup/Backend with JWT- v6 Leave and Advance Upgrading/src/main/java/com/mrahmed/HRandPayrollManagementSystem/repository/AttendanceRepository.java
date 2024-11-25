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

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId")
    List<Attendance> findOvertimeForUser(@Param("userId") long userId);

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date BETWEEN :startDate AND :endDate")
    List<Attendance> findAttendancesByUserIdAndDateRange(
            @Param("userId") long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    List<Attendance> findByUserIdAndDate(Long userId, LocalDate date);

    @Query("SELECT a FROM Attendance a WHERE a.date = :currentDate")
    List<Attendance> findAttendancesForToday(LocalDate currentDate);

//    @Query("SELECT a FROM Attendance a WHERE a.date BETWEEN :startDate AND :endDate")
//    List<Attendance> findByDateRange(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    @Query("SELECT u FROM User u WHERE u.id NOT IN (SELECT a.user.id FROM Attendance a WHERE a.date = :date)")
    List<User> findUsersWithoutAttendance(@Param("date") LocalDate date);

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId")
    List<Attendance> findAllByUserId(Long userId);

    @Query("SELECT a.date as period, COUNT(a) as count FROM Attendance a GROUP BY a.date ORDER BY COUNT(a) DESC")
    List<Object[]> findPeakAttendanceDay();

    @Query("SELECT MONTH(a.date) as period, COUNT(a) as count FROM Attendance a GROUP BY MONTH(a.date) ORDER BY COUNT(a) DESC")
    List<Object[]> findPeakAttendanceMonth();

    @Query("SELECT a FROM Attendance a WHERE a.lateCheckIn = true")
    List<Attendance> findLateAttendances();

    @Query("SELECT a FROM Attendance a WHERE LOWER(a.user.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Attendance> findAttendancesByUserNamePart(@Param("name") String name);

    @Query("SELECT a FROM Attendance a WHERE a.user.role = :role")
    List<Attendance> findAttendanceByRole(@Param("role") String role);

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = CURRENT_DATE")
    List<Attendance> findTodayAttendanceByUserId(@Param("userId") long userId);


}
