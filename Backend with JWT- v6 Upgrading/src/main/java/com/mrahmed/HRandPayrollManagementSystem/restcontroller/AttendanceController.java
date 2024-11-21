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
    @Autowired
    private AttendanceRepository attendanceRepository;

    @PostMapping("/{userId}/check-in")
    public ResponseEntity<?> checkIn(@PathVariable Long userId) {
        try {
            Attendance attendance = attendanceService.checkIn(userId);
            return ResponseEntity.ok(attendance);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", e.getMessage(), "status", HttpStatus.CONFLICT.value()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "An unexpected error occurred.", "status", HttpStatus.INTERNAL_SERVER_ERROR.value()));
        }
    }


    @PostMapping("/{userId}/check-out")
    public ResponseEntity<Attendance> checkOut(@PathVariable Long userId) {
        try {
            Attendance attendance = attendanceService.checkOut(userId);
            return ResponseEntity.ok(attendance);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(null);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @GetMapping("/{userId}/history")
    public ResponseEntity<List<Attendance>> getAttendanceHistory(@PathVariable Long userId) {
        return ResponseEntity.ok(attendanceService.getAttendanceHistory(userId));
    }

    @GetMapping("/no-attendance/{date}")
    public ResponseEntity<List<User>> getUsersWithoutAttendance(@PathVariable LocalDate date) {
        return ResponseEntity.ok(attendanceService.getUsersWithoutAttendance(date));
    }

    @GetMapping("/late-attendances")
    public ResponseEntity<List<Attendance>> getLateAttendances() {
        return ResponseEntity.ok(attendanceService.getLateAttendances());
    }

    @GetMapping("/search")
    public ResponseEntity<List<Attendance>> searchAttendanceByUserName(@RequestParam String name) {
        return ResponseEntity.ok(attendanceService.getAttendanceByUserName(name));
    }

    @GetMapping("/export")
    public ResponseEntity<byte[]> exportAttendanceReport() {
        // Placeholder for CSV/Excel export logic
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=attendance_report.csv");
        return new ResponseEntity<>(new byte[0], headers, HttpStatus.OK);
    }

    @GetMapping("/overtime/{userId}")
    public ResponseEntity<List<Attendance>> getOvertimeByUser(
            @PathVariable Long userId,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        List<Attendance> overtimeRecords = attendanceService.getOvertimeForUser(userId, startDate, endDate);

        if (overtimeRecords.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(overtimeRecords);
    }

    @GetMapping("/today")
    public ResponseEntity<List<Attendance>> getTodayAttendance() {
        try {
            List<Attendance> attendances = attendanceService.getTodayAttendances();
            return attendances.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendances);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @GetMapping("/")
    public ResponseEntity<List<Attendance>> getAllAttendances(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        try {
            Page<Attendance> attendancesPage = attendanceRepository.findAll(PageRequest.of(page, size));
            return attendancesPage.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendancesPage.getContent());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @GetMapping("/find/{id}")
    public ResponseEntity<Attendance> findAttendanceById(@PathVariable("id") long id) {
        try {
            Attendance attendance = attendanceService.findAttendanceById(id);
            return attendance == null
                    ? ResponseEntity.status(HttpStatus.NOT_FOUND).build()
                    : ResponseEntity.ok(attendance);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(null);
        }
    }

    @GetMapping("/user/{id}/attendances")
    public ResponseEntity<List<Attendance>> getAttendancesByUserId(@PathVariable Long id) {
        try {
            List<Attendance> attendances = attendanceService.getAttendanceByUserId(id);
            return attendances.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendances);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }


    @GetMapping("/peakAttendanceDay")
    public ResponseEntity<List<Object[]>> getPeakAttendanceDay() {
        try {
            List<Object[]> peakAttendanceDay = attendanceService.getPeakAttendanceDay();
            return peakAttendanceDay.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(peakAttendanceDay);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @GetMapping("/peakAttendanceMonth")
    public ResponseEntity<List<Object[]>> getPeakAttendanceMonth() {
        try {
            List<Object[]> peakAttendanceMonth = attendanceService.getPeakAttendanceMonth();
            return peakAttendanceMonth.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(peakAttendanceMonth);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }


    @GetMapping("/searchByName")
    public ResponseEntity<List<Attendance>> getAttendancesByUserNamePart(@RequestParam("name") String name) {
        try {
            List<Attendance> attendances = attendanceService.getAttendancesByUserNamePart(name);
            return attendances.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendances);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @GetMapping("/roleAttendance")
    public ResponseEntity<List<Attendance>> getAttendanceByRole(
            @RequestParam("role") String role) {
        try {
            List<Attendance> attendances = attendanceService.getAttendanceByRole(role);
            return attendances.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendances);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

    @GetMapping("/todayAttendance/{userId}")
    public ResponseEntity<List<Attendance>> getTodayAttendanceByUserId(@PathVariable long userId) {
        try {
            List<Attendance> todayAttendance = attendanceService.getTodayAttendanceByUserId(userId);
            return todayAttendance.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(todayAttendance);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Collections.emptyList());
        }
    }

}
