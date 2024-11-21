import 'package:flutter/material.dart';

class Branch {
  final int id;
  final String name;
  final String address;
  final String email;
  final String cell;
  final String? branchImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.cell,
    this.branchImage,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating a Branch object from JSON
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      email: json['email'] as String,
      cell: json['cell'] as String,
      branchImage: json['branchImage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Method to convert Branch object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'cell': cell,
      'branchImage': branchImage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
