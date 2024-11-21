
import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/administration/model/Role.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String gender;
  final DateTime dateOfBirth;
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
    required this.contact,
    required this.basicSalary,
    required this.joinedDate,
    required this.profilePhoto,
    required this.role,
    this.attendances = const [],
  });

// Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      dateOfBirth: DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
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


  factory User.empty() {
    return User(
      id: 0,
      name: '',
      email: '',
      password: '',
      address: '',
      gender: '',
      dateOfBirth: DateTime(1900, 1, 1),
      contact: '',
      basicSalary: 0.0,
      joinedDate: DateTime(1900, 1, 1),
      profilePhoto: '',
      role: Role.employee,
      attendances: [],
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
      'contact': contact,
      'basicSalary': basicSalary,
      'joinedDate': joinedDate.toIso8601String(),
      'profilePhoto': profilePhoto,
      'role': role.toShortString(),
      'attendances': attendances.map((attendance) => attendance.toJson()).toList(),
    };
  }


}

