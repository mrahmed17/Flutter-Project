import 'dart:convert';
import 'package:hr_and_pms/features/leave/model/Leave.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LeaveService {
  final String baseUrl = 'http://localhost:8080/api/leaves';

  /// Apply for leave
  Future<Leave> applyLeave(Leave leave, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/apply/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(leave.toJson()),
    );

    if (response.statusCode == 200) {
      return Leave.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to apply leave: ${response.reasonPhrase}');
    }
  }

  /// Update a leave request
  Future<Leave> updateLeaveRequest(int leaveId, Leave leave) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$leaveId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(leave.toJson()),
    );

    if (response.statusCode == 200) {
      return Leave.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update leave request: ${response.reasonPhrase}');
    }
  }

  /// Delete a leave by ID
  Future<void> deleteLeave(int leaveId) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$leaveId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete leave: ${response.reasonPhrase}');
    }
  }

  /// Get all pending leave requests
  Future<List<Leave>> getAllPendingLeaves() async {
    final response = await http.get(Uri.parse('$baseUrl/pending'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leave.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pending leaves: ${response.reasonPhrase}');
    }
  }

  /// Get all leaves for a specific user
  Future<List<Leave>> getAllLeavesByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId/all'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leave.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch all leaves for user: ${response.reasonPhrase}');
    }
  }

  /// Get user leaves (approved only)
  Future<List<Leave>> getUserLeaves(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leave.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch user leaves: ${response.reasonPhrase}');
    }
  }

  /// Get leaves for a user within a specific date range
  Future<List<Leave>> getLeavesByUserAndDateRange(
      int userId, DateTime startDate, DateTime endDate) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/user/$userId/range?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Leave.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leaves by date range: ${response.reasonPhrase}');
    }
  }

  /// Approve a leave request
  Future<Leave> approveLeave(int leaveId) async {
    final response = await http.patch(Uri.parse('$baseUrl/$leaveId/approve'));

    if (response.statusCode == 200) {
      return Leave.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to approve leave request: ${response.reasonPhrase}');
    }
  }

  /// Reject a leave request
  Future<Leave> rejectLeave(int leaveId) async {
    final response = await http.patch(Uri.parse('$baseUrl/$leaveId/reject'));

    if (response.statusCode == 200) {
      return Leave.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reject leave request: ${response.reasonPhrase}');
    }
  }
}
