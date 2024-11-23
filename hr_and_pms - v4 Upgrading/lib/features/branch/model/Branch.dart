import 'package:flutter/material.dart';

class Branch {
   int? id;
   String? name;
   String? address;
   String? email;
   String? cell;
   String? branchImage; // Nullable branch image field
   DateTime? createdAt; // Non-nullable, as it is set automatically on creation
   DateTime? updatedAt; // Nullable updated date

  Branch({
     this.id,
     this.name,
     this.address,
     this.email,
     this.cell,
    this.branchImage,
     this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating a Branch object from JSON
  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      cell: json['cell'] ?? '',
      branchImage: json['branchImage'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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


// import 'package:flutter/material.dart';
//
// class Branch {
//    int id;
//    String name;
//    String address;
//    String email;
//    String cell;
//    String? branchImage;
//    DateTime? createdAt;
//    DateTime? updatedAt;
//
//   Branch({
//      this.id,
//      this.name,
//      this.address,
//      this.email,
//      this.cell,
//     this.branchImage,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   // Factory constructor for creating a Branch object from JSON
//   factory Branch.fromJson(Map<String, dynamic> json) {
//     return Branch(
//       id: json['id'] as int,
//       name: json['name'] as String,
//       address: json['address'] as String,
//       email: json['email'] as String,
//       cell: json['cell'] as String,
//       branchImage: json['branchImage'] as String?,
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : null,
//     );
//   }
//
//   // Method to convert Branch object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'address': address,
//       'email': email,
//       'cell': cell,
//       'branchImage': branchImage,
//       'createdAt': createdAt?.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
