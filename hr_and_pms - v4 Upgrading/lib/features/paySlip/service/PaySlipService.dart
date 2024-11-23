import 'dart:convert';
import 'package:http/http.dart' as http;

class PaySlipService {
  final String baseUrl = 'http://localhost:8080/api/payslips';

  // Fetch PaySlips by Employee ID
  Future<List<dynamic>> getPayslipsByEmployee(int employeeId) async {
    final response = await http.get(Uri.parse('$baseUrl/$employeeId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslips for employee');
    }
  }

  // Fetch PaySlips by Manager ID
  Future<List<dynamic>> getPayslipsByManager(int managerId) async {
    final response = await http.get(Uri.parse('$baseUrl/manager/$managerId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslips for manager');
    }
  }

  // Fetch PaySlips by Status
  Future<List<dynamic>> getPayslipsByStatus(String status) async {
    final response = await http.get(Uri.parse('$baseUrl/status/$status'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslips by status');
    }
  }

  // Fetch PaySlips by Employee ID and Status
  Future<List<dynamic>> getPayslipsByEmployeeAndStatus(
      int employeeId, String status) async {
    final response =
    await http.get(Uri.parse('$baseUrl/$employeeId/status/$status'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load payslips for employee $employeeId with status $status');
    }
  }

  // Fetch PaySlips by Billing Date Range
  Future<List<dynamic>> getPayslipsByDateRange(
      String startDate, String endDate) async {
    final response = await http
        .get(Uri.parse('$baseUrl/date-range?startDate=$startDate&endDate=$endDate'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslips by date range');
    }
  }

  // Fetch a PaySlip by Salary ID
  Future<dynamic> getPayslipBySalaryId(int salaryId) async {
    final response = await http.get(Uri.parse('$baseUrl/salary/$salaryId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslip for salary ID $salaryId');
    }
  }

  // Fetch PaySlips by Payment Method
  Future<List<dynamic>> getPayslipsByPaymentMethod(String paymentMethod) async {
    final response =
    await http.get(Uri.parse('$baseUrl/payment-method/$paymentMethod'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load payslips by payment method');
    }
  }

  // Count PaySlips by Status
  Future<int> countPayslipsByStatus(String status) async {
    final response = await http.get(Uri.parse('$baseUrl/count/status/$status'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as int;
    } else {
      throw Exception('Failed to count payslips by status');
    }
  }

  // Create PaySlip
  Future<dynamic> createPaySlip({
    required int employeeId,
    required int managerId,
    required int salaryId,
    required double totalAmount,
    required String paymentMethod,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'employeeId': employeeId,
        'managerId': managerId,
        'salaryId': salaryId,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create payslip');
    }
  }
}
