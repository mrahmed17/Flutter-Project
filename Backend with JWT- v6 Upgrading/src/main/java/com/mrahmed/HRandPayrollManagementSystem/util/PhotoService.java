package com.mrahmed.HRandPayrollManagementSystem.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class PhotoService {

    private static final Logger logger = LoggerFactory.getLogger(PhotoService.class);

    @Value("${upload.directory}")
    private String uploadDir;


    /**
     * implement note for reusing in future

     * Saves a photo to a specified directory with a unique filename.
     *
     * @param file     the photo file to save
     * @param fullName the full name used to generate the filename
     * @param folderName the folder where the photo will be saved
     * @return the unique filename of the saved photo
     * @throws IOException if an I/O error occurs
     */
    public String savePhoto(MultipartFile file, String fullName, String folderName) throws IOException {
        validateFile(file);
        Path uploadPath = createUploadDirectory(folderName);
        String uniqueFilename = generateUniqueFilename(file.getOriginalFilename(), fullName);
        Path filePath = uploadPath.resolve(uniqueFilename).normalize();

        try {
            Files.copy(file.getInputStream(), filePath);
            logger.info("Successfully saved photo: {}", filePath);
        } catch (IOException e) {
            logger.error("Failed to save photo: {}", filePath, e);
            throw e; // Re-throw the exception after logging
        }

        return uniqueFilename;
    }

    private Path createUploadDirectory(String folderName) throws IOException {
        Path uploadPath = Paths.get(uploadDir, folderName).toAbsolutePath().normalize();
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            logger.info("Created directory: {}", uploadPath);
        }
        return uploadPath;
    }

    private String generateUniqueFilename(String originalFilename, String fullName) {
        String fileExtension = getFileExtension(originalFilename);
        String sanitizedFullName = sanitizeFullName(fullName);
        return sanitizedFullName + "_" + UUID.randomUUID() + fileExtension;
    }

    private String getFileExtension(String originalFilename) {
        if (originalFilename != null && originalFilename.contains(".")) {
            return originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        return "";
    }

    private String sanitizeFullName(String fullName) {
        String sanitizedFullName = fullName.replaceAll("[^a-zA-Z0-9]", "_");
        return sanitizedFullName.substring(0, Math.min(sanitizedFullName.length(), 25));
    }

    private void validateFile(MultipartFile file) {
        if (file.isEmpty()) {
            throw new IllegalArgumentException("File must not be empty");
        }
        String contentType = file.getContentType();
        if (!List.of("image/jpeg", "image/png").contains(contentType)) {
            throw new IllegalArgumentException("Invalid file type. Only JPEG and PNG are supported");
        }
        long maxSizeInBytes = 2 * 1024 * 1024; // 2 MB
        if (file.getSize() > maxSizeInBytes) {
            throw new IllegalArgumentException("File size exceeds the maximum limit of 2 MB");
        }
        logger.info("Validating file: {}", file.getOriginalFilename());
    }


//    private void validateFile(MultipartFile file) {
//        if (file.isEmpty()) {
//            throw new IllegalArgumentException("File must not be empty");
//        }
//        // Additional validations can be added here (e.g., file size, file type)
//        logger.info("Validating file: {}", file.getOriginalFilename());
//    }
}