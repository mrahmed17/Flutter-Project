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
        // Ensure no duplicate check-ins for the day
        List<Attendance> existing = attendanceRepository.findByUserIdAndDate(userId, LocalDate.now());
        if (!existing.isEmpty()) {
            throw new IllegalStateException("User has already checked in today.");
        }

        // Fetch the user from the database
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with ID: " + userId));

        // Save new check-in
        Attendance attendance = new Attendance();
        attendance.setUser(user);
        attendance.setDate(LocalDate.now());
        attendance.setClockInTime(LocalDateTime.now());
        attendance.setLateCheckIn(LocalDateTime.now().getHour() > 9); // Late check-in logic
        return attendanceRepository.save(attendance);
    }


//    public Attendance checkIn(Long userId) {
//        // Ensure no duplicate check-ins for the day
//        List<Attendance> existing = attendanceRepository.findByUserIdAndDate(userId, LocalDate.now());
//        if (!existing.isEmpty()) {
//            throw new IllegalStateException("User has already checked in today.");
//        }
//
//        // Save new check-in
//        Attendance attendance = new Attendance();
//        attendance.setUser(new User(userId));
//        attendance.setDate(LocalDate.now());
//        attendance.setClockInTime(LocalDateTime.now());
//        attendance.setLateCheckIn(LocalDateTime.now().getHour() > 9); // Late check-in logic
//        return attendanceRepository.save(attendance);
//    }

    public Attendance checkOut(Long userId) {
        // Find today's attendance
        List<Attendance> existing = attendanceRepository.findByUserIdAndDate(userId, LocalDate.now());
        if (existing.isEmpty()) {
            throw new IllegalStateException("User has not checked in today.");
        }

        Attendance attendance = existing.get(0); // Assuming only one record per day
        if (attendance.getClockOutTime() != null) {
            throw new IllegalStateException("User has already checked out today.");
        }

        // Update attendance with check-out time
        attendance.setClockOutTime(LocalDateTime.now());
        return attendanceRepository.save(attendance);
    }

    public long getMonthlyAttendanceCount(Long userId) {
        return attendanceRepository.countMonthlyAttendance(userId, LocalDate.now());
    }

    public List<Attendance> findAllAttendancesByUserId(Long userId) {
        return attendanceRepository.findAllByUserId(userId);
    }

    public List<Attendance> getTodayTotalAttendance() {
        return attendanceRepository.findByDate(LocalDate.now());
    }
}
