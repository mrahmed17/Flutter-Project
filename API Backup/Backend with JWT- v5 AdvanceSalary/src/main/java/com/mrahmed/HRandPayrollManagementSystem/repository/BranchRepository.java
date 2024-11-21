package com.mrahmed.HRandPayrollManagementSystem.repository;

import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * @Project: Backend with JWT- v2 as Sir
 * @Author: M. R. Ahmed
 * @Created at: 11/10/2024
 */

@Repository
public interface BranchRepository  extends JpaRepository <Branch, Long> {

    @Query("SELECT b FROM Branch b WHERE b.name = :branchName")
    Branch findBranchByName(@Param("branchName") String branchName);

    @Query("SELECT b FROM Branch b WHERE LOWER(b.address) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Branch> findBranchesByAddressKeyword(@Param("keyword") String keyword);

    @Query("SELECT b FROM Branch b WHERE b.email = :email")
    Branch findBranchByEmail(@Param("email") String email);

    @Query("SELECT COUNT(b) FROM Branch b")
    Long countBranches();

}
