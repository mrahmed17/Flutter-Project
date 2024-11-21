import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LeaveService {
  final String baseUrl = 'http://localhost:8080/api/leaves';

  // Method to save a leave request
  Future<Map<String, dynamic>> saveLeaveRequest(Map<String, dynamic> leaveData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(leaveData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save leave request');
    }
  }

  // Method to update a leave request
  Future<Map<String, dynamic>> updateLeaveRequest(int leaveId, Map<String, dynamic> leaveData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$leaveId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(leaveData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update leave request');
    }
  }

  // Method to delete a leave request by ID
  Future<void> deleteLeave(int leaveId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$leaveId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete leave');
    }
  }

  // Method to get leave by ID
  Future<Map<String, dynamic>> getLeaveById(int leaveId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/find/$leaveId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Leave not found');
    }
  }

  // Method to approve a leave request
  Future<Map<String, dynamic>> approveLeaveRequest(int leaveId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/approve/$leaveId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to approve leave request');
    }
  }

  // Method to reject a leave request
  Future<Map<String, dynamic>> rejectLeaveRequest(int leaveId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reject/$leaveId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to reject leave request');
    }
  }

  // Method to get all pending leave requests
  Future<List<Map<String, dynamic>>> getPendingLeaveRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/pending'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load pending leaves');
    }
  }

  // Method to get all leaves by leave type
  Future<List<Map<String, dynamic>>> getLeavesByType(String leaveType) async {
    final response = await http.get(
      Uri.parse('$baseUrl/type/$leaveType'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load leaves by type');
    }
  }

  // Method to get rejected leave requests
  Future<List<Map<String, dynamic>>> getRejectedLeaveRequests() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rejected'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load rejected leaves');
    }
  }

  // Method to get approved leaves by user ID
  Future<List<Map<String, dynamic>>> getApprovedLeavesByUser(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/approved'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load approved leaves for user');
    }
  }

  // Method to get leaves by user and date range
  Future<List<Map<String, dynamic>>> getLeavesByUserAndDateRange(int userId, DateTime startDate, DateTime endDate) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/range?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load leaves by date range');
    }
  }

  // Method to get leaves by reason
  Future<List<Map<String, dynamic>>> getLeavesByReason(String reason) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reason/$reason'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load leaves by reason');
    }
  }
}
