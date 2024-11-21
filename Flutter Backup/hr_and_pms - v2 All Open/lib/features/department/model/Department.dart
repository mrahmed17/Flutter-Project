
import 'package:hr_and_pms/features/branch/model/Branch.dart';

class Department {
  final int id;
  final String name;
  final String email;
  final String cell;
  final String? depImage;
  final int employeeNum;
  final Branch branch;  // Assuming you have a Branch model to represent the branch
  final DateTime createdAt;
  final DateTime updatedAt;

  Department({
    required this.id,
    required this.name,
    required this.email,
    required this.cell,
    this.depImage,
    required this.employeeNum,
    required this.branch,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating a Department object from JSON
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      cell: json['cell'] as String,
      depImage: json['depImage'] as String?,
      employeeNum: json['employeeNum'] as int,
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>),  // Parsing the branch object
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Department object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cell': cell,
      'depImage': depImage,
      'employeeNum': employeeNum,
      'branch': branch.toJson(),  // Converting the branch object to JSON
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
