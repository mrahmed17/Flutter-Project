import 'dart:convert';
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/user/model/User.dart';
import 'package:hr_and_pms/wrapper_model/PaginatedAttendance.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String baseUrl = 'localhost:8080';
  final String apiPath = '/api/attendance';

  // Method for checking in
  Future<Attendance> checkIn(int userId) async {
    final response = await http.post(
      Uri.http(baseUrl, '$apiPath/checkin'),
      body: json.encode({'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check in: ${response.body}');
    }
  }

  // Method for checking out
  Future<Attendance> checkOut(int userId) async {
    final response = await http.put(
      Uri.http(baseUrl, '$apiPath/checkout'),
      body: json.encode({'userId': userId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check out: ${response.body}');
    }
  }

  // Method to get overtime for a user within a date range with pagination
  Future<PaginatedAttendance> getOvertimeByUser(int userId, DateTime startDate, DateTime endDate, {int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/overtime/$userId', {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'page': '$page',
        'size': '$size',
      }),
    );

    if (response.statusCode == 200) {
      return PaginatedAttendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load overtime records: ${response.body}');
    }
  }

  // Method to get today's attendance records
  Future<List<Attendance>> getTodayAttendance() async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/today'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load today’s attendance: ${response.body}');
    }
  }


  // Method to retrieve all attendances with pagination
  Future<PaginatedAttendance> getAllAttendances({int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/', {'page': '$page', 'size': '$size'}),
    );

    if (response.statusCode == 200) {
      return PaginatedAttendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load all attendances: ${response.body}');
    }
  }


  // Method to find attendance by ID
  Future<Attendance> findAttendanceById(int id) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/find/$id'),
    );

    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Attendance not found: ${response.body}');
    }
  }

  // Method to get attendance records for a specific user
  Future<List<Attendance>> getAttendancesByUserId(int userId, {int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/user/$userId/attendances', {'page': '$page', 'size': '$size'}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user attendance records: ${response.body}');
    }
  }

  // Method to get attendance counts in a range
  Future<Map<String, dynamic>> getUsersWithAttendanceInRange(DateTime startDate, DateTime endDate) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/attendanceRange', {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load attendance count in range: ${response.body}');
    }
  }

  // Method to get users without attendance today
  Future<List<User>> getUsersWithoutAttendanceToday() async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/usersWithoutAttendanceToday'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users without attendance today: ${response.body}');
    }
  }

  // Method to get peak attendance day
  Future<List<Object>> getPeakAttendanceDay() async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/peakAttendanceDay'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load peak attendance day: ${response.body}');
    }
  }

  // Method to get peak attendance month
  Future<List<Object>> getPeakAttendanceMonth() async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/peakAttendanceMonth'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load peak attendance month: ${response.body}');
    }
  }

  // Method to get late check-ins
  Future<List<Attendance>> getLateCheckIns(String lateTime, DateTime startDate, DateTime endDate) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/lateCheckIns', {
        'lateTime': lateTime,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load late check-ins: ${response.body}');
    }
  }

  // Method to search attendance by username
  Future<List<Attendance>> getAttendancesByUserNamePart(String name, {int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/searchByName', {'name': name, 'page': '$page', 'size': '$size'}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendances by user name: ${response.body}');
    }
  }

  // Method to get attendance by role
  Future<List<Attendance>> getAttendanceByRole(String role, {int page = 0, int size = 10}) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/roleAttendance', {'role': role, 'page': '$page', 'size': '$size'}),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendances by role: ${response.body}');
    }
  }

  // Method to get today's attendance by user ID
  Future<List<Attendance>> getTodayAttendanceByUserId(int userId) async {
    final response = await http.get(
      Uri.http(baseUrl, '$apiPath/todayAttendance/$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load today’s attendance by user ID: ${response.body}');
    }
  }
}
