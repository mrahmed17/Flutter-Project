import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/administration/model/User.dart'; // Assume User model exists

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({Key? key}) : super(key: key);

  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  late AttendanceService _attendanceService;
  late AuthService _authService;
  List<User> _employees = [];
  User? _selectedEmployee;

  String _monthlyAttendanceCount = 'Loading...';
  String _todayAttendanceCount = 'Loading...';
  List<Attendance> _attendances = [];
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService();
    _authService = AuthService(); // Assume this service fetches employees
    _fetchEmployees();
  }

  /// Fetch all employees for selection
  Future<void> _fetchEmployees() async {
    setState(() => _isLoading = true);
    try {
      final employees = await _authService.getAllUsers();
      setState(() {
        _employees = employees;
        _selectedEmployee = employees.isNotEmpty ? employees.first : null;
      });
      if (_selectedEmployee != null) {
        _fetchAttendanceData(_selectedEmployee!.id!);
      }
    } catch (e) {
      _showNotification('Failed to load employees: $e', isSuccess: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Load attendance data for the selected employee
  Future<void> _fetchAttendanceData(int userId) async {
    await Future.wait([
      _fetchMonthlyAttendanceCount(userId),
      _fetchTodayAttendance(userId),
      _fetchAttendancesWithFilters(userId),
    ]);
  }

  /// Show notifications for success/failure
  void _showNotification(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green[300] : Colors.red[300],
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Fetch monthly attendance count for a user
  Future<void> _fetchMonthlyAttendanceCount(int userId) async {
    try {
      final count = await _attendanceService.getMonthlyAttendanceCount(userId);
      setState(() {
        _monthlyAttendanceCount = count.toString();
      });
    } catch (e) {
      _showNotification('Error fetching monthly attendance: $e', isSuccess: false);
    }
  }

  /// Fetch today's attendance count for a user
  Future<void> _fetchTodayAttendance(int userId) async {
    try {
      final attendances = await _attendanceService.getTodayTotalAttendance();
      final userAttendance =
      attendances.where((attendance) => attendance.user?.id == userId).toList();

      setState(() {
        _todayAttendanceCount = userAttendance.length.toString();
        _attendances = userAttendance;
      });
    } catch (e) {
      _showNotification('Error fetching today\'s attendance: $e', isSuccess: false);
    }
  }

  /// Fetch attendance records for a user with filters
  Future<void> _fetchAttendancesWithFilters(int userId) async {
    setState(() => _isLoading = true);
    try {
      List<Attendance> attendances =
      await _attendanceService.getAttendancesByUserId(userId);

      if (_startDate != null && _endDate != null) {
        attendances = attendances.where((attendance) {
          return attendance.date != null &&
              attendance.date!.isAfter(_startDate!) &&
              attendance.date!.isBefore(_endDate!);
        }).toList();
      }
      setState(() {
        _attendances = attendances;
      });
    } catch (e) {
      _showNotification('Error fetching filtered attendances: $e', isSuccess: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Display a date range picker for filtering attendance
  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked.start != picked.end) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      if (_selectedEmployee != null) {
        _fetchAttendancesWithFilters(_selectedEmployee!.id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<User>(
              isExpanded: true,
              value: _selectedEmployee,
              items: _employees.map((employee) {
                return DropdownMenuItem<User>(
                  value: employee,
                  child: Text(employee.name ?? 'Unknown'),
                );
              }).toList(),
              onChanged: (User? newEmployee) {
                if (newEmployee != null) {
                  setState(() {
                    _selectedEmployee = newEmployee;
                  });
                  _fetchAttendanceData(newEmployee.id!);
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Monthly Attendance Count: $_monthlyAttendanceCount',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Today\'s Attendance Count: $_todayAttendanceCount',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_attendances.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _attendances.length,
                  itemBuilder: (context, index) {
                    final attendance = _attendances[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text('Date: ${attendance.date?.toLocal()}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Clock In: ${attendance.clockInTime?.toLocal()}'),
                            if (attendance.clockOutTime != null)
                              Text('Clock Out: ${attendance.clockOutTime?.toLocal()}'),
                            Text('Overtime Hours: ${attendance.overtimeHours ?? 0}'),
                            if (attendance.lateCheckIn == true) Text('Late Check-In'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_attendances.isEmpty)
              const Text(
                'No attendance records found.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }
}
