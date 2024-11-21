package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Role;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository <User, Long> {

    // Finding Users by Role for JWT
    Optional<List<User>> findAllByRole(Role role);

    // Finding Users by Email
    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u WHERE u.basicSalary >= :salary")
    Page<User> findUsersWithSalaryGreaterThanOrEqual(@Param("salary") double salary, Pageable pageable);

    @Query("SELECT u FROM User u WHERE u.basicSalary <= :salary")
    Page<User> findUsersWithSalaryLessThanOrEqual(@Param("salary") double salary, Pageable pageable);

    // Find Users by Role
    @Query("SELECT u FROM User u WHERE u.role = :role")
    Page<User> findByRole(@Param("role") Role role, Pageable pageable);

    // Search User record by User FullName or part of the name
    @Query("SELECT u FROM User u WHERE LOWER(u.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    Page<User> findByFullNameContaining(@Param("name") String name, Pageable pageable);

    // Search User record by User Gender
    @Query("SELECT u FROM User u WHERE u.gender = :gender")
    Page<User> findByGender(@Param("gender") String gender, Pageable pageable);

    // Search User record by User Joined Date
    @Query("SELECT u FROM User u WHERE u.joinedDate = :joinedDate")
    Page<User> findByJoinedDate(@Param("joinedDate") LocalDate joinedDate, Pageable pageable);


}
