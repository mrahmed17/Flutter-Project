import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hr_and_pms/features/user/model/Role.dart';
import 'package:hr_and_pms/features/user/model/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:8080/api/users';

  // Helper method for error handling
  String _handleError(DioException e) {
    return e.response?.data?['message'] ?? 'Error: ${e.message}';
  }

  // Helper method to prepare user data with profile_demo photo if available
  Future<FormData> _prepareUserDataForm(User user, XFile? profilePhoto) async {
    final formData = FormData();
    formData.fields.add(MapEntry('user', jsonEncode(user.toJson())));

    if (profilePhoto != null) {
      final bytes = await profilePhoto.readAsBytes();
      formData.files.add(
        MapEntry(
          'profilePhoto',
          MultipartFile.fromBytes(bytes, filename: profilePhoto.name),
        ),
      );
    }
    return formData;
  }

  // Update an existing user
  Future<String> updateUser(int id, User user, XFile? profilePhoto) async {
    try {
      final formData = await _prepareUserDataForm(user, profilePhoto);
      final response = await _dio.put('$baseUrl/update/$id', data: formData);

      return response.statusCode == 200
          ? 'User updated successfully.'
          : 'Failed to update user: ${response.statusMessage}';
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('$baseUrl/all');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((userJson) => User.fromJson(userJson))
            .toList();
      } else {
        return Future.error('Failed to load users: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Future.error(_handleError(e));
    }
  }

  // Find user by ID
  Future<User?> findUserById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/find/$id');
      return response.statusCode == 200 ? User.fromJson(response.data) : null;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Delete user
  Future<void> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId'), // Ensure userId here is int
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print("Error in deleteUser: $e");
      rethrow;  // Optionally rethrow or handle error appropriately
    }
  }

  // Find user by email
  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _dio.get('$baseUrl/email/$email');
      return response.statusCode == 200 ? User.fromJson(response.data) : null;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Filtered user search methods
  Future<List<User>> getUsersWithSalaryGreaterThanOrEqual(double salary, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/salary/greaterThanOrEqual',
        queryParameters: {'salary': salary, 'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<User>> getUsersWithSalaryLessThanOrEqual(double salary, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/salary/lessThanOrEqual',
        queryParameters: {'salary': salary, 'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<User>> getUsersByRole(Role role, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/role/${role.name}',
        queryParameters: {'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<User>> searchUsersByName(String name, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/search/name/$name',
        queryParameters: {'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<User>> getUsersByGender(String gender, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/gender/$gender',
        queryParameters: {'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<User>> getUsersByJoinedDate(String joinedDate, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '$baseUrl/joinedDate/$joinedDate',
        queryParameters: {'page': page, 'size': size},
      );
      return (response.data['content'] as List)
          .map((userJson) => User.fromJson(userJson))
          .toList();
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }
}
