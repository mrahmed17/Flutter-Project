import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/attendance/service/AttendanceService.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/administration/model/User.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService(); // Service initialized here
  final _formKey = GlobalKey<FormState>();
  DateTime? _clockInTime;
  DateTime? _clockOutTime;
  bool? _lateCheckIn;
  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// Fetch the authenticated user details
  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _currentUser = await AuthService().getUser();
    } catch (e) {
      _showNotification('Failed to load user: $e', isSuccess: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show notification using SnackBar
  void _showNotification(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green[300] : Colors.red[300],
      ),
    );
  }

  /// Handle check-in action
  Future<void> _checkIn() async {
    if (_currentUser == null) return;
    setState(() {
      _isLoading = true;
    });

    try {
      Attendance? attendance = await _attendanceService.checkIn(_currentUser!.id!);
      setState(() {
        _clockInTime = attendance?.clockInTime;
        _lateCheckIn = attendance?.lateCheckIn;
      });
      _showNotification('Check-in successful at $_clockInTime');
    } catch (e) {
      _showNotification('Failed to check in: $e', isSuccess: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handle check-out action
  Future<void> _checkOut() async {
    if (_currentUser == null) return;
    setState(() {
      _isLoading = true;
    });

    try {
      Attendance? attendance = await _attendanceService.checkOut(_currentUser!.id!);
      setState(() {
        _clockOutTime = attendance?.clockOutTime;
      });
      _showNotification('Check-out successful at $_clockOutTime');
    } catch (e) {
      _showNotification('Failed to check out: $e', isSuccess: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance System',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, ${_currentUser?.name ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Clock-In Time'),
                subtitle: Text(
                  _clockInTime != null ? _clockInTime!.toString() : 'Not checked in yet',
                ),
              ),
              ListTile(
                title: const Text('Clock-Out Time'),
                subtitle: Text(
                  _clockOutTime != null ? _clockOutTime!.toString() : 'Not checked out yet',
                ),
              ),
              ListTile(
                title: const Text('Late Check-In'),
                subtitle: Text(
                  _lateCheckIn != null ? (_lateCheckIn! ? 'Yes' : 'No') : 'Not checked in yet',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkIn,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.green[100],
                ),
                child: const Text('Check In'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkOut,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.red[100],
                ),
                child: const Text('Check Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
