package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Project: Backend with JWT- v2 as Sir
 * @Author: M. R. Ahmed
 * @Created at: 11/10/2024
 */

@Repository
public interface DepartmentRepository extends JpaRepository <Department, Long> {

    @Query("SELECT d FROM Department d WHERE d.branch.name = :branchName")
    List<Department> findAllDepartmentByBranchName(@Param("branchName") String branchName);

    @Query("SELECT d FROM Department d WHERE LOWER(d.name) LIKE LOWER(CONCAT('%', :departmentName, '%'))")
    List<Department> findDepartmentByName(@Param("departmentName") String departmentName);

    @Query("SELECT d FROM Department d WHERE d.branch.id = :branchId")
    List<Department> findDepartmentsByBranchId(@Param("branchId") Long branchId);

    @Query("SELECT d FROM Department d WHERE d.employeeNum >= :minEmployeeCount")
    List<Department> findDepartmentsByMinEmployeeCount(@Param("minEmployeeCount") int minEmployeeCount);

    @Query("SELECT d FROM Department d WHERE d.employeeNum < :maxEmployeeCount")
    List<Department> findDepartmentsByMaxEmployeeCount(@Param("maxEmployeeCount") int maxEmployeeCount);

    @Query("SELECT d FROM Department d WHERE d.email = :email")
    Department findDepartmentByEmail(@Param("email") String email);

    @Query("SELECT d FROM Department d WHERE d.createdAt BETWEEN :startDate AND :endDate")
    List<Department> findDepartmentsByCreatedAtRange(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(d) FROM Department d WHERE d.branch.id = :branchId")
    long countDepartmentsByBranchId(@Param("branchId") Long branchId);

    @Query("SELECT d FROM Department d WHERE d.employeeNum = 0")
    List<Department> findDepartmentsWithNoEmployees();

    @Query("SELECT d FROM Department d WHERE d.updatedAt > :updateDate")
    List<Department> findDepartmentsUpdatedAfter(@Param("updateDate") LocalDateTime updateDate);

}
