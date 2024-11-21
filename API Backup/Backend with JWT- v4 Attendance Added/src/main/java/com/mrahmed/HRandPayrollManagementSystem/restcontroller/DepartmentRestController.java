//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
///**
// * @Project: Backend with JWT- v2 as Sir
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
//import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
//import com.mrahmed.HRandPayrollManagementSystem.repository.BranchRepository;
//import com.mrahmed.HRandPayrollManagementSystem.repository.DepartmentRepository;
//import com.mrahmed.HRandPayrollManagementSystem.service.BranchService;
//import com.mrahmed.HRandPayrollManagementSystem.service.DepartmentService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.util.Collections;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//@RestController
//@RequestMapping("/api/branch")
//@CrossOrigin("*")
//public class DepartmentRestController {
//
//    @Autowired
//    private DepartmentService departmentService;
//
//    //    @Autowired
//    //    private DepartmentRepository departmentRepository;
//
//    @PostMapping("/create")
//public ResponseEntity<Map<String, String>> saveDepartment(
//        @RequestPart(value = "department") String departmentJson,
//        @RequestPart(value = "image") MultipartFile file
//) throws IOException {
//
//    // Convert JSON string to Department object
//    ObjectMapper objectMapper = new ObjectMapper();
//    Department department = objectMapper.readValue(departmentJson, Department.class);
//
//    // Save the department and the image
//    try {
//        departmentService.saveDepartment(department, file);
//
//        // Create a response map
//        Map<String, String> response = new HashMap<>();
//        response.put("message", "Department added successfully");
//        return new ResponseEntity<>(response, HttpStatus.OK);
//    } catch (Exception e) {
//        // Return error as JSON
//        Map<String, String> errorResponse = new HashMap<>();
//        errorResponse.put("error", "Failed to add department: " + e.getMessage());
//        return new ResponseEntity<>(errorResponse, HttpStatus.INTERNAL_SERVER_ERROR);
//    }
//}
//
//
////    @PostMapping("/create")
////    public ResponseEntity<Department> saveDepartment(@RequestBody Department department) {
////        try {
////            departmentService.saveDepartment(department, null);
////        } catch (IOException e) {
////            throw new RuntimeException(e);
////        }
////        return ResponseEntity.ok(department);
////    }
//
//    @GetMapping("/all")
//    public ResponseEntity<List<Department>> getALlDepartment() {
//        List<Department> departments = departmentService.getAllDepartments();
////        List<Department> departments = departmentService.findAll();
//        return ResponseEntity.ok(departments);
//    }
//
//    @DeleteMapping("/delete/{id}")
//    public ResponseEntity<Void> deleteDepartmentById(@PathVariable Long id) {
//        departmentService.deleteDepartmentById(id);
//        return ResponseEntity.noContent().build();
//    }
//
//
//    @GetMapping("/find/{id}")
//    public ResponseEntity<List<Department>> getDepartmentById(@PathVariable Long id) {
//        Department department = departmentService.findDepartmentById(id);
//        return ResponseEntity.ok(Collections.singletonList(department));
//    }
//
//    // updateDepartment
//    @PutMapping("/update/{id}")
//    public ResponseEntity<Department> updateDepartment(
//            @PathVariable Long id,
//            @RequestBody Department updatedDepartment,
//            @RequestPart(value = "image") MultipartFile file
//    ) {
//        Department department = null;
//        try {
//            department = departmentService.updateDepartment(id, updatedDepartment, file);
//        } catch (IOException e) {
//            throw new RuntimeException(e);
//        }
//        return ResponseEntity.ok(department);
//    }
//
//
//    //findDepartmentByName
//    @GetMapping("/findByName/{name}")
//    public ResponseEntity<List<Department>> getDepartmentByName(@PathVariable String name) {
//        List<Department> departments = departmentService.findDepartmentByName(name);
//        return ResponseEntity.ok(departments);
//    }
//
//    // findDepartmentByBranch
//    @GetMapping("/findByBranch/{branchId}")
//    public ResponseEntity<List<Department>> getDepartmentByBranch(@PathVariable Long branchId) {
//        List<Department> departments = departmentService.findDepartmentByBranchName(branchId);
//        return ResponseEntity.ok(departments);
//    }
//
//
//    //findDepartmentByBranchName
//    @GetMapping("/findByBranchName/{branchName}")
//    public ResponseEntity<List<Department>> getDepartmentByBranchName(@PathVariable String branchName) {
//        String branch = new Branch();
//        branch.setName(branchName);
//        List<Department> departments = departmentService.findDepartmentByBranchName(branch);
//        return ResponseEntity.ok(departments);
//    }
//
//
//}
