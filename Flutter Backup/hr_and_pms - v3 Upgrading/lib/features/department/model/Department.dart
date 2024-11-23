import 'package:hr_and_pms/features/branch/model/Branch.dart';

class Department {
  final int id;
  final String name;
  final String email;
  final String cell;
  final String? depImage; // Nullable department image field
  final int employeeNum; // Employee count field
  final Branch branch; // Reference to Branch object
  final DateTime createdAt; // Non-nullable createdAt
  final DateTime? updatedAt; // Nullable updatedAt

  Department({
    required this.id,
    required this.name,
    required this.email,
    required this.cell,
    this.depImage,
    required this.employeeNum,
    required this.branch,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating a Department object from JSON
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cell: json['cell'] ?? '',
      depImage: json['depImage'],
      employeeNum: json['employeeNum'] ?? 0,
      branch: Branch.fromJson(json['branch'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
      'branch': branch.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
