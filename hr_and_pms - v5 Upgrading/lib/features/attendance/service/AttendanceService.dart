import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';

class AttendanceService {
  final String baseUrl = 'http://localhost:8080/api/attendances';

  /// Check-in method
  Future<Attendance?> checkIn(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check-in/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Attendance.fromJson(json.decode(response.body));
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception('Failed to check in: ${e.toString()}');
    }
  }

  /// Check-out method
  Future<Attendance?> checkOut(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check-out/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Attendance.fromJson(json.decode(response.body));
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception('Failed to check out: ${e.toString()}');
    }
  }

  /// Get monthly attendance count
  Future<int> getMonthlyAttendanceCount(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/monthly-count/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as int;
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception('Failed to fetch monthly attendance count: ${e.toString()}');
    }
  }

  /// Get attendances by user ID
  Future<List<Attendance>> getAttendancesByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Attendance.fromJson(json)).toList();
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception('Failed to fetch attendances: ${e.toString()}');
    }
  }

  /// Get today's total attendance
  Future<List<Attendance>> getTodayTotalAttendance() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/today'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Attendance.fromJson(json)).toList();
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception('Failed to fetch today\'s total attendance: ${e.toString()}');
    }
  }

  /// Utility to parse HTTP errors
  String _handleError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return errorData['message'] ?? 'Unexpected error occurred.';
    } catch (_) {
      return 'Unexpected error occurred: ${response.reasonPhrase}';
    }
  }
}
