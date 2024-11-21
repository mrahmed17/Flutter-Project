package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.service.AttendanceService;
import com.mrahmed.HRandPayrollManagementSystem.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
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
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error occurred while checking out");
        }
    }


    @GetMapping("/overtime/{userId}")
    public ResponseEntity<List<Attendance>> getOvertimeByUser(
            @PathVariable Long userId,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {

        List<Attendance> overtimeRecords = attendanceService.getOvertimeForUser(userId, startDate, endDate);

        if (overtimeRecords.isEmpty()) {
            return ResponseEntity.noContent().build(); // Return 204 if no overtime found
        }

        return ResponseEntity.ok(overtimeRecords); // Return the list of overtime records
    }


    @GetMapping("/today")
    public ResponseEntity<List<Attendance>> getTodayAttendance() {
        List<Attendance> attendances = attendanceService.getTodayAttendances();
        if (attendances.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/")
    public ResponseEntity<List<Attendance>> getAllAttendances() {
        List<Attendance> attendances = attendanceService.getAllAttendances();
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/allUsers")
    public ResponseEntity<List<User>> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/find/{id}")
    public ResponseEntity<Attendance> findAttendanceById(@PathVariable("id") long id) {
        Attendance attendance = attendanceService.findAttendanceById(id);
        if (attendance == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build(); // Return 404 if not found
        }
        return ResponseEntity.ok(attendance);
    }

    @GetMapping("/user/{id}/attendances")
    public ResponseEntity<List<Attendance>> getAttendancesByUserId(@PathVariable Long id) {
        List<Attendance> attendances = attendanceService.getAttendanceByUserId(id);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/attendanceRange")
    public ResponseEntity<Map<User, Long>> getUsersWithAttendanceInRange(
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            Map<User, Long> userAttendance = attendanceService.getUsersAttendanceInRange(startDate, endDate);

            if (userAttendance == null || userAttendance.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build(); // 204 No Content
            }

            return ResponseEntity.ok(userAttendance); // Return the attendance map
        } catch (Exception e) {
            return ResponseEntity.ok(Collections.emptyMap()); // Return an empty map on error
        }
    }

    // find Users Without Attendance Today
    @GetMapping("/usersWithoutAttendanceToday")
    public ResponseEntity<List<User>> getUsersWithoutAttendanceToday() {
        List<User> usersWithoutAttendanceToday = attendanceService.findUsersWithoutAttendanceToday();
        return ResponseEntity.ok(usersWithoutAttendanceToday);
    }

    @GetMapping("/peakAttendanceDay")
    public ResponseEntity<List<Object[]>> getPeakAttendanceDay() {
        List<Object[]> peakAttendanceDay = attendanceService.getPeakAttendanceDay();
        if (peakAttendanceDay.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(peakAttendanceDay);
    }

    @GetMapping("/peakAttendanceMonth")
    public ResponseEntity<List<Object[]>> getPeakAttendanceMonth() {
        List<Object[]> peakAttendanceMonth = attendanceService.getPeakAttendanceMonth();
        if (peakAttendanceMonth.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(peakAttendanceMonth);
    }


    @GetMapping("/lateCheckIns")
    public ResponseEntity<List<Attendance>> getLateCheckIns(
            @RequestParam("lateTime") String lateTime,
            @RequestParam("startDate") LocalDate startDate,
            @RequestParam("endDate") LocalDate endDate) {
        List<Attendance> lateCheckIns = attendanceService.getLateCheckIns(lateTime, startDate, endDate);
        if (lateCheckIns.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(lateCheckIns);
    }


    @GetMapping("/searchByName")
    public ResponseEntity<List<Attendance>> getAttendancesByUserNamePart(@RequestParam("name") String name) {
        List<Attendance> attendances = attendanceService.getAttendancesByUserNamePart(name);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/roleAttendance")
    public ResponseEntity<List<Attendance>> getAttendanceByRoleAndDateRange(
            @RequestParam("role") String role) {
        List<Attendance> attendances = attendanceService.getAttendanceByRole(role);
        if (attendances.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(attendances);
    }

    @GetMapping("/todayAttendance/{userId}")
    public ResponseEntity<List<Attendance>> getTodayAttendanceByUserId(@PathVariable("userId") long userId) {
        List<Attendance> todayAttendance = attendanceService.getTodayAttendanceByUserId(userId);
        if (todayAttendance.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
        return ResponseEntity.ok(todayAttendance);
    }


}
