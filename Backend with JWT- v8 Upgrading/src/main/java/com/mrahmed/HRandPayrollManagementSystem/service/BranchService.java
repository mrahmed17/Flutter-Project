//package com.mrahmed.HRandPayrollManagementSystem.service;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.Branch;
//import com.mrahmed.HRandPayrollManagementSystem.repository.BranchRepository;
//import com.mrahmed.HRandPayrollManagementSystem.util.PhotoService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.IOException;
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
//    @Autowired
//    private PhotoService photoService;
//
//    public String saveProfileImage(MultipartFile file, String fullName) throws IOException {
//        return photoService.savePhoto(file, fullName, "branchPhotos");
//    }
//
//    // Reusable Method for Photo Handling
//    private void handleBranchPhoto(MultipartFile branchPhoto, Branch branch) {
//        if (branchPhoto != null && !branchPhoto.isEmpty()) {
//            try {
//                String branchPhotoPath = saveProfileImage(branchPhoto, branch.getName());
//                branch.setBranchImage(branchPhotoPath);
//            } catch (IOException e) {
//                throw new RuntimeException("Error saving branch photo", e);
//            }
//        }
//    }
//
//    @Transactional
//    public Branch createBranch(Branch branch, MultipartFile branchPhoto) {
//        handleBranchPhoto(branchPhoto, branch);
//        return branchRepository.save(branch);
//    }
//
////    @Value("${upload.directory}")
////    private String uploadDir;
//
////    public String saveBranchImage(MultipartFile file, String fullName) throws IOException {
////        Path uploadPath = Paths.get(uploadDir, "branchPhotos").toAbsolutePath().normalize();
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
//
//    @Transactional
//    public void updateBranch(long id, Branch updatedBranch, MultipartFile branchPhoto) throws IOException {
//        Branch existingBranch = branchRepository.findById(id)
//                .orElseThrow(() -> new RuntimeException("Branch Not Found by this Id: " + id));
//
//        existingBranch.setName(updatedBranch.getName());
//        existingBranch.setAddress(updatedBranch.getAddress());
//        existingBranch.setCell(updatedBranch.getCell());
//        existingBranch.setEmail(updatedBranch.getEmail());
//        handleBranchPhoto(branchPhoto, existingBranch);
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
//                .orElseThrow(() -> new RuntimeException("Branch Not Found by this Id"));
//    }
//
//    public List<Branch> getAllBranches() {
//        return branchRepository.findAll();
//    }
//
//    public Branch findBranchByName(String name) {
//        return branchRepository.findBranchByName(name);
//    }
//
//    public List<Branch> findBranchesByAddressKeyword(String keyword) {
//        return branchRepository.findBranchesByAddressKeyword(keyword);
//    }
//
//    public Branch findBranchByEmail(String email) {
//        return branchRepository.findBranchByEmail(email);
//    }
//
//    public Long countBranches() {
//        return branchRepository.countBranches();
//    }
//
//}
