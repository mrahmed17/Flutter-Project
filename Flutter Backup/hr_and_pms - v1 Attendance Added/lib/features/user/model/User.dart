
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/user/model/Role.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String gender;
  final DateTime dateOfBirth;
  final String nationalId;
  final String contact;
  final double basicSalary;
  final DateTime joinedDate;
  final String profilePhoto;
  final Role role;
  final List<Attendance> attendances;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.nationalId,
    required this.contact,
    required this.basicSalary,
    required this.joinedDate,
    required this.profilePhoto,
    required this.role,
    this.attendances = const [],
  });

  // Method to convert JSON to User instance
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
      nationalId: json['nationalId'] ?? '',
      contact: json['contact'] ?? '',
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      joinedDate: DateTime.tryParse(json['joinedDate'] ?? '') ?? DateTime.now(),
      profilePhoto: json['profilePhoto'] ?? '',
      role: RoleExtension.fromString(json['role'] ?? 'EMPLOYEE'),
      attendances: (json['attendances'] as List<dynamic>?)
          ?.map((attendance) => Attendance.fromJson(attendance))
          .toList() ??
          [],
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': name,
      'email': email,
      'password': password,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'nationalId': nationalId,
      'contact': contact,
      'basicSalary': basicSalary,
      'joinedDate': joinedDate.toIso8601String(),
      'profilePhoto': profilePhoto,
      'role': role.toShortString(),
      'attendances': attendances.map((attendance) => attendance.toJson()).toList(),
    };
  }
}
