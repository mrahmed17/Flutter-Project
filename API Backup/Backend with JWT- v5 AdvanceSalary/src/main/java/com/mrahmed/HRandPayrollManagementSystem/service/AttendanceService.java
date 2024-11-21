package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.AttendanceRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AttendanceService {

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private UserRepository userRepository;

//    @Autowired
//    private BiometricService biometricService;

//    public Attendance checkIn(long userId, String biometricData, AttendanceMethod method) {
//        // Retrieve user
//        User user = userRepository.findById(userId)
//                .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
//
//        // Check if user already checked in today
//        if (attendanceRepository.countByUserIdAndDate(userId, LocalDate.now()) > 0) {
//            throw new RuntimeException("User has already checked in today.");
//        }
//
//        // Verify biometric data if method is biometric
//        if (method == AttendanceMethod.FINGERPRINT &&
//                !biometricService.verifyFingerprint(biometricData, user.getFingerprintTemplate())) {
//            throw new RuntimeException("Fingerprint verification failed.");
//        }
//
//        if (method == AttendanceMethod.FACE_SCAN &&
//                !biometricService.verifyFaceScan(biometricData, user.getFaceScanTemplate())) {
//            throw new RuntimeException("Face scan verification failed.");
//        }
//
//        // Save attendance
//        Attendance attendance = new Attendance();
//        attendance.setDate(LocalDate.now());
//        attendance.setClockInTime(LocalDateTime.now());
//        attendance.setUser(user);
//        attendance.setMethod(method);
//        attendance.setFingerprintHash(method == AttendanceMethod.FINGERPRINT ? biometricData : null);
//        attendance.setFaceScanVector(method == AttendanceMethod.FACE_SCAN ? biometricData : null);
//
//        return attendanceRepository.save(attendance);
//    }


    public Attendance checkIn(long userId) {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found with ID: " + userId));
            if (attendanceRepository.countByUserIdAndDate(userId, LocalDate.now()) > 0) {
                throw new RuntimeException("User has already checked in today.");
            }
            Attendance attendance = new Attendance();
            attendance.setDate(LocalDate.now());
            attendance.setClockInTime(LocalDateTime.now());
            attendance.setUser(user);
            return attendanceRepository.save(attendance);
        } catch (Exception e) {
            throw new RuntimeException("Error occurred while checking in: " + e.getMessage(), e);
        }
    }

//    public Attendance checkOut(long userId) {
//        // Retrieve last attendance for today
//        Attendance attendance = attendanceRepository.findLastAttendanceForUser(userId, LocalDate.now())
//                .orElseThrow(() -> new RuntimeException("No check-in record found for today's check-out."));
//
//        // Check if already checked out
//        if (attendance.getClockOutTime() != null) {
//            throw new RuntimeException("User has already checked out today.");
//        }
//
//        // Update clock-out time
//        attendance.setClockOutTime(LocalDateTime.now());
//        return attendanceRepository.save(attendance);
//    }

    public Attendance checkOut(long userId) {
        try {
            Attendance attendance = attendanceRepository.findLastAttendanceForUser(userId, LocalDate.now())
                    .orElseThrow(() -> new RuntimeException("No check-in found for today's check-out"));
            if (attendance.getClockOutTime() != null) {
                throw new RuntimeException("User has already checked out today.");
            }
            attendance.setClockOutTime(LocalDateTime.now());
            return attendanceRepository.save(attendance);
        } catch (Exception e) {
            throw new RuntimeException("Error occurred while checking out: " + e.getMessage(), e);
        }
    }

    public List<Attendance> getOvertimeForUser(Long userId, LocalDate startDate, LocalDate endDate) {
        List<Attendance> attendances = attendanceRepository.findAttendancesByUserIdAndDateRange(userId, startDate, endDate);
        return attendances.stream()
                .filter(this::isOvertime)
                .collect(Collectors.toList());
    }

    private boolean isOvertime(Attendance attendance) {
        if (attendance.getClockInTime() == null || attendance.getClockOutTime() == null) {
            return false; // Skip records with missing times
        }
        Duration duration = Duration.between(attendance.getClockInTime(), attendance.getClockOutTime());
        long hours = duration.toHours();
        return hours > 8; // Assuming a workday is 8 hours
    }

    public List<Attendance> getTodayAttendances() {
        return attendanceRepository.findAttendancesForToday(LocalDate.now());
    }

    public List<Attendance> getAllAttendances() {
        return attendanceRepository.findAll();
    }

    public Attendance findAttendanceById(long id) {
        return attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance not found with ID: " + id));
    }

    public Map<User, Long> getUsersAttendanceInRange(LocalDate startDate, LocalDate endDate) {
        List<Attendance> attendances = attendanceRepository.findAttendancesInRange(startDate, endDate);
        return attendances.stream()
                .collect(Collectors.groupingBy(Attendance::getUser, Collectors.counting()));
    }

    public List<Attendance> getAttendanceByUserId(Long userId) {
        return attendanceRepository.findAllByUserId(userId);
    }

    public List<User> findUsersWithoutAttendanceToday() {
        return attendanceRepository.findUsersWithoutAttendanceForToday(LocalDate.now());
    }

    public List<Object[]> getPeakAttendanceDay() {
        return attendanceRepository.findPeakAttendanceDay();
    }

    public List<Object[]> getPeakAttendanceMonth() {
        return attendanceRepository.findPeakAttendanceMonth();
    }

    public List<Attendance> getLateCheckIns(LocalDate startDate, LocalDate endDate, LocalDateTime lateTime) {
        return attendanceRepository.findLateCheckIns(lateTime.toString(), startDate, endDate);
    }

    public List<Attendance> getAttendancesByUserNamePart(String name) {
        return attendanceRepository.findAttendancesByUserNamePart(name);
    }

    public List<Attendance> getAttendanceByRole(String role) {
        return attendanceRepository.findAttendanceByRole(role);
    }

    public List<Attendance> getTodayAttendanceByUserId(long userId) {
        return attendanceRepository.findTodayAttendanceByUserId(userId);
    }
}
