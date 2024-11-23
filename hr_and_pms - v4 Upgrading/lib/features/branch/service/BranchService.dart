import 'dart:convert';
import 'dart:io';
import 'package:hr_and_pms/features/branch/model/Branch.dart';
import 'package:http/http.dart' as http;

class BranchService {
  static const String baseUrl = 'http://localhost:8080/api/branches';

  // Create a branch
  Future<Branch> createBranch(Branch branch, File? branchPhoto) async {
    try {
      // Create the request
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/create'));

      // Add branch data as a JSON string
      request.fields['branch'] = jsonEncode(branch.toJson());

      // Add the branch photo if provided
      if (branchPhoto != null) {
        request.files.add(
          await http.MultipartFile.fromPath('branchPhotos', branchPhoto.path),
        );
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      return await _handleMultipartResponse(response);
    } catch (e) {
      print('Error in createBranch: $e');
      rethrow; // Propagate the error after logging
    }
  }


  // Update a branch
  Future<void> updateBranch(int id, Branch branch, File? branchPhoto) async {
    final request = _createMultipartRequest('PUT', '/update/$id');
    request.fields['updatedBranch'] = jsonEncode(branch.toJson());

    if (branchPhoto != null) {
      request.files.add(await http.MultipartFile.fromPath('profilePhoto', branchPhoto.path));
    }

    final response = await request.send();
    await _handleVoidMultipartResponse(response);
  }


  // Delete a branch
  Future<void> deleteBranch(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));
    _validateResponse(response);
  }

  // Fetch branch by ID
  Future<Branch> getBranchById(int id) async {
    final response = await _makeGetRequest('/$id');
    return Branch.fromJson(jsonDecode(response.body));
  }

  // Fetch all branches
  Future<List<Branch>> getAllBranches() async {
    final response = await _makeGetRequest('/all');
    return (jsonDecode(response.body) as List)
        .map((data) => Branch.fromJson(data))
        .toList();
  }

  // Fetch branch by name
  Future<Branch> getBranchByName(String name) async {
    final response = await _makeGetRequest('/name/$name');
    return Branch.fromJson(jsonDecode(response.body));
  }

  // Fetch branches by address keyword
  Future<List<Branch>> getBranchesByAddressKeyword(String keyword) async {
    final response = await _makeGetRequest('/address/keyword/$keyword');
    return (jsonDecode(response.body) as List)
        .map((data) => Branch.fromJson(data))
        .toList();
  }

  // Fetch branch by cell
  Future<Branch> getBranchByCell(String cell) async {
    final response = await _makeGetRequest('/cell/$cell');
    return Branch.fromJson(jsonDecode(response.body));
  }

  // Fetch branch by email
  Future<Branch> getBranchByEmail(String email) async {
    final response = await _makeGetRequest('/email/$email');
    return Branch.fromJson(jsonDecode(response.body));
  }

  // Count all branches
  Future<int> countBranches() async {
    final response = await _makeGetRequest('/count');
    return jsonDecode(response.body);
  }


  // Helper: Make GET request
  Future<http.Response> _makeGetRequest(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'));
    _validateResponse(response);
    return response;
  }

  // Helper: Create multipart request
  http.MultipartRequest _createMultipartRequest(String method, String path) {
    return http.MultipartRequest(method, Uri.parse('$baseUrl$path'));
  }

  // Helper: Handle multipart response
  Future<Branch> _handleMultipartResponse(http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return Branch.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Error: ${response.statusCode}, Response: $responseBody');
    }
  }

// For updates where no response body is expected, use this helper:
  Future<void> _handleVoidMultipartResponse(http.StreamedResponse response) async {
    if (response.statusCode != 200) {
      final responseBody = await response.stream.bytesToString();
      throw Exception('Error: ${response.statusCode}, Response: $responseBody');
    }
  }


  // Helper: Validate HTTP response
  void _validateResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error: ${response.statusCode}, Response: ${response.body}');
    }
  }
}
