// import 'dart:convert';
// import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
// import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
// import 'package:http/http.dart' as http;
//
// class AdvanceSalaryService {
//   static const String baseUrl = 'http://localhost:8080/api/advanceSalaries';
//
//   // Create a new advance salary record
//   Future<AdvanceSalary> createAdvanceSalary(AdvanceSalary advanceSalary) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/create'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(advanceSalary.toJson()),
//       );
//       if (response.statusCode == 201) {
//         return AdvanceSalary.fromJson(json.decode(response.body));
//       } else {
//         throw Exception('Failed to create advance salary');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Update the status of an advance salary application
//   Future<void> updateAdvanceSalary(int applicationId, AdvanceSalary updatedApplication) async {
//     final url = Uri.parse('$baseUrl/update/$applicationId');
//     final response = await http.put(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(updatedApplication.toJson()),
//     );
//
//     if (response.statusCode != 200) {
//       throw Exception('Failed to update advance salary application');
//     }
//   }
//
//   // Delete an advance salary record
//   Future<void> deleteAdvanceSalary(int id) async {
//     try {
//       final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
//       if (response.statusCode != 204) {
//         throw Exception('Failed to delete advance salary');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch advance salary by ID
//   Future<AdvanceSalary> getAdvanceSalaryById(int id) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/find/$id'));
//       if (response.statusCode == 200) {
//         return AdvanceSalary.fromJson(json.decode(response.body));
//       } else {
//         throw Exception('Advance salary record not found');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch all advance salary applications for admins/managers
//   Future<List<AdvanceSalary>> getAllAdvanceSalaries() async {
//     final url = Uri.parse('$baseUrl/all'); // Adjust endpoint as needed
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => AdvanceSalary.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch all advance salary applications');
//     }
//   }
//
//   // Fetch advance salary applications for a specific user
//   Future<List<AdvanceSalary>> getAdvanceSalaries(int id) async {
//     final url = Uri.parse('$baseUrl/findAll/$id'); // Adjust endpoint as needed
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => AdvanceSalary.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch advance salary history');
//     }
//   }
//
//   // Fetch advance salaries for a user within a specific date range
//   Future<List<AdvanceSalary>> getAdvanceSalariesByUserAndDateRange(
//       int id, DateTime startDate, DateTime endDate) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             '$baseUrl/userDate-range/$id?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to fetch salaries for user within date range');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch all pending advance salary requests
//   Future<List<AdvanceSalary>> getPendingSalaryRequests() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/pending'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load pending salary requests');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch rejected advance salary requests
//   Future<List<AdvanceSalary>> getRejectedSalaryRequests() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/rejected'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load rejected salary requests');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch approved advance salary records for a specific user
//   Future<List<AdvanceSalary>> getApprovedSalaryByUser(int id) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/approved/user/$id'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load approved salaries');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch the top 5 advance salaries for a user, sorted by advance date
//   Future<List<AdvanceSalary>> getTop5AdvanceSalariesByUser(int id) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/topAdvanceTaker/user/$id'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to fetch top advance salaries');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch advance salaries within a specific date range
//   Future<List<AdvanceSalary>> getAdvanceSalariesByDateRange(
//       DateTime startDate, DateTime endDate) async {
//     try {
//       final response = await http.get(
//         Uri.parse(
//             '$baseUrl/date-range?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to fetch salaries within date range');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
//   // Fetch advance salary applications based on user ID and status
//   Future<List<AdvanceSalary>> getAdvanceSalariesByStatus(int userId, RequestStatus status) async {
//     try {
//       // Create the URL with status and user ID
//       final url = Uri.parse('$baseUrl/status/$status/user/$userId');
//
//       // Send the GET request to the backend
//       final response = await http.get(url);
//
//       // Check if the response is successful
//       if (response.statusCode == 200) {
//         // Parse the response body to a list of AdvanceSalary objects
//         List<dynamic> data = json.decode(response.body);
//         return data.map((item) => AdvanceSalary.fromJson(item)).toList();
//       } else {
//         throw Exception('Failed to load advance salary applications');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
//
// }
