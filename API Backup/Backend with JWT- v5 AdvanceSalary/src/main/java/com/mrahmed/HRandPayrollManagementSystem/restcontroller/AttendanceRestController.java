package com.mrahmed.HRandPayrollManagementSystem.restcontroller;

import com.mrahmed.HRandPayrollManagementSystem.entity.Attendance;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.service.AttendanceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/attendance")
@CrossOrigin("*")
public class AttendanceRestController {

    @Autowired
    private AttendanceService attendanceService;

//    @PostMapping("/checkin")
//    public ResponseEntity<?> checkIn(@RequestBody Map<String, Object> request) {
//        try {
//            long userId = Long.parseLong(request.get("userId").toString());
//            String biometricData = request.get("biometricData").toString();
//            AttendanceMethod method = AttendanceMethod.valueOf(request.get("method").toString());
//
//            Attendance attendance = attendanceService.checkIn(userId, biometricData, method);
//            return ResponseEntity.status(HttpStatus.CREATED).body(attendance);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
//                    .body("Error during check-in: " + e.getMessage());
//        }
//    }

    @PostMapping("/checkin")
    public ResponseEntity<?> checkIn(@RequestBody Map<String, Object> request) {
        try {
            long userId = Long.parseLong(request.get("userId").toString());
            Attendance attendance = attendanceService.checkIn(userId);
            return ResponseEntity.status(HttpStatus.CREATED).body(attendance);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error occurred while checking in: " + e.getMessage());
        }
    }

//    @PutMapping("/checkout")
//    public ResponseEntity<?> checkOut(@RequestBody Map<String, Object> request) {
//        try {
//            long userId = Long.parseLong(request.get("userId").toString());
//            Attendance attendance = attendanceService.checkOut(userId);
//            return ResponseEntity.ok(attendance);
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
//                    .body("Error during check-out: " + e.getMessage());
//        }
//    }

    @PutMapping("/checkout")
    public ResponseEntity<?> checkOut(@RequestBody Map<String, Object> request) {
        try {
            long userId = Long.parseLong(request.get("userId").toString());
            Attendance attendance = attendanceService.checkOut(userId);
            return ResponseEntity.ok(attendance);
        } catch (NumberFormatException e) {
            return ResponseEntity.badRequest().body("Invalid user ID format");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error occurred while checking out: " + e.getMessage());
        }
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
    public ResponseEntity<List<Attendance>> getAllAttendances() {
        try {
            List<Attendance> attendances = attendanceService.getAllAttendances();
            return attendances.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(attendances);
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

    @GetMapping("/usersWithoutAttendanceToday")
    public ResponseEntity<List<User>> getUsersWithoutAttendanceToday() {
        try {
            List<User> usersWithoutAttendanceToday = attendanceService.findUsersWithoutAttendanceToday();
            return ResponseEntity.ok(usersWithoutAttendanceToday);
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

    @GetMapping("/lateCheckIns")
    public ResponseEntity<List<Attendance>> getLateCheckIns(
            @RequestParam("lateTime") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime lateTime,
            @RequestParam("startDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam("endDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<Attendance> lateCheckIns = attendanceService.getLateCheckIns(startDate, endDate, lateTime);
            return lateCheckIns.isEmpty()
                    ? ResponseEntity.noContent().build()
                    : ResponseEntity.ok(lateCheckIns);
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
