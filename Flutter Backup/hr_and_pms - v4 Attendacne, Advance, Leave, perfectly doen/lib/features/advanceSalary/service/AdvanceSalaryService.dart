import 'dart:convert';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:http/http.dart' as http;

class AdvanceSalaryService {
  static const String baseUrl = 'http://localhost:8080/api/advanceSalaries';

  // Helper method for handling GET requests
  Future<List<AdvanceSalary>> _fetchAdvanceSalaries(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => AdvanceSalary.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from the server. Please try again later.');

      // throw Exception('Error: $e');
    }
  }

  // Helper method for handling POST/PUT/PATCH/DELETE requests
  Future<AdvanceSalary> _sendRequest(
      String url, String method, {AdvanceSalary? body}) async {
    try {
      final request = http.Request(method, Uri.parse(url))
        ..headers.addAll({'Content-Type': 'application/json'})
        ..body = body != null ? json.encode(body.toJson()) : '';

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 204) {
        // Some responses (e.g., DELETE) may not return a body
        return responseBody.isNotEmpty
            ? AdvanceSalary.fromJson(json.decode(responseBody))
            : body!;
      } else {
        throw Exception(
            'Request failed with status ${streamedResponse.statusCode}: ${streamedResponse.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


  // Apply for a new advance salary
  Future<AdvanceSalary> applyAdvanceSalary(AdvanceSalary advanceSalary) async {
    return _sendRequest('$baseUrl/apply', 'POST', body: advanceSalary);
  }

  // Approve an advance salary application by ID
  Future<AdvanceSalary> approveAdvanceSalary(int id) async {
    return _sendRequest('$baseUrl/$id/approve', 'PUT');
  }

  // Reject an advance salary application by ID
  Future<AdvanceSalary> getRejectedAdvanceSalary(int id) async {
    return _sendRequest('$baseUrl/$id/reject', 'PATCH');
  }

  // Fetch all pending advance salary requests
  Future<List<AdvanceSalary>> getPendingSalaryRequests() async {
    return _fetchAdvanceSalaries('$baseUrl/pending');
  }

  // Fetch all advance salaries by user
  Future<List<AdvanceSalary>> getAllAdvanceSalariesByUser(int userId) async {
    return _fetchAdvanceSalaries('$baseUrl/user/$userId/all');
  }

  // Fetch all advance salaries
  Future<List<AdvanceSalary>> getAllAdvanceSalaries() async {
    return _fetchAdvanceSalaries('$baseUrl/all');
  }

  // Fetch approved advance salaries by user
  Future<List<AdvanceSalary>> getApprovedSalaryByUser(int userId) async {
    return _fetchAdvanceSalaries('$baseUrl/user/$userId/approved');
  }

  // Fetch advance salaries by status
  Future<List<AdvanceSalary>> getAdvanceSalariesByStatus(RequestStatus status) async {
    return _fetchAdvanceSalaries('$baseUrl/status/$status');
  }

  // Fetch advance salary by ID
  Future<AdvanceSalary> getAdvanceSalaryById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return AdvanceSalary.fromJson(json.decode(response.body));
      } else {
        throw Exception('Advance salary record not found');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // // Fetch advance salaries for a specific user
  // Future<List<AdvanceSalary>> getAdvanceSalariesByUser(int userId) async {
  //   return _fetchAdvanceSalaries('$baseUrl/user/$userId');
  // }

  // // Fetch advance salaries for a specific user and status
  // Future<List<AdvanceSalary>> getAdvanceSalariesByUserAndStatus(int userId, RequestStatus status) async {
  //   return _fetchAdvanceSalaries('$baseUrl/user/$userId/status/$status');
  // }
}

