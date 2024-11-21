package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.AttendanceRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AttendanceService {
    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private UserRepository userRepository;


    // Check-in method
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

    // Check-out method
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

    // Method to get overtime for a user within a date range with pagination
    public Page<Attendance> getOvertimeForUser(Long userId, LocalDate startDate, LocalDate endDate, Pageable pageable) {
        Page<Attendance> attendances = attendanceRepository.findAttendancesByUserIdAndDateRange(userId, startDate, endDate, pageable);
        return attendances.map(this::filterOvertime);
    }

    // Check if the attendance record contains overtime
    private Attendance filterOvertime(Attendance attendance) {
        if (attendance.getClockInTime() == null || attendance.getClockOutTime() == null) {
            return null; // Skip records with missing times
        }
        Duration duration = Duration.between(attendance.getClockInTime(), attendance.getClockOutTime());
        long hours = duration.toHours();
        return hours > 8 ? attendance : null; // Return only overtime records
    }

    // Fetch today's attendance with pagination
    public Page<Attendance> getTodayAttendances(Pageable pageable) {
        return attendanceRepository.findAttendancesForToday(LocalDate.now(), pageable);
    }

    // Fetch all attendance records with pagination
    public Page<Attendance> getAllAttendances(Pageable pageable) {
        return attendanceRepository.findAll(pageable);
    }

    // Find attendance by ID
    public Attendance findAttendanceById(long id) {
        return attendanceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Attendance not found with id: " + id));
    }

    // Get users' attendance count in a date range with pagination
    public Map<User, Long> getUsersAttendanceInRange(LocalDate startDate, LocalDate endDate, Pageable pageable) {
        Page<Attendance> attendances = attendanceRepository.findAttendancesInRange(startDate, endDate, pageable);
        return attendances.getContent().stream()
                .collect(Collectors.groupingBy(Attendance::getUser, Collectors.counting()));
    }

    @Transactional
    // Get all attendance records for a specific user with pagination
    public Page<Attendance> getAttendanceByUserId(Long id, Pageable pageable) {
        return attendanceRepository.findAllByUserId(id, pageable);
    }

    // Find users without attendance today with pagination
    public Page<User> findUsersWithoutAttendanceToday(Pageable pageable) {
        return attendanceRepository.findUsersWithoutAttendanceForToday(LocalDate.now(), pageable);
    }

    // Fetch peak attendance day with pagination
    public Page<Object[]> getPeakAttendanceDay(Pageable pageable) {
        return attendanceRepository.findPeakAttendanceDay(pageable);
    }

    // Fetch peak attendance month with pagination
    public Page<Object[]> getPeakAttendanceMonth(Pageable pageable) {
        return attendanceRepository.findPeakAttendanceMonth(pageable);
    }

    // Get late check-ins with pagination
    public Page<Attendance> getLateCheckIns(String lateTime, LocalDate startDate, LocalDate endDate, Pageable pageable) {
        return attendanceRepository.findLateCheckIns(lateTime, startDate, endDate, pageable);
    }

    // Search attendance records by userName with pagination
    public Page<Attendance> getAttendancesByUserNamePart(String name, Pageable pageable) {
        return attendanceRepository.findAttendancesByUserNamePart(name, pageable);
    }

    // Filter attendance by user role and date range with pagination
    public Page<Attendance> getAttendanceByRole(String role, Pageable pageable) {
        return attendanceRepository.findAttendanceByRole(role, pageable);
    }

    // Get today's attendance by user ID with pagination
    public Page<Attendance> getTodayAttendanceByUserId(long userId, Pageable pageable) {
        return attendanceRepository.findTodayAttendanceByUserId(userId, pageable);
    }

}