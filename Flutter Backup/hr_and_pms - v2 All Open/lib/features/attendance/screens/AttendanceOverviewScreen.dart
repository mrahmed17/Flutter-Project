import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/administration/model/User.dart';

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
  Map<String, int>? attendanceCounts; // Adjusted type for clarity
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
        DateTime.now().subtract(Duration(days: 30)),
        DateTime.now(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load overview data: $e",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchRecentAttendances() async {
    recentAttendances = await attendanceService.getAllAttendances();
  }

  Future<void> fetchUsersWithoutAttendanceToday() async {
    usersWithoutAttendanceToday =
    await attendanceService.getUsersWithoutAttendanceToday();
  }

  Future<void> fetchAttendanceCountsInRange(
      DateTime startDate, DateTime endDate) async {
    Map<String, int> response =
    await attendanceService.getAttendanceCountsInRange(startDate, endDate);
    setState(() {
      attendanceCounts = response;
    });
  }

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
        child: ListView(
          children: [
            _buildSectionTitle("Recent Attendances"),
            _buildRecentAttendancesList(),
            SizedBox(height: 20),
            _buildSectionTitle("Users Without Attendance Today"),
            _buildUsersWithoutAttendanceList(),
            SizedBox(height: 20),
            _buildSectionTitle("Attendance Counts in Last 30 Days"),
            _buildAttendanceCounts(),
          ],
        ),
      ),
    );
  }

  // Builds the title for each section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.teal,
          fontSize: 18,
        ),
      ),
    );
  }

  // Displays the list of recent attendances
  Widget _buildRecentAttendancesList() {
    if (recentAttendances.isEmpty) {
      return Text(
        "No recent attendances found.",
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentAttendances.length,
      itemBuilder: (context, index) {
        final attendance = recentAttendances[index];
        return ListTile(
          title: Text(
            "User: ${attendance.user?.name ?? 'N/A'}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          subtitle: Text(
            "Check-in: ${attendance.clockInTime ?? 'N/A'}, "
                "Check-out: ${attendance.clockOutTime ?? 'N/A'}",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        );
      },
    );
  }

  // Displays the list of users without attendance today
  Widget _buildUsersWithoutAttendanceList() {
    if (usersWithoutAttendanceToday.isEmpty) {
      return Text(
        "All users have checked in today.",
        style: TextStyle(fontSize: 16, color: Colors.green),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: usersWithoutAttendanceToday.length,
      itemBuilder: (context, index) {
        final user = usersWithoutAttendanceToday[index];
        return ListTile(
          title: Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        );
      },
    );
  }

  // Displays the attendance counts
  Widget _buildAttendanceCounts() {
    if (attendanceCounts == null) {
      return Text(
        "No data available for the specified range.",
        style: TextStyle(fontSize: 16, color: Colors.red),
      );
    }
    return Text(
      "Total: ${attendanceCounts!['total'] ?? 0} | "
          "Present: ${attendanceCounts!['present'] ?? 0} | "
          "Absent: ${attendanceCounts!['absent'] ?? 0}",
      style: TextStyle(fontSize: 16, color: Colors.teal),
    );
  }
}
