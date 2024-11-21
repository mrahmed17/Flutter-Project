//package com.mrahmed.HRandPayrollManagementSystem.service;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
//import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
//import com.mrahmed.HRandPayrollManagementSystem.repository.BranchRepository;
//import com.mrahmed.HRandPayrollManagementSystem.repository.DepartmentRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.nio.file.Paths;
//import java.util.List;
//import java.util.UUID;
//
///**
// * @Project: Backend with JWT- v2 as Sir
// * @Author: M. R. Ahmed
// * @Created at: 11/10/2024
// */
//
//@Service
//public class DepartmentService {
//
//    @Autowired
//    private DepartmentRepository departmentRepository;
//
//    @Autowired
//    private BranchRepository branchRepository;
//
//    @Value("src/main/resources/static/images")
//    private String uploadDirectory;
//
//
//    public List<Department> getAllDepartments() {
//        return departmentRepository.findAll();
//    }
//
//
//    @Transactional
//    public void saveDepartment(Department department, MultipartFile imageFile) throws IOException {
//
//        // Fetch Branch from repository based on the provided ID
//        Branch branch = branchRepository.findById((long) department.getBranch().getId())
//                .orElseThrow(() -> new RuntimeException("Branch with this ID not found"));
//        System.out.println(branch.toString());
//
//        // Check if the image file is provided and not empty
//        if (imageFile != null && !imageFile.isEmpty()) {
//            String imageFilename = saveImage(imageFile, department);
//            department.setDepImage(imageFilename); // Set the image filename in the department entity
//        }
//
//        // Set the fetched branch to the department
//        department.setBranch(branch);
//
//        // Save the department to the repository
//        departmentRepository.save(department);
//    }
//
//
//    public void deleteDepartmentById(long id) {
//        departmentRepository.deleteById(id);
//    }
//
//    public Department findDepartmentById(long id) {
//        return departmentRepository.findById(id)
//                .orElseThrow(
//                        () -> new RuntimeException("Department Not found With this ID")
//                );
//    }
//
//
//    @Transactional
//    public Department updateDepartment(long id, Department updateDepartment, MultipartFile imageFile) throws IOException {
//        Department existingDepartment = departmentRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Department not found with this ID"));
//        // Update department details
//        existingDepartment.setName(updateDepartment.getName());
//        existingDepartment.setCell(updateDepartment.getCell());
//        existingDepartment.setEmail(updateDepartment.getEmail());
//        existingDepartment.setEmployeeNum(updateDepartment.getEmployeeNum());
//
//        // Update department
//        Branch branch = branchRepository.findById((long) updateDepartment.getBranch().getId())
//                .orElseThrow(() -> new RuntimeException("Branch with this ID not found"));
//        existingDepartment.setBranch(branch);
//
//        // Update image if provided
//        if (imageFile != null && !imageFile.isEmpty()) {
//            String imageFilename = saveImage(imageFile, existingDepartment);
//            existingDepartment.setDepImage(imageFilename);
//        }
//        departmentRepository.save(existingDepartment);
//        return existingDepartment;
//    }
//
//
//    public Department findDepartmentByName(String name) {
//        return departmentRepository.findDepartmentByName(name);
//    }
//
//    public List<Department> findDepartmentByBranchName(String branchName) {
//        return departmentRepository.findDepartmentByBranchName(branchName);
//    }
//
//    private String saveImage(MultipartFile file, Department department) throws IOException {
//        Path uploadPath = Paths.get(uploadDirectory + "/department");
//        if (!Files.exists(uploadPath)) {
//            Files.createDirectories(uploadPath);
//        }
//
//        // Generate a unique filename
//        String filename = department.getName() + "_" + UUID.randomUUID().toString();
//        Path filePath = uploadPath.resolve(filename);
//
//        // Save the file
//        Files.copy(file.getInputStream(), filePath);
//
//        return filename; // Return the filename for storing in the database
//    }
//
//}
