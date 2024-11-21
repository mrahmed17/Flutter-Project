import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';

class AttendanceLookupScreen extends StatefulWidget {
  const AttendanceLookupScreen({super.key});

  @override
  _AttendanceLookupScreenState createState() => _AttendanceLookupScreenState();
}

class _AttendanceLookupScreenState extends State<AttendanceLookupScreen> {
  final AttendanceService attendanceService = AttendanceService();
  List<Attendance> attendanceResults = [];
  bool isLoadingSearch = false;
  bool isLoadingFilter = false;
  bool isLoadingTodayAttendance = false;
  String searchQuery = "";
  String selectedRole = "EMPLOYEE";
  int? userIdForTodayAttendance;
  Timer? _debounce;

  final List<String> roles = ["EMPLOYEE", "MANAGER"];

  // Debounce for Search Input
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
        searchAttendanceByUserName();
      });
    });
  }

  // Search attendance by user name
  void searchAttendanceByUserName() async {
    setState(() => isLoadingSearch = true);
    try {
      var results = await attendanceService.getAttendancesByUserNamePart(searchQuery);
      setState(() => attendanceResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load attendance records. Please try again later.")),
      );
    } finally {
      setState(() => isLoadingSearch = false);
    }
  }

  // Filter attendance by role
  void filterAttendanceByRole() async {
    setState(() => isLoadingFilter = true);
    try {
      var results = await attendanceService.getAttendanceByRole(selectedRole);
      setState(() => attendanceResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load attendance by role. Please try again later.")),
      );
    } finally {
      setState(() => isLoadingFilter = false);
    }
  }

  // Get today's attendance by user ID
  void getTodayAttendanceByUserId() async {
    if (userIdForTodayAttendance == null) return;

    setState(() => isLoadingTodayAttendance = true);
    try {
      var results = await attendanceService.getTodayAttendanceByUserId(userIdForTodayAttendance!);
      setState(() => attendanceResults = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load today's attendance. Please try again later.")),
      );
    } finally {
      setState(() => isLoadingTodayAttendance = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Lookup"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search by user name
            TextField(
              decoration: InputDecoration(
                labelText: "Search by User Name",
                suffixIcon: isLoadingSearch
                    ? CircularProgressIndicator()
                    : IconButton(icon: Icon(Icons.search), onPressed: searchAttendanceByUserName),
              ),
              onChanged: onSearchChanged,
            ),
            SizedBox(height: 20),

            // Filter by Role
            DropdownButton<String>(
              value: selectedRole,
              items: roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (role) {
                setState(() => selectedRole = role!);
                filterAttendanceByRole();
              },
            ),
            SizedBox(height: 20),

            // Today's Attendance
            TextField(
              decoration: InputDecoration(
                labelText: "User ID for Today's Attendance",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: getTodayAttendanceByUserId,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => userIdForTodayAttendance = int.tryParse(value),
            ),
            SizedBox(height: 20),

            // Attendance Results
            Expanded(
              child: isLoadingFilter || isLoadingTodayAttendance
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: attendanceResults.length,
                itemBuilder: (context, index) {
                  final attendance = attendanceResults[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(attendance.user?.name?.substring(0, 1) ?? "?")),
                    title: Text("User: ${attendance.user?.name ?? 'N/A'}"),
                    subtitle: Text("Check-in Time: ${attendance.clockInTime ?? 'N/A'}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
