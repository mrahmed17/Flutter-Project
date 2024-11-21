//package com.mrahmed.HRandPayrollManagementSystem.service;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Department;
//import com.mrahmed.HRandPayrollManagementSystem.repository.DepartmentRepository;
//import com.mrahmed.HRandPayrollManagementSystem.util.PhotoService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
//import java.time.LocalDateTime;
//import java.util.List;
//
//@Service
//public class DepartmentService {
//
//    @Autowired
//    private DepartmentRepository departmentRepository;
//
//    @Autowired
//    private PhotoService photoService;
//
//    public String saveDepartmentImage(MultipartFile file, String fullName) throws IOException {
//        return photoService.savePhoto(file, fullName, "departmentPhotos");
//    }
//
//    // Create a department with an optional photo upload
//    @Transactional
//    public Department createDepartment(Department department, MultipartFile departmentPhotos) throws IOException {
//        if (departmentPhotos != null && !departmentPhotos.isEmpty()) {
//            String departmentPhotoPath = saveDepartmentImage(departmentPhotos, department.getName());
//            department.setDepImage(departmentPhotoPath);
//        }
//        return departmentRepository.save(department);
//    }
//
////    @Value("${upload.directory}")
////    private String uploadDir;
//
////    // Save department image to disk and return the file path
////    private String saveDepartmentImage(MultipartFile file, String fullName) throws IOException {
////        Path uploadPath = Paths.get(uploadDir + "departmentPhotos").toAbsolutePath().normalize();
////        if (!Files.exists(uploadPath)) {
////            Files.createDirectories(uploadPath);
////        }
////        String originalFilename = file.getOriginalFilename();
////        String fileExtension = (originalFilename != null && originalFilename.contains("."))
////                ? originalFilename.substring(originalFilename.lastIndexOf("."))
////                : "";
////        String sanitizedFullName = fullName.replaceAll("[^a-zA-Z0-9]", "_");
////        sanitizedFullName = sanitizedFullName.substring(0, Math.min(sanitizedFullName.length(), 25));
////        String uniqueFilename = sanitizedFullName + "_" + UUID.randomUUID() + fileExtension;
////        Path filePath = uploadPath.resolve(uniqueFilename).normalize();
////        Files.copy(file.getInputStream(), filePath);
////        return uniqueFilename;
////    }
//
//    // Fetch all departments
//    public List<Department> getAllDepartments() {
//        return departmentRepository.findAll();
//    }
//
//    // Find department by ID
//    public Department findDepartmentById(long id) {
//        return departmentRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Department not found with this ID"));
//    }
//
//    // Update an existing department, with optional photo update
//    @Transactional
//    public void updateDepartment(long id, Department updateDepartment, MultipartFile departmentPhoto) throws IOException {
//        Department existingDepartment = departmentRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Department not found with ID: " + id));
//
//        existingDepartment.setName(updateDepartment.getName());
//        existingDepartment.setCell(updateDepartment.getCell());
//        existingDepartment.setEmail(updateDepartment.getEmail());
//        existingDepartment.setEmployeeNum(updateDepartment.getEmployeeNum());
//
//        if (departmentPhoto != null && !departmentPhoto.isEmpty()) {
//            String imageFilename = saveDepartmentImage(departmentPhoto, updateDepartment.getName());
//            existingDepartment.setDepImage(imageFilename);
//        }
//
//        departmentRepository.save(existingDepartment);
//    }
//
//    // Delete department by ID
//    public void deleteDepartmentById(long id) {
//        departmentRepository.deleteById(id);
//    }
//
//    // Find departments by name
//    public List<Department> findDepartmentByName(String name) {
//        return departmentRepository.findDepartmentByName(name);
//    }
//
//    // Find departments by branch name
//    public List<Department> findDepartmentByBranchName(String branchName) {
//        return departmentRepository.findAllDepartmentByBranchName(branchName);
//    }
//
//    // Find departments by branch ID
//    public List<Department> findDepartmentsByBranchId(Long branchId) {
//        return departmentRepository.findDepartmentsByBranchId(branchId);
//    }
//
//    // Find departments by employee count greater than or equal to a certain value
//    public List<Department> findDepartmentsByMinEmployeeCount(int minEmployeeCount) {
//        return departmentRepository.findDepartmentsByMinEmployeeCount(minEmployeeCount);
//    }
//
//    // Find departments by employee count less than a certain value
//    public List<Department> findDepartmentsByMaxEmployeeCount(int maxEmployeeCount) {
//        return departmentRepository.findDepartmentsByMaxEmployeeCount(maxEmployeeCount);
//    }
//
//    // Find a department by its email address
//    public Department findDepartmentByEmail(String email) {
//        return departmentRepository.findDepartmentByEmail(email);
//    }
//
//    // Find departments created within a specific date range
//    public List<Department> findDepartmentsByCreatedAtRange(LocalDateTime startDate, LocalDateTime endDate) {
//        return departmentRepository.findDepartmentsByCreatedAtRange(startDate, endDate);
//    }
//
//    // Count the number of departments in a given branch
//    public long countDepartmentsByBranchId(Long branchId) {
//        return departmentRepository.countDepartmentsByBranchId(branchId);
//    }
//
//    // Find departments with no employees
//    public List<Department> findDepartmentsWithNoEmployees() {
//        return departmentRepository.findDepartmentsWithNoEmployees();
//    }
//
//    // Find departments updated after a specific date
//    public List<Department> findDepartmentsUpdatedAfter(LocalDateTime updateDate) {
//        return departmentRepository.findDepartmentsUpdatedAfter(updateDate);
//    }
//
//}
