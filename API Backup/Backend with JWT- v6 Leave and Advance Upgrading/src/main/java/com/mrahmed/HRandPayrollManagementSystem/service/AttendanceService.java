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
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AttendanceService {

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private UserRepository userRepository;

    public Attendance checkIn(Long userId) {
        // Check if user already checked in today
        Optional<Attendance> existingAttendance = attendanceRepository.findByUserIdAndDate(userId, LocalDate.now())
                .stream()
                .findFirst();

        if (existingAttendance.isPresent()) {
            throw new IllegalStateException("User has already checked in today.");
        }

        // Create new attendance record for today
        Attendance attendance = new Attendance();
        attendance.setUser(new User(userId));
        attendance.setDate(LocalDate.now());
        attendance.setClockInTime(LocalDateTime.now());
        attendance.setLateCheckIn(LocalDateTime.now().getHour() > 9); // Adjust logic as needed

        return attendanceRepository.save(attendance);
    }

    public Attendance checkOut(Long userId) {
        // Fetch today's attendance record
        Optional<Attendance> optionalAttendance = attendanceRepository.findByUserIdAndDate(userId, LocalDate.now())
                .stream()
                .findFirst();

        if (optionalAttendance.isEmpty()) {
            throw new IllegalStateException("No check-in record found for today.");
        }

        Attendance attendance = optionalAttendance.get();

        if (attendance.getClockOutTime() != null) {
            throw new IllegalStateException("User has already checked out today.");
        }

        // Set clock-out time and calculate overtime
        attendance.setClockOutTime(LocalDateTime.now());
        attendance.setOvertimeHours(calculateOvertime(attendance));

        return attendanceRepository.save(attendance);
    }

    private double calculateOvertime(Attendance attendance) {
        if (attendance.getClockOutTime() == null || attendance.getClockInTime() == null) return 0;
        Duration duration = Duration.between(attendance.getClockInTime(), attendance.getClockOutTime());
        return Math.max(0, duration.toHours() - 8); // Assuming 8 hours as standard workday
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


    public List<Attendance> getTodayAttendanceByUserId(long userId) {
        return attendanceRepository.findTodayAttendanceByUserId(userId);
    }

    public List<Attendance> getTodayAttendances() {
        return attendanceRepository.findAttendancesForToday(LocalDate.now());
    }

//    public List<Attendance> getAllAttendances() {
//        return attendanceRepository.findAll();
//    }

    public Attendance findAttendanceById(long id) {
        return attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance not found with ID: " + id));
    }

    public List<Attendance> getAttendanceHistory(Long userId) {
        return attendanceRepository.findByUserIdAndDate(userId, LocalDate.now());
    }

    public List<User> getUsersWithoutAttendance(LocalDate date) {
        return attendanceRepository.findUsersWithoutAttendance(date);
    }

    public List<Attendance> getLateAttendances() {
        return attendanceRepository.findLateAttendances();
    }

    public List<Attendance> getAttendanceByUserName(String name) {
        return attendanceRepository.findAttendancesByUserNamePart(name);
    }

    public List<Attendance> getAllAttendancesByUserId(Long userId) {
        return attendanceRepository.findAllByUserId(userId);
    }


    public List<Object[]> getPeakAttendanceDay() {
        return attendanceRepository.findPeakAttendanceDay();
    }

    public List<Object[]> getPeakAttendanceMonth() {
        return attendanceRepository.findPeakAttendanceMonth();
    }
    public List<Attendance> getAttendancesByUserNamePart(String name) {
        return attendanceRepository.findAttendancesByUserNamePart(name);
    }

    public List<Attendance> getAttendanceByRole(String role) {
        return attendanceRepository.findAttendanceByRole(role);
    }

}
