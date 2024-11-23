package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Bonus;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BonusRepository extends JpaRepository<Bonus, Long> {

    List<Bonus> findBySalaryId(long salaryId);

    @Query("SELECT SUM(b.bonusAmount) FROM Bonus b WHERE b.user.id = :userId")
    double getTotalBonusForUser(@Param("userId") Long userId);

    @Query("SELECT b FROM Bonus b WHERE b.bonusDate BETWEEN :startDate AND :endDate")
    List<Bonus> getBonusesBetweenDates(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT SUM(b.bonusAmount) FROM Bonus b WHERE MONTH(b.bonusDate) = :month AND YEAR(b.bonusDate) = :year")
    double getTotalBonusForMonth(@Param("month") int month, @Param("year") int year);

    @Query("SELECT COUNT(b) FROM Bonus b WHERE b.user.id = :userId AND YEAR(b.bonusDate) = :year")
    long countBonusesForUserInYear(@Param("userId") Long userId, @Param("year") int year);

    @Query("SELECT b FROM Bonus b WHERE b.user.id = :userId")
    List<Bonus> findBonusesByUserId(@Param("userId") Long userId);

    List<Bonus> findByUserAndSalaryIsNull(User user);

}
