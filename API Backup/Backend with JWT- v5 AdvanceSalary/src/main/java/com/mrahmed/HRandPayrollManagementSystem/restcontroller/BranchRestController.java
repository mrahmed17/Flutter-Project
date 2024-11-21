package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

/**
 * @Project: Backend with JWT- v2 as Sir
 * @Author: M. R. Ahmed
 * @Created at: 11/10/2024
 */

import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
import com.mrahmed.HRandPayrollManagementSystem.service.BranchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/branches")
@CrossOrigin("*")
public class BranchRestController {

    @Autowired
    private BranchService branchService;

    @PostMapping("/create")
    public ResponseEntity<?> createBranch(
            @RequestPart(value = "branch") Branch branch,
            @RequestPart(value = "branchPhoto", required = false) MultipartFile branchPhoto) {
        try {
            Branch newBranch = branchService.createBranch(branch, branchPhoto);
            return ResponseEntity.status(HttpStatus.CREATED).body(newBranch);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error creating branch: " + e.getMessage());
        }
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateBranch(
            @PathVariable long id,
            @RequestPart("branch") Branch updatedBranch,
            @RequestPart(value = "branchPhoto", required = false) MultipartFile branchPhoto) {
        try {
            branchService.updateBranch(id, updatedBranch, branchPhoto);
            return ResponseEntity.ok("Branch updated successfully");
        } catch (RuntimeException | IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Error updating branch: " + e.getMessage());
        }
    }



    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteBranch(@PathVariable long id) {
        try {
            branchService.deleteBranch(id);
            return ResponseEntity.ok("Branch deleted successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Error deleting branch: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getBranchById(@PathVariable long id) {
        try {
            Branch branch = branchService.findById(id);
            return ResponseEntity.ok(branch);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Error retrieving branch: " + e.getMessage());
        }
    }


    @GetMapping("/all")
    public ResponseEntity<List<Branch>> getAllBranches() {
        List<Branch> branches = branchService.getAllBranches();
        return ResponseEntity.ok(branches);
    }

    @GetMapping("/name/{name}")
    public ResponseEntity<Branch> getBranchByName(@PathVariable String name) {
        Branch branch = branchService.findBranchByName(name);
        return ResponseEntity.ok(branch);
    }

    @GetMapping("/address/keyword/{keyword}")
    public ResponseEntity<List<Branch>> getBranchesByAddressKeyword(@PathVariable String keyword) {
        List<Branch> branches = branchService.findBranchesByAddressKeyword(keyword);
        return ResponseEntity.ok(branches);
    }


    @GetMapping("/email/{email}")
    public ResponseEntity<Branch> getBranchByEmail(@PathVariable String email) {
        Branch branch = branchService.findBranchByEmail(email);
        return ResponseEntity.ok(branch);
    }

    @GetMapping("/count")
    public ResponseEntity<Long> countBranches() {
        Long count = branchService.countBranches();
        return ResponseEntity.ok(count);
    }

}
