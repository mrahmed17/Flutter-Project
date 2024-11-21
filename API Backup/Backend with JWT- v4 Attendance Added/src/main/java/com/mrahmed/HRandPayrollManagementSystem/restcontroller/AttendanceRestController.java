package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.service.AttendanceService;
import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/attendance")
@CrossOrigin("*")
public class AttendanceRestController {

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private UserService userService;

    @PostMapping("/checkin")
    public ResponseEntity<?> checkIn(@RequestBody Map<String, Object> request) {
        try {
            long userId = Long.parseLong(request.get("userId").toString());
            Attendance attendance = attendanceService.checkIn(userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(attendance);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error occurred while checking in: " + e.getMessage());
        }
    }

    @PutMapping("/checkout")
    public ResponseEntity<?> checkOut(@RequestBody Map<String, Object> request) {
        try {
            long userId = Long.parseLong(request.get("userId").toString());
            Attendance attendance = attendanceService.checkOut(userId);
            return ResponseEntity.ok(attendance);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error occurred while checking out: " + e.getMessage());
        }
    }

    @GetMapping("/overtime/{userId}")
    public ResponseEntity<Page<Attendance>> getOvertimeByUser(
            @PathVariable Long userId,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> overtimeRecords = attendanceService.getOvertimeForUser(userId, startDate, endDate, pageable);

        if (overtimeRecords.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok(overtimeRecords);
    }

    @GetMapping("/today")
    public ResponseEntity<Page<Attendance>> getTodayAttendance(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> attendances = attendanceService.getTodayAttendances(pageable);
        if (attendances.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/")
    public ResponseEntity<Page<Attendance>> getAllAttendances(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> attendances = attendanceService.getAllAttendances(pageable);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }


    @GetMapping("/find/{id}")
    public ResponseEntity<Attendance> findAttendanceById(@PathVariable("id") long id) {
        Attendance attendance = attendanceService.findAttendanceById(id);
        return ResponseEntity.ok(attendance);
    }

    @GetMapping("/user/{id}/attendances")
    public ResponseEntity<Page<Attendance>> getAttendancesByUserId(
            @PathVariable Long id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> attendances = attendanceService.getAttendanceByUserId(id, pageable);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/attendanceRange")
    public ResponseEntity<Map<User, Long>> getUsersWithAttendanceInRange(
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);  // Add pageable here
        Map<User, Long> userAttendance = attendanceService.getUsersAttendanceInRange(startDate, endDate, pageable);

        if (userAttendance.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }

        return ResponseEntity.ok(userAttendance);
    }


    @GetMapping("/usersWithoutAttendanceToday")
    public ResponseEntity<Page<User>> getUsersWithoutAttendanceToday(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);  // Add pageable here
        Page<User> usersWithoutAttendanceToday = attendanceService.findUsersWithoutAttendanceToday(pageable);

        return ResponseEntity.ok(usersWithoutAttendanceToday);
    }


    @GetMapping("/peakAttendanceDay")
    public ResponseEntity<Page<Object[]>> getPeakAttendanceDay(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);  // Add pageable here
        Page<Object[]> peakAttendanceDay = attendanceService.getPeakAttendanceDay(pageable);

        if (peakAttendanceDay.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(peakAttendanceDay);
    }

    @GetMapping("/peakAttendanceMonth")
    public ResponseEntity<Page<Object[]>> getPeakAttendanceMonth(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);  // Add pageable here
        Page<Object[]> peakAttendanceMonth = attendanceService.getPeakAttendanceMonth(pageable);

        if (peakAttendanceMonth.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(peakAttendanceMonth);
    }

    @GetMapping("/lateCheckIns")
    public ResponseEntity<Page<Attendance>> getLateCheckIns(
            @RequestParam("lateTime") String lateTime,
            @RequestParam("startDate") LocalDate startDate,
            @RequestParam("endDate") LocalDate endDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> lateCheckIns = attendanceService.getLateCheckIns(lateTime, startDate, endDate, pageable);
        if (lateCheckIns.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(lateCheckIns);
    }

    @GetMapping("/searchByName")
    public ResponseEntity<Page<Attendance>> getAttendancesByUserNamePart(
            @RequestParam("name") String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> attendances = attendanceService.getAttendancesByUserNamePart(name, pageable);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/roleAttendance")
    public ResponseEntity<Page<Attendance>> getAttendanceByRoleAndDateRange(
            @RequestParam("role") String role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> attendances = attendanceService.getAttendanceByRole(role, pageable);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/todayAttendance/{userId}")
    public ResponseEntity<Page<Attendance>> getTodayAttendanceByUserId(
            @PathVariable("userId") long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Attendance> todayAttendance = attendanceService.getTodayAttendanceByUserId(userId, pageable);
        if (todayAttendance.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(todayAttendance);
    }
}
