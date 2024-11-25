package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.repository.AttendanceRepository;
import com.mrahmed.HRandPayrollManagementSystem.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/attendances")
@CrossOrigin("*")
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    @PostMapping("/check-in/{userId}")
    public ResponseEntity<Attendance> checkIn(@PathVariable Long userId) {
        Attendance attendance = attendanceService.checkIn(userId);
        return ResponseEntity.ok(attendance);
    }

    @PostMapping("/check-out/{userId}")
    public ResponseEntity<Attendance> checkOut(@PathVariable Long userId) {
        Attendance attendance = attendanceService.checkOut(userId);
        return ResponseEntity.ok(attendance);
    }

    @GetMapping("/monthly-count/{userId}")
    public ResponseEntity<Long> getMonthlyAttendanceCount(@PathVariable Long userId) {
        long count = attendanceService.getMonthlyAttendanceCount(userId);
        return ResponseEntity.ok(count);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Attendance>> getAttendancesByUserId(@PathVariable Long userId) {
        List<Attendance> attendances = attendanceService.findAllAttendancesByUserId(userId);
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/today")
    public ResponseEntity<List<Attendance>> getTodayTotalAttendance() {
        List<Attendance> attendances = attendanceService.getTodayTotalAttendance();
        return ResponseEntity.ok(attendances);
    }

}
