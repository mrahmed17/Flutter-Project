package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date BETWEEN :startDate AND :endDate")
    List<Attendance> findAttendancesByUserIdAndDateRange(
            @Param("userId") long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    long countByUserIdAndDate(long userId, LocalDate date);

    // Custom query to fetch attendance records for the current day
    @Query("SELECT a FROM Attendance a WHERE a.date = :currentDate")
    List<Attendance> findAttendancesForToday(LocalDate currentDate);

    @Query("SELECT a FROM Attendance a WHERE a.date BETWEEN :startDate AND :endDate")
    List<Attendance> findAttendancesInRange(@Param("startDate") LocalDate startDate,
                                            @Param("endDate") LocalDate endDate);

    @Query("SELECT u FROM User u WHERE u.id NOT IN " +
            "(SELECT a.user.id FROM Attendance a WHERE a.date = :today)")
    List<User> findUsersWithoutAttendanceForToday(@Param("today") LocalDate today);

    List<Attendance> findAllByUserId(Long id);

    // findLastAttendanceForUser
    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = :today ORDER BY a.clockInTime DESC")
    Optional<Attendance> findLastAttendanceForUser(@Param("userId") long userId, @Param("today") LocalDate today);


    // 7. Daily peak attendance (which day had the most or least attendance)
    @Query("SELECT a.date, COUNT(a) FROM Attendance a GROUP BY a.date ORDER BY COUNT(a) DESC")
    List<Object[]> findPeakAttendanceDay();

    // 8. Monthly attendance trends (which month had the most or least attendance)
    @Query("SELECT MONTH(a.date), COUNT(a) FROM Attendance a GROUP BY MONTH(a.date) ORDER BY COUNT(a) DESC")
    List<Object[]> findPeakAttendanceMonth();


    // 15. Late check-ins (find users who are consistently late)
    @Query("SELECT a FROM Attendance a WHERE a.clockInTime > :lateTime AND a.date BETWEEN :startDate AND :endDate ORDER BY a.clockInTime DESC")
    List<Attendance> findLateCheckIns(@Param("lateTime") String lateTime,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate);

    // 18. Search attendance record by User FullName or part of the name
    @Query("SELECT a FROM Attendance a WHERE LOWER(a.user.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Attendance> findAttendancesByUserNamePart(@Param("name") String name);

    // 19. Filter user role-based attendance in the date range
    @Query("SELECT a FROM Attendance a WHERE a.user.role = :role")
    List<Attendance> findAttendanceByRole(@Param("role") String role);

    // 20. Show only today's attendance after check-in or check-out
    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = CURRENT_DATE")
    List<Attendance> findTodayAttendanceByUserId(@Param("userId") long userId);

    @Modifying
    @Query("DELETE FROM Attendance a WHERE a.user.id = :userId")
    void deleteByUserId(@Param("userId") Long userId);


}
