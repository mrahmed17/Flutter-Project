package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
import com.mrahmed.HRandPayrollManagementSystem.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/departments")
@CrossOrigin("*")
public class DepartmentRestController {

    @Autowired
    private DepartmentService departmentService;

    // Create a department with an optional photo upload
    @PostMapping("/create")
    public ResponseEntity<?> createDepartment(
            @RequestPart(value = "department") Department department,
            @RequestPart(value = "departmentPhoto", required = false) MultipartFile departmentPhoto) {
        try {
            Department newDepartment = departmentService.createDepartment(department, departmentPhoto);
            return ResponseEntity.status(HttpStatus.CREATED).body(newDepartment);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error creating department: " + e.getMessage());
        }
    }

    // Get all departments
    @GetMapping("/all")
    public ResponseEntity<List<Department>> getAllDepartments() {
        List<Department> departments = departmentService.getAllDepartments();
        return ResponseEntity.ok(departments);
    }

    // Delete a department by its ID
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Void> deleteDepartmentById(@PathVariable Long id) {
        departmentService.deleteDepartmentById(id);
        return ResponseEntity.noContent().build();
    }

    // Get department by ID
    @GetMapping("/find/{id}")
    public ResponseEntity<Department> getDepartmentById(@PathVariable Long id) {
        Department department = departmentService.findDepartmentById(id);
        return ResponseEntity.ok(department);
    }

    // Update department
    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateDepartment(
            @PathVariable long id,
            @RequestBody Department updatedDepartment,
            @RequestPart(value = "departmentPhoto", required = false) MultipartFile departmentPhoto) {
        try {
            departmentService.updateDepartment(id, updatedDepartment, departmentPhoto);
            return ResponseEntity.ok("Department updated successfully");
        } catch (RuntimeException | IOException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Error updating department: " + e.getMessage());
        }
    }

    // Find departments by name
    @GetMapping("/findByName/{name}")
    public ResponseEntity<List<Department>> getDepartmentsByName(@PathVariable String name) {
        List<Department> departments = departmentService.findDepartmentByName(name);
        return ResponseEntity.ok(departments);
    }

    // Find departments by branch ID
    @GetMapping("/findByBranch/{branchId}")
    public ResponseEntity<List<Department>> getDepartmentsByBranchId(@PathVariable Long branchId) {
        List<Department> departments = departmentService.findDepartmentsByBranchId(branchId);
        return ResponseEntity.ok(departments);
    }

    // Find departments by branch name
    @GetMapping("/findByBranchName/{branchName}")
    public ResponseEntity<List<Department>> getDepartmentsByBranchName(@PathVariable String branchName) {
        List<Department> departments = departmentService.findDepartmentByBranchName(branchName);
        return ResponseEntity.ok(departments);
    }

    // Find departments by minimum employee count
    @GetMapping("/findByMinEmployeeCount/{minEmployeeCount}")
    public ResponseEntity<List<Department>> getDepartmentsByMinEmployeeCount(@PathVariable int minEmployeeCount) {
        List<Department> departments = departmentService.findDepartmentsByMinEmployeeCount(minEmployeeCount);
        return ResponseEntity.ok(departments);
    }

    // Find departments by maximum employee count
    @GetMapping("/findByMaxEmployeeCount/{maxEmployeeCount}")
    public ResponseEntity<List<Department>> getDepartmentsByMaxEmployeeCount(@PathVariable int maxEmployeeCount) {
        List<Department> departments = departmentService.findDepartmentsByMaxEmployeeCount(maxEmployeeCount);
        return ResponseEntity.ok(departments);
    }

    // Find a department by its email address
    @GetMapping("/findByEmail/{email}")
    public ResponseEntity<Department> getDepartmentByEmail(@PathVariable String email) {
        Department department = departmentService.findDepartmentByEmail(email);
        return ResponseEntity.ok(department);
    }

    // Find departments created within a specific date range
    @GetMapping("/findByCreatedAtRange")
    public ResponseEntity<List<Department>> getDepartmentsByCreatedAtRange(
            @RequestParam LocalDateTime startDate, @RequestParam LocalDateTime endDate) {
        List<Department> departments = departmentService.findDepartmentsByCreatedAtRange(startDate, endDate);
        return ResponseEntity.ok(departments);
    }

    // Count the number of departments in a given branch
    @GetMapping("/countByBranch/{branchId}")
    public ResponseEntity<Long> countDepartmentsByBranchId(@PathVariable Long branchId) {
        long count = departmentService.countDepartmentsByBranchId(branchId);
        return ResponseEntity.ok(count);
    }

    // Find departments with no employees
    @GetMapping("/findWithNoEmployees")
    public ResponseEntity<List<Department>> getDepartmentsWithNoEmployees() {
        List<Department> departments = departmentService.findDepartmentsWithNoEmployees();
        return ResponseEntity.ok(departments);
    }

    // Find departments updated after a specific date
    @GetMapping("/findUpdatedAfter")
    public ResponseEntity<List<Department>> getDepartmentsUpdatedAfter(@RequestParam LocalDateTime updateDate) {
        List<Department> departments = departmentService.findDepartmentsUpdatedAfter(updateDate);
        return ResponseEntity.ok(departments);
    }
}
