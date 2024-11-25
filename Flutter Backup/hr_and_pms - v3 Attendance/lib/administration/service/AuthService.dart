import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/administration/model/Role.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://localhost:8080';

  // Helper method to handle errors from Dio
  String _handleError(DioException e) {
    return e.response?.data?['message'] ?? 'Error: ${e.message}';
  }

  // Register a user (admin, manager, employee)
  Future<bool> register(Map<String, dynamic> user, String role) async {
    try {
      final url = Uri.parse('$baseUrl/register/$role');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(user);

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Save the token and role in SharedPreferences
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('authToken', token);
        await preferences.setString('userRole', role);

        return true;
      } else {
        print('Registration failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        //Decode token to get role
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        String role = payload['role'];

        //Store token and role
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setString('authToken', token);
        await preferences.setString('userRole', role);
        await preferences.setString('user', jsonEncode(user));

        // For getting login usr profile data
        // Line from Nusrat
        // await preferences.setString('user', jsonEncode(data['user']));

        return true;
      } else {
        print('Failed to login: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('authToken');
    await preferences.remove('userRole');
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken();
    if (token != null && !(await isTokenExpired())) {
      return true;
    } else {
      await logout();
      return false;
    }
  }

  Future<bool> isTokenExpired() async {
    String? token = await getToken();
    if (token != null) {
      DateTime? expiryDate = Jwt.getExpiryDate(token);
      if (expiryDate != null) {
        return DateTime.now().isAfter(expiryDate);
      } else {
        return true;
      }
    }
    return true;
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('authToken');
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    User? user = User.fromJson(jsonDecode(userJson!));
    return user;
    }

  Future<String?> getUserRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print(preferences.getString('userRole'));
    return preferences.getString('userRole');
  }


  // Method to fetch logged-in user details
  Future<User?> getLoggedInUserDetails() async {
    try {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken == null) {
        // No token found, user is not authenticated
        return null;
      }

      // Set up the request headers
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',  // Add token to Authorization header
      };

      // Send GET request to fetch the logged-in user details
      final response = await _dio.get('$baseUrl/me', options: Options(headers: headers));

      if (response.statusCode == 200) {
        // Parse the response body and return the user
        return User.fromJson(response.data);
      } else {
        print('Failed to get user details: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching user details: ${_handleError(e)}');
      return null;
    }
  }

  Future<bool> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot-password');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true; // Reset link sent successfully
      } else {
        print('Failed to send reset link: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Update user profile with optional profile photo
  Future<String> updateUserProfile(int id, User user, XFile? profilePhoto) async {
    try {
      final formData = await _prepareUserDataForm(user, profilePhoto);
      final response = await _dio.put(
        '$baseUrl/api/users/update/$id',
        data: formData,
      );

      return response.statusCode == 200
          ? 'User updated successfully.'
          : 'Failed to update user: ${response.statusMessage}';
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Helper method to prepare user data with profile photo if available
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

  // Get user by ID
  Future<User?> getUserById(int id) async {
    try {
      final response = await _dio.get('$baseUrl/api/users/find/$id');
      return response.statusCode == 200 ? User.fromJson(response.data) : null;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get('$baseUrl/api/users/all');
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

  Future<bool> hasRole(List<String> roles) async {
    String? role = await getUserRole();
    return role != null && roles.contains(role);
  }

  Future<bool> isAdmin() async {
    return await hasRole(['ADMIN']);
  }

  Future<bool> isManager() async {
    return await hasRole(['MANAGER']);
  }

  Future<bool> isEmployee() async {
    return await hasRole(['EMPLOYEE']);
  }
}
