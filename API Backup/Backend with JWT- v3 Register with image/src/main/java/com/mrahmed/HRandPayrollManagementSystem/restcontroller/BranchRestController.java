//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
///**
// * @Project: Backend with JWT- v2 as Sir
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
//import com.mrahmed.HRandPayrollManagementSystem.repository.BranchRepository;
//import com.mrahmed.HRandPayrollManagementSystem.service.BranchService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.CrossOrigin;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/branch")
//@CrossOrigin("*")
//public class BranchRestController {
//
//    @Autowired
//    private BranchService branchService;
//    @Autowired
//    private BranchRepository branchRepository;
//
//
//    @GetMapping("/all")
//    public ResponseEntity<List<Branch>> getAllLocations() {
//        List<Branch> branches = branchService.getALlBranches();
////        List<Branch> branches = branchRepository.findAll();
//        return ResponseEntity.ok(branches);
//    }
//}
