import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_and_pms/features/salary/model/Salary.dart';

class SalaryService {
  final String baseUrl = "http://localhost:8080/api/salaries"; // Replace with your backend URL

  /// Create a new salary
  Future<Salary> createSalary(Salary salary) async {
    final url = Uri.parse("$baseUrl/create");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(salary.toJson()),
    );

    if (response.statusCode == 201) {
      return Salary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create salary. ${response.body}");
    }
  }

  /// Update an existing salary
  Future<Salary> updateSalary(int salaryId, Salary salary) async {
    final url = Uri.parse("$baseUrl/update/$salaryId");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(salary.toJson()),
    );

    if (response.statusCode == 200) {
      return Salary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update salary. ${response.body}");
    }
  }

  /// Delete a salary by ID
  Future<void> deleteSalary(int salaryId) async {
    final url = Uri.parse("$baseUrl/delete/$salaryId");
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception("Failed to delete salary. ${response.body}");
    }
  }

  /// Get a salary by ID
  Future<Salary> getSalaryById(int salaryId) async {
    final url = Uri.parse("$baseUrl/find/$salaryId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Salary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch salary. ${response.body}");
    }
  }

  /// Get salaries within a date range
  Future<List<Salary>> getSalariesByDateRange(
      DateTime startDate, DateTime endDate) async {
    final url = Uri.parse(
        "$baseUrl/dateRange?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Salary.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch salaries by date range. ${response.body}");
    }
  }

  /// Get the latest salary for a specific user
  Future<List<Salary>> getLatestSalaryByUser(int userId) async {
    final url = Uri.parse("$baseUrl/latest/$userId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Salary.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch latest salary. ${response.body}");
    }
  }

  /// Get all salaries
  Future<List<Salary>> getAllSalaries() async {
    final url = Uri.parse("$baseUrl/all");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Salary.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch all salaries. ${response.body}");
    }
  }
}
