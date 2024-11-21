import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';

class AttendanceAnalyticsScreen extends StatefulWidget {
  const AttendanceAnalyticsScreen({super.key});

  @override
  _AttendanceAnalyticsScreenState createState() =>
      _AttendanceAnalyticsScreenState();
}

class _AttendanceAnalyticsScreenState extends State<AttendanceAnalyticsScreen> {
  final AttendanceService attendanceService = AttendanceService();
  List<Object> peakAttendanceDay = [];
  List<Object> peakAttendanceMonth = [];
  List<Attendance> lateCheckIns = [];
  bool isLoading = false;
  DateTimeRange? selectedDateRange;

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load analytics data")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchPeakAttendanceDay() async {
    peakAttendanceDay = await attendanceService.getPeakAttendanceDay();
  }

  Future<void> fetchPeakAttendanceMonth() async {
    peakAttendanceMonth = await attendanceService.getPeakAttendanceMonth();
  }

  Future<void> fetchLateCheckIns(DateTimeRange range) async {
    lateCheckIns = await attendanceService.getLateCheckIns(
      "09:00", // Assuming 9 AM is the late check-in threshold
      range.start,
      range.end,
    );
  }

  void selectDateRange() async {
    DateTimeRange? range = await showDateRangePicker(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Analytics",
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Peak Attendance Day",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        )),
                    SizedBox(height: 10),
                    peakAttendanceDay.isNotEmpty
                        ? Text("Peak Day: ${peakAttendanceDay.join(", ")}")
                        : Text("No data available for peak day",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                    SizedBox(height: 20),
                    Text("Peak Attendance Month",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        )),
                    SizedBox(height: 10),
                    peakAttendanceMonth.isNotEmpty
                        ? Text("Peak Month: ${peakAttendanceMonth.join(", ")}")
                        : Text("No data available for peak month",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                    SizedBox(height: 20),
                    Text("Late Check-ins",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal,
                        )),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectDateRange,
                      child: Text(
                        "Select Date Range",
                        style: TextStyle(fontSize: 16, color: Colors.indigo),
                      ),
                    ),
                    selectedDateRange != null
                        ? Text(
                            "Selected Range: ${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}")
                        : Text("No date range selected",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                    SizedBox(height: 10),
                    lateCheckIns.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: lateCheckIns.length,
                              itemBuilder: (context, index) {
                                final attendance = lateCheckIns[index];
                                return ListTile(
                                  title: Text("User ID: ${attendance.user}"),
                                  subtitle: Text(
                                      "Check-in Time: ${attendance.clockInTime ?? 'N/A'}"),
                                );
                              },
                            ),
                          )
                        : Text("No late check-ins for the selected range",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
