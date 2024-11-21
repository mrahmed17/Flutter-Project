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
  bool isLoading = false;
  String searchQuery = "";
  String selectedRole = "EMPLOYEE";
  int? userIdForTodayAttendance;

  final List<String> roles = ["EMPLOYEE", "MANAGER"];

  void searchAttendanceByUserName() async {
    setState(() => isLoading = true);
    try {
      attendanceResults = await attendanceService.getAttendancesByUserNamePart(searchQuery);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load attendance records",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),),),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterAttendanceByRole() async {
    setState(() => isLoading = true);
    try {
      attendanceResults = await attendanceService.getAttendanceByRole(selectedRole);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load attendance by role",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void getTodayAttendanceByUserId() async {
    if (userIdForTodayAttendance == null) return;

    setState(() => isLoading = true);
    try {
      attendanceResults = await attendanceService.getTodayAttendanceByUserId(userIdForTodayAttendance!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load today's attendance for user",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),),),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Lookup",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search by User Name",
            labelStyle: TextStyle(color: Colors.teal),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.teal,),
                  onPressed: searchAttendanceByUserName,
                ),
              ),
              onChanged: (value) => searchQuery = value,
            ),
            SizedBox(height: 20),
            Text("Filter by Role", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
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
            TextField(
              decoration: InputDecoration(
                labelText: "User ID for Today's Attendance",
                  labelStyle: TextStyle(color: Colors.teal),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.teal,),
                  onPressed: getTodayAttendanceByUserId,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => userIdForTodayAttendance = int.tryParse(value),
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: attendanceResults.isNotEmpty
                  ? ListView.builder(
                itemCount: attendanceResults.length,
                itemBuilder: (context, index) {
                  final attendance = attendanceResults[index];
                  return ListTile(
                    title: Text("User ID: ${attendance.user}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                    subtitle: Text("Check-in Time: ${attendance.clockInTime ?? 'N/A'}",style: TextStyle(color: Colors.teal),),
                  );
                },
              )
                  : Center(child: Text("No records found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),)),
            ),
          ],
        ),
      ),
    );
  }
}
