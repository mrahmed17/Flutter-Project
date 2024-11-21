//package com.mrahmed.HRandPayrollManagementSystem.service;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
//import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
//import com.mrahmed.HRandPayrollManagementSystem.repository.BranchRepository;
//import com.mrahmed.HRandPayrollManagementSystem.repository.DepartmentRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
///**
// * @Project: Backend with JWT- v2 as Sir
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//@Service
//public class BranchService {
//
//    @Autowired
//    private BranchRepository branchRepository;
//
//
//    @Value("${upload.directory}")
//    private String uploadDirectory;
//
//    public List<Branch> getALlBranches() {
//        return branchRepository.findAll();
//    }
//
//    public void saveBranch(Branch branch) {
//        branchRepository.save(branch);
//    }
////        @SuppressWarnings("unused")
//    public void updateBranch(long id, Branch updatedBranch) {
//        Branch existingBranch = branchRepository.findById(id)
//                .orElseThrow(() -> new
//                        RuntimeException("Branch Not Found by this Id"));
//
//        existingBranch.setName(updatedBranch.getName());
//        existingBranch.setAddress(updatedBranch.getAddress());
//        existingBranch.setCell(updatedBranch.getCell());
//        existingBranch.setEmail(updatedBranch.getEmail());
//        existingBranch.setBranchImage(updatedBranch.getBranchImage());
//
//        branchRepository.save(existingBranch);
//    }
//
//    public void deleteBranch(long id) {
//        branchRepository.deleteById(id);
//    }
//
//    public Branch findById(long id) {
//        return branchRepository.findById(id)
//                .orElseThrow(() -> new
//                        RuntimeException("Branch Not Found by this Id"));
//    }
//
//
//}
