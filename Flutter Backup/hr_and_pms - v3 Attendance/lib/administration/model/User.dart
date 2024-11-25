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
  final String cell;
  final double basicSalary;
  final DateTime joinedDate;
  final Map<String, int> leaveBalance; // Map for leave balance
  final String profilePhoto;
  final Role role;
  final List<Attendance> attendances;

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
      cell: json['cell'] ?? '',
      basicSalary: (json['basicSalary'] ?? 0).toDouble(),
      joinedDate: DateTime.tryParse(json['joinedDate'] ?? '') ?? DateTime.now(),
      leaveBalance: (json['leaveBalance'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      profilePhoto: json['profilePhoto'] ?? '',
      role: RoleExtension.fromString(json['role'] ?? 'EMPLOYEE'),
      attendances: (json['attendances'] as List<dynamic>?)
          ?.map((attendance) => Attendance.fromJson(attendance))
          .toList() ??
          [],
    );
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.cell,
    required this.basicSalary,
    required this.joinedDate,
    required this.leaveBalance,
    required this.profilePhoto,
    required this.role,
    this.attendances = const [],
  });

  factory User.empty() {
    return User(
      id: 0,
      name: '',
      email: '',
      password: '',
      address: '',
      gender: '',
      dateOfBirth: DateTime(1900, 1, 1),
      cell: '',
      basicSalary: 0.0,
      joinedDate: DateTime(1900, 1, 1),
      leaveBalance: {},
      profilePhoto: '',
      role: Role.employee,
      attendances: [],
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'gender': gender,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'cell': cell,
      'basicSalary': basicSalary,
      'joinedDate': joinedDate.toIso8601String(),
      'leaveBalance': leaveBalance,
      'profilePhoto': profilePhoto,
      'role': role.toShortString(),
      'attendances':
      attendances.map((attendance) => attendance.toJson()).toList(),
    };
  }
}


// import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
// import 'package:hr_and_pms/administration/model/Role.dart';
//
// class User {
//   final int id;
//   final String name;
//   final String email;
//   final String password;
//   final String address;
//   final String gender;
//   final DateTime dateOfBirth;
//   final String contact;
//   final double basicSalary;
//   final DateTime joinedDate;
//   final int leaveBalance;
//   final String profilePhoto;
//   final Role role;
//   List<Attendance> attendances;
//
// // Factory constructor to create User from JSON
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       password: json['password'] ?? '',
//       address: json['address'] ?? '',
//       gender: json['gender'] ?? '',
//       dateOfBirth:
//           DateTime.tryParse(json['dateOfBirth'] ?? '') ?? DateTime.now(),
//       contact: json['contact'] ?? '',
//       basicSalary: (json['basicSalary'] ?? 0).toDouble(),
//       joinedDate: DateTime.tryParse(json['joinedDate'] ?? '') ?? DateTime.now(),
//       leaveBalance: json['leaveBalance'] ?? 25,
//       profilePhoto: json['profilePhoto'] ?? '',
//       role: RoleExtension.fromString(json['role'] ?? 'EMPLOYEE'),
//       attendances: (json['attendances'] as List<dynamic>?)
//               ?.map((attendance) => Attendance.fromJson(attendance))
//               .toList() ??
//           [],
//     );
//   }
//
//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.password,
//     required this.address,
//     required this.gender,
//     required this.dateOfBirth,
//     required this.contact,
//     required this.basicSalary,
//     required this.joinedDate,
//     required this.leaveBalance,
//     required this.profilePhoto,
//     required this.role,
//     this.attendances = const [],
//   });
//
//   factory User.empty() {
//     return User(
//       id: 0,
//       name: '',
//       email: '',
//       password: '',
//       address: '',
//       gender: '',
//       dateOfBirth: DateTime(1900, 1, 1),
//       contact: '',
//       basicSalary: 0.0,
//       joinedDate: DateTime(1900, 1, 1),
//       leaveBalance: 25,
//       profilePhoto: '',
//       role: Role.employee,
//       attendances: [],
//     );
//   }
//
//   // Method to convert User instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': name,
//       'email': email,
//       'password': password,
//       'address': address,
//       'gender': gender,
//       'dateOfBirth': dateOfBirth.toIso8601String(),
//       'contact': contact,
//       'basicSalary': basicSalary,
//       'joinedDate': joinedDate.toIso8601String(),
//       'leaveBalance': leaveBalance,
//       'profilePhoto': profilePhoto,
//       'role': role.toShortString(),
//       'attendances':
//           attendances.map((attendance) => attendance.toJson()).toList(),
//     };
//   }
// }
