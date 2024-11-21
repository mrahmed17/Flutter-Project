
import 'package:hr_and_pms/features/user/model/User.dart';

class AdvanceSalary {
  final int id;
  final double advanceSalary;
  final String reason;
  final DateTime advanceDate;
  final User user;

  AdvanceSalary({
    required this.id,
    required this.advanceSalary,
    required this.reason,
    required this.advanceDate,
    required this.user,
  });

  // Method to convert JSON to AdvanceSalary instance
  factory AdvanceSalary.fromJson(Map<String, dynamic> json) {
    return AdvanceSalary(
      id: json['id'] ?? 0,
      advanceSalary: json['advanceSalary']?.toDouble() ?? 0.0,
      reason: json['reason'] ?? '',
      advanceDate: DateTime.parse(json['advanceDate'] ?? DateTime.now().toString()),
      user: User.fromJson(json['user'] ?? {}), // Assuming `user` is an object
    );
  }

  // Method to convert AdvanceSalary instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advanceSalary': advanceSalary,
      'reason': reason,
      'advanceDate': advanceDate.toIso8601String(),
      'user': user.toJson(), // Serialize the `User` object
    };
  }
}
