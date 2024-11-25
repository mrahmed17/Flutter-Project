import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:intl/intl.dart'; // For date formatting

class AttendanceAnalyticsScreen extends StatefulWidget {
  const AttendanceAnalyticsScreen({super.key});

  @override
  _AttendanceAnalyticsScreenState createState() =>
      _AttendanceAnalyticsScreenState();
}

class _AttendanceAnalyticsScreenState extends State<AttendanceAnalyticsScreen> {
  final AttendanceService attendanceService = AttendanceService();
  List<Attendance> lateCheckIns = [];
  bool isLoading = false;
  DateTimeRange? selectedDateRange;
  String? peakAttendanceDay;
  String? peakAttendanceMonth;

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    setState(() => isLoading = true);
    try {
      await fetchPeakAttendanceDay();
      await fetchPeakAttendanceMonth();
      if (selectedDateRange != null) {
        await fetchLateCheckIns(selectedDateRange!);
      }
    } catch (e) {
      showSnackBar("Failed to load analytics data. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPeakAttendanceDay() async {
    try {
      final day = await attendanceService.getPeakAttendanceDay();
      setState(() => peakAttendanceDay = day);
    } catch (e) {
      setState(() => peakAttendanceDay = "No data available");
    }
  }

  Future<void> fetchPeakAttendanceMonth() async {
    try {
      final month = await attendanceService.getPeakAttendanceMonth();
      setState(() => peakAttendanceMonth = month);
    } catch (e) {
      setState(() => peakAttendanceMonth = "No data available");
    }
  }



  Future<void> fetchLateCheckIns(DateTimeRange range) async {
    try {
      final checkIns = await attendanceService.getLateCheckIns(
        "09:00", // Late check-in threshold
        range.start,
        range.end,
      );
      setState(() => lateCheckIns = checkIns);
    } catch (e) {
      setState(() => lateCheckIns = []);
    }
  }

  void selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (range != null) {
      setState(() {
        selectedDateRange = range;
        lateCheckIns.clear();
      });
      await fetchLateCheckIns(range);
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Analytics"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Peak Attendance Day",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              peakAttendanceDay != null && peakAttendanceDay!.isNotEmpty
                  ? Text("Peak Day: $peakAttendanceDay")
                  : const Text(
                "No data available for peak day",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text(
                "Peak Attendance Month",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              peakAttendanceMonth != null && peakAttendanceMonth!.isNotEmpty
                  ? Text("Peak Month: $peakAttendanceMonth")
                  : const Text(
                "No data available for peak month",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text(
                "Late Check-ins",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: selectDateRange,
                child: const Text("Select Date Range"),
              ),
              const SizedBox(height: 10),
              selectedDateRange != null
                  ? Text(
                "Selected Range: ${DateFormat('MMM dd, yyyy').format(selectedDateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(selectedDateRange!.end)}",
              )
                  : const Text(
                "No date range selected",
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 10),
              lateCheckIns.isNotEmpty
                  ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lateCheckIns.length,
                itemBuilder: (context, index) {
                  final attendance = lateCheckIns[index];
                  return ListTile(
                    title: Text("User ID: ${attendance.user}"),
                    subtitle: Text(
                      "Check-in Time: ${attendance.clockInTime != null ? DateFormat('hh:mm a').format(attendance.clockInTime!) : 'N/A'}",
                    ),
                  );
                },
              )
                  : const Text(
                "No late check-ins for the selected range",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
