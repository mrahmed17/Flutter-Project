// import 'package:hr_and_pms/administration/model/User.dart';
// import 'package:hr_and_pms/features/leave/model/RequestStatus.dart'; // Import the enum
//
// class AdvanceSalary {
//    int? id;
//    double? advanceAmount;
//    String? reason;
//    DateTime? advanceDate;
//    User? user;
//    RequestStatus? status; // Change status type to RequestStatus enum
//
//   AdvanceSalary({
//      this.id,
//      this.advanceAmount,
//      this.reason,
//      this.advanceDate,
//      this.user,
//      this.status,
//   });
//
//   // Create a copyWith method to return a new instance with a modified status
//   AdvanceSalary copyWith({
//     int? id,
//     double? advanceSalary,
//     String? reason,
//     DateTime? advanceDate,
//     User? user,
//     RequestStatus? status, // Change status to RequestStatus type
//   }) {
//     return AdvanceSalary(
//       id: id ?? this.id,
//       advanceAmount: advanceSalary ?? this.advanceAmount,
//       reason: reason ?? this.reason,
//       advanceDate: advanceDate ?? this.advanceDate,
//       user: user ?? this.user,
//       status: status ?? this.status,  // Use the new status or keep the old one
//     );
//   }
//
//   // Method to convert JSON to AdvanceSalary instance
//   factory AdvanceSalary.fromJson(Map<String, dynamic> json) {
//     return AdvanceSalary(
//       id: json['id'] ?? 0,
//       advanceAmount: json['advanceSalary']?.toDouble() ?? 0.0,
//       reason: json['reason'] ?? '',
//       advanceDate: DateTime.parse(json['advanceDate'] ?? DateTime.now().toString()),
//       user: User.fromJson(json['user'] ?? {}),
//       status: RequestStatusExtension.fromString(json['status'] ?? 'Pending'), // Convert string to enum
//     );
//   }
//
//   // Method to convert AdvanceSalary instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'advanceSalary': advanceAmount,
//       'reason': reason,
//       'advanceDate': advanceDate?.toIso8601String(),
//       'user': user?.toJson(),
//       'status': status?.toShortString(), // Serialize status as short string
//     };
//   }
// }
