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
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // Finding Users by id for profiles
    Optional<User> findById(long id);

    // Find a single user by email for authentication
    Optional<User> findByEmail(String email);

    // Find users by role with pagination
    @Query("SELECT u FROM User u WHERE u.role = :role")
    Page<User> findAllByRole(@Param("role") Role role, Pageable pageable);

    // Find users with salary greater than or equal to a certain amount with pagination
    @Query("SELECT u FROM User u WHERE u.basicSalary >= :salary")
    Page<User> findUsersWithSalaryGreaterThanOrEqual(@Param("salary") double salary, Pageable pageable);

    // Find users with salary less than or equal to a certain amount with pagination
    @Query("SELECT u FROM User u WHERE u.basicSalary <= :salary")
    Page<User> findUsersWithSalaryLessThanOrEqual(@Param("salary") double salary, Pageable pageable);

    // Search user records by full name or part of the name with pagination
    @Query("SELECT u FROM User u WHERE LOWER(u.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    Page<User> findByFullNameContaining(@Param("name") String name, Pageable pageable);

    // Search user records by gender with pagination
    @Query("SELECT u FROM User u WHERE u.gender = :gender")
    Page<User> findByGender(@Param("gender") String gender, Pageable pageable);

    // Search user records by joined date with pagination
    @Query("SELECT u FROM User u WHERE u.joinedDate = :joinedDate")
    Page<User> findByJoinedDate(@Param("joinedDate") LocalDate joinedDate, Pageable pageable);

    // Find all employees with pagination
    @Query("SELECT u FROM User u WHERE u.role = 'EMPLOYEE'")
    Page<User> findAllEmployees(Pageable pageable);
}
