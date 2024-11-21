import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService attendanceService = AttendanceService();
  Attendance? todayAttendance;
  bool isLoading = false;
  int selectedUserId = 1;

  @override
  void initState() {
    super.initState();
    fetchTodayAttendance();
  }

  // Handle check-in action
  Future<void> checkIn() async {
    try {
      Attendance attendance = await attendanceService.checkIn(selectedUserId);
      setState(() => todayAttendance = attendance);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Checked in successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to check in. Error: $e")),
      );
    }
  }

  // Handle check-out action
  Future<void> checkOut() async {
    try {
      Attendance attendance = await attendanceService.checkOut(selectedUserId);
      setState(() => todayAttendance = attendance);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Checked out successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to check out. Error: $e")),
      );
    }
  }


  // Fetch today's attendance records
  Future<void> fetchTodayAttendance() async {
    setState(() => isLoading = true);
    try {
      List<Attendance> attendanceRecords = await attendanceService.getTodayAttendanceByUserId(selectedUserId);
      setState(() {
        todayAttendance = attendanceRecords.isNotEmpty ? attendanceRecords.first : null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load attendance records. Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Tracker",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Check In Button
            ElevatedButton(
              onPressed: canCheckIn() ? checkIn : null,
              child: Text("Check In", style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              )),
            ),
            SizedBox(height: 10),
            // Check Out Button
            ElevatedButton(
              onPressed: canCheckOut() ? checkOut : null,
              child: Text("Check Out", style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              )),
            ),
            SizedBox(height: 20),
            // Loading indicator or attendance details
            isLoading
                ? Center(child: CircularProgressIndicator())
                : todayAttendance != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance Details",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("Check-in Time: ${todayAttendance!.clockInTime ?? 'Not Checked In'}"),
                Text("Check-out Time: ${todayAttendance!.clockOutTime ?? 'Not Checked Out'}"),
                Text("Overtime Hours: ${calculateOvertime(todayAttendance!)}"),
              ],
            )
                : Center(child: Text("No attendance record for today",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.cyan,
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Calculate overtime based on attendance times
  String calculateOvertime(Attendance attendance) {
    final checkIn = attendance.clockInTime;
    final checkOut = attendance.clockOutTime;
    final duration = checkOut.difference(checkIn);
    final overtimeHours = duration.inHours - 8; // Assuming an 8-hour workday
    return overtimeHours > 0 ? "$overtimeHours hours" : "No overtime";
      return "N/A";
  }

  // Check if the user can check in
  bool canCheckIn() {
    return todayAttendance?.clockInTime == null;
  }

  // Check if the user can check out
  bool canCheckOut() {
    return todayAttendance?.clockInTime != null && todayAttendance?.clockOutTime == null;
  }
}
