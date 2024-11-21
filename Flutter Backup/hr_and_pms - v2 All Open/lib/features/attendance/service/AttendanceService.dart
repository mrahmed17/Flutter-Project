import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/administration/model/User.dart';

const String baseUrl = 'localhost:8080';
const String apiPath = '/api/attendance';
// const String baseUrl = 'http://10.0.2.2:8080';


class AttendanceService {
  // Handle HTTP requests
  Future<http.Response> _makeRequest(
      String method,
      String path, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final uri = Uri.http(baseUrl, path);
    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http.post(
            uri,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: json.encode(body),
          ).timeout(const Duration(seconds: 10)); // Timeout for safety
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers ?? {'Content-Type': 'application/json'},
            body: json.encode(body),
          ).timeout(const Duration(seconds: 10));
          break;
        case 'GET':
          response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      return response;
    } catch (e) {
      throw Exception('Error during $method request to $path: $e');
    }
  }

  // Check-in method
  Future<Attendance> checkIn(int userId) async {
    final response = await _makeRequest(
      'POST',
      '$apiPath/checkin',
      body: {'userId': userId},
    );

    if (response.statusCode == 201) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check in: ${response.body}');
    }
  }

  // Check-out method
  Future<Attendance> checkOut(int userId) async {
    final response = await _makeRequest(
      'PUT',
      '$apiPath/checkout',
      body: {'userId': userId},
    );

    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to check out: ${response.body}');
    }
  }

  // Get overtime records by user ID and date range
  Future<List<Attendance>> getOvertimeByUser(int userId, DateTime startDate, DateTime endDate) async {
    final response = await _makeRequest(
      'GET',
      '$apiPath/overtime/$userId?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load overtime records: ${response.body}');
    }
  }

  // Get today's attendance records
  Future<List<Attendance>> getTodayAttendance() async {
    final response = await _makeRequest('GET', '$apiPath/today');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load today’s attendance: ${response.body}');
    }
  }

  // Retrieve all attendances
  Future<List<Attendance>> getAllAttendances() async {
    final response = await _makeRequest('GET', '$apiPath/');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all attendances: ${response.body}');
    }
  }

  // Find attendance by ID
  Future<Attendance> findAttendanceById(int id) async {
    final response = await _makeRequest('GET', '$apiPath/find/$id');

    if (response.statusCode == 200) {
      return Attendance.fromJson(json.decode(response.body));
    } else {
      throw Exception('Attendance not found: ${response.body}');
    }
  }

  // Get attendance records by user ID
  Future<List<Attendance>> getAttendancesByUserId(int userId) async {
    final response = await _makeRequest('GET', '$apiPath/user/$userId/attendances');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user attendance records: ${response.body}');
    }
  }

  // Get users without attendance today
  Future<List<User>> getUsersWithoutAttendanceToday() async {
    final response = await _makeRequest('GET', '$apiPath/usersWithoutAttendanceToday');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users without attendance today: ${response.body}');
    }
  }

  Future<String> getPeakAttendanceDay() async {
    final response = await _makeRequest('GET', '$apiPath/peakAttendanceDay');

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.isNotEmpty ? responseBody.first.toString() : "No data";
    } else {
      throw Exception('Failed to load peak attendance day: ${response.body}');
    }
  }

  Future<String> getPeakAttendanceMonth() async {
    final response = await _makeRequest('GET', '$apiPath/peakAttendanceMonth');

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.isNotEmpty ? responseBody.first.toString() : "No data";
    } else {
      throw Exception('Failed to load peak attendance month: ${response.body}');
    }
  }

  // Get late check-ins
  Future<List<Attendance>> getLateCheckIns(String lateTime, DateTime startDate, DateTime endDate) async {
    final response = await _makeRequest(
      'GET',
      '$apiPath/lateCheckIns?lateTime=$lateTime&startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load late check-ins: ${response.body}');
    }
  }

  // Search attendance by user name
  Future<List<Attendance>> getAttendancesByUserNamePart(String name) async {
    final response = await _makeRequest(
      'GET',
      '$apiPath/searchByName?name=$name',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendances by user name: ${response.body}');
    }
  }

  // Get attendance by role
  Future<List<Attendance>> getAttendanceByRole(String role) async {
    final response = await _makeRequest(
      'GET',
      '$apiPath/roleAttendance?role=$role',
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load attendances by role: ${response.body}');
    }
  }

  // Get today's attendance by user ID
  Future<List<Attendance>> getTodayAttendanceByUserId(int userId) async {
    final response = await _makeRequest('GET', '$apiPath/todayAttendance/$userId');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load today’s attendance by user ID: ${response.body}');
    }
  }

  Future<Map<String, int>> getAttendanceCountsInRange(DateTime startDate, DateTime endDate) async {
    final response = await _makeRequest(
      'GET',
      '$apiPath/attendanceRange?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      Map<String, int> attendanceCounts = {}; // Changed from Map<User, int> to Map<String, int>
      data.forEach((key, value) {
        attendanceCounts[key] = value;  // Assuming the key is a string, e.g., user ID or name
      });
      return attendanceCounts;
    } else {
      throw Exception('Failed to load attendance counts in range: ${response.body}');
    }
  }

}
