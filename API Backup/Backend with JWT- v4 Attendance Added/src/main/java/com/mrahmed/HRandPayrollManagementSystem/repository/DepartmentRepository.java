//package com.mrahmed.HRandPayrollManagementSystem.repository;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
//import org.springframework.data.jpa.repository.JpaRepository;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.Param;
//import org.springframework.stereotype.Repository;
//
//import java.util.List;
//
///**
// * @Project: Backend with JWT- v2 as Sir
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//@Repository
//public interface DepartmentRepository extends JpaRepository <Department, Long> {
//
//    @Query("SELECT d FROM Department d WHERE d.branch.name = :branchName")
//    List<Department> findDepartmentByBranchName(@Param("branchName") String branchName);
//
//    @Query("SELECT d FROM Department d WHERE d.name = :departmentName")
//    Department findDepartmentByName(@Param("departmentName") String departmentName);
//
//}
