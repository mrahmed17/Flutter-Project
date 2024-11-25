import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart'; // Import the enum

class AdvanceSalary {
  int? id;
  double? advanceAmount; // Changed to match the naming convention
  String? reason;
  DateTime? advanceDate;
  User? user;
  RequestStatus? status;
  bool? isPaid;
  DateTime? paidDate;

  AdvanceSalary({
    this.id,
    this.advanceAmount,
    this.reason,
    this.advanceDate,
    this.user,
    this.status,
    this.isPaid,
    this.paidDate,
  });

  // Method to convert JSON to AdvanceSalary instance
  factory AdvanceSalary.fromJson(Map<String, dynamic> json) {
    return AdvanceSalary(
      id: json['id'],
      advanceAmount: json['advanceAmount']?.toDouble(),
      reason: json['reason'],
      advanceDate: json['advanceDate'] != null ? DateTime.tryParse(json['advanceDate']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      status: json['status'] != null ? RequestStatusExtension.fromString(json['status']) : RequestStatus.PENDING,
      isPaid: json['isPaid'],
      paidDate: json['paidDate'] != null ? DateTime.tryParse(json['paidDate']) : null,
    );
  }


  // Method to convert AdvanceSalary instance to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (advanceAmount != null) 'advanceAmount': advanceAmount,
      if (reason != null) 'reason': reason,
      if (advanceDate != null) 'advanceDate': advanceDate?.toIso8601String(),
      if (user != null) 'user': user?.toJson(),
      if (status != null) 'status': status?.toShortString(),
      if (isPaid != null) 'isPaid': isPaid,
      if (paidDate != null) 'paidDate': paidDate?.toIso8601String(),
    };
  }
}


//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'advanceAmount': advanceAmount, // Corrected naming
//       'reason': reason,
//       'advanceDate': advanceDate?.toIso8601String(),
//       'user': user?.toJson(),
//       'status': status?.toShortString(), // Serialize status as short string
//       'isPaid': isPaid, // Added to JSON
//       'paidDate': paidDate?.toIso8601String(), // Added to JSON
//     };
//   }
