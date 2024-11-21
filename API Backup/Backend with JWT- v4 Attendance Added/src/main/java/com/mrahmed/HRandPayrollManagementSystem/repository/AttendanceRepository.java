package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, Long> {

    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date BETWEEN :startDate AND :endDate")
    Page<Attendance> findAttendancesByUserIdAndDateRange(
            @Param("userId") long userId,
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Pageable pageable); // Added Pageable for pagination

    long countByUserIdAndDate(long userId, LocalDate date);

    // Custom query to fetch attendance records for the current day
    @Query("SELECT a FROM Attendance a WHERE a.date = :currentDate")
    Page<Attendance> findAttendancesForToday(@Param("currentDate") LocalDate currentDate, Pageable pageable);

    @Query("SELECT a FROM Attendance a WHERE a.date BETWEEN :startDate AND :endDate")
    Page<Attendance> findAttendancesInRange(@Param("startDate") LocalDate startDate,
                                            @Param("endDate") LocalDate endDate,
                                            Pageable pageable);

    @Query("SELECT u FROM User u WHERE u.id NOT IN " +
            "(SELECT a.user.id FROM Attendance a WHERE a.date = :today)")
    Page<User> findUsersWithoutAttendanceForToday(@Param("today") LocalDate today, Pageable pageable);

    Page<Attendance> findAllByUserId(Long id, Pageable pageable);

    // findLastAttendanceForUser
    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = :today ORDER BY a.clockInTime DESC")
    Optional<Attendance> findLastAttendanceForUser(@Param("userId") long userId, @Param("today") LocalDate today);

    // 7. Daily peak attendance (which day had the most or least attendance)
    @Query("SELECT a.date, COUNT(a) FROM Attendance a GROUP BY a.date ORDER BY COUNT(a) DESC")
    Page<Object[]> findPeakAttendanceDay(Pageable pageable); // Added Pageable

    // 8. Monthly attendance trends (which month had the most or least attendance)
    @Query("SELECT MONTH(a.date), COUNT(a) FROM Attendance a GROUP BY MONTH(a.date) ORDER BY COUNT(a) DESC")
    Page<Object[]> findPeakAttendanceMonth(Pageable pageable); // Added Pageable

    // 15. Late check-ins (find users who are consistently late)
    @Query("SELECT a FROM Attendance a WHERE a.clockInTime > :lateTime AND a.date BETWEEN :startDate AND :endDate ORDER BY a.clockInTime DESC")
    Page<Attendance> findLateCheckIns(@Param("lateTime") String lateTime,
                                      @Param("startDate") LocalDate startDate,
                                      @Param("endDate") LocalDate endDate,
                                      Pageable pageable);

    // 18. Search attendance record by User FullName or part of the name
    @Query("SELECT a FROM Attendance a WHERE LOWER(a.user.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    Page<Attendance> findAttendancesByUserNamePart(@Param("name") String name, Pageable pageable);

    // 19. Filter user role-based attendance in the date range
    @Query("SELECT a FROM Attendance a WHERE a.user.role = :role")
    Page<Attendance> findAttendanceByRole(@Param("role") String role, Pageable pageable);

    // 20. Show only today's attendance after check-in or check-out
    @Query("SELECT a FROM Attendance a WHERE a.user.id = :userId AND a.date = CURRENT_DATE")
    Page<Attendance> findTodayAttendanceByUserId(@Param("userId") long userId, Pageable pageable);

    // Optional: Delete method (commented out for now, not needed for pagination)
    // @Modifying
    // @Query("DELETE FROM Attendance a WHERE a.user.id = :userId")
    // void deleteByUserId(@Param("userId") Long userId);


}
