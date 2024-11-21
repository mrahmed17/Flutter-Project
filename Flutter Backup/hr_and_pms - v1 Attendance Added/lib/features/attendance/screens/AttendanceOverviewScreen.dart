import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/user/model/User.dart';
import 'package:hr_and_pms/wrapper_model/PaginatedAttendance.dart';

class AttendanceOverviewScreen extends StatefulWidget {
  const AttendanceOverviewScreen({super.key});

  @override
  _AttendanceOverviewScreenState createState() =>
      _AttendanceOverviewScreenState();
}

class _AttendanceOverviewScreenState extends State<AttendanceOverviewScreen> {
  final AttendanceService attendanceService = AttendanceService();
  List<Attendance> recentAttendances = [];
  List<User> usersWithoutAttendanceToday = [];
  Map<String, dynamic>? attendanceCountsInRange;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchOverviewData();
  }

  Future<void> fetchOverviewData() async {
    setState(() => isLoading = true);
    try {
      await fetchRecentAttendances();
      await fetchUsersWithoutAttendanceToday();
      await fetchAttendanceCountsInRange(
          DateTime.now().subtract(Duration(days: 30)), DateTime.now());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Failed to load overview data",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        )),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchRecentAttendances() async {
    PaginatedAttendance paginatedAttendance =
        await attendanceService.getAllAttendances(page: 0, size: 5);
    recentAttendances = paginatedAttendance.attendances;
  }

  Future<void> fetchUsersWithoutAttendanceToday() async {
    usersWithoutAttendanceToday =
        await attendanceService.getUsersWithoutAttendanceToday();
  }

  Future<void> fetchAttendanceCountsInRange(
      DateTime startDate, DateTime endDate) async {
    attendanceCountsInRange = await attendanceService
        .getUsersWithAttendanceInRange(startDate, endDate);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Overview",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Recent Attendances",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal)),
                  ),
                  SizedBox(height: 10),
                  recentAttendances.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: recentAttendances.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  "User: ${recentAttendances[index].user.name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                                subtitle: Text(
                                  "Check-in: ${recentAttendances[index].clockInTime ?? 'N/A'}, "
                                  "Check-out: ${recentAttendances[index].clockOutTime ?? 'N/A'}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                          "No recent attendances",
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        )),
                  SizedBox(height: 20),
                  Center(
                    child: Text("Users Without Attendance Today",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal)),
                  ),
                  SizedBox(height: 10),
                  usersWithoutAttendanceToday.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: usersWithoutAttendanceToday.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    "User: ${usersWithoutAttendanceToday[index].name}"),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                          "All users have checked in today",
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        )),
                  SizedBox(height: 20),
                  Center(
                    child: Text("Attendance Counts in Last 30 Days",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.teal)),
                  ),
                  SizedBox(height: 10),
                  attendanceCountsInRange != null
                      ? Text(
                          "Total: ${attendanceCountsInRange!['total']} | Present: ${attendanceCountsInRange!['present']} "
                          "| Absent: ${attendanceCountsInRange!['absent']}")
                      : Center(
                        child: Text(
                            "No data available for the specified range",
                            style: TextStyle(fontSize: 10, color: Colors.red),
                          ),
                      ),
                ],
              ),
            ),
    );
  }
}
