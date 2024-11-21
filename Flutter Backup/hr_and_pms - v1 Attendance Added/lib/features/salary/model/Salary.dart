

import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';

class Salary {
  final int id;
  final DateTime paymentDate;
  final double medicare;
  final double providentFund;
  final double insurance;
  final double transportAllowance;
  final double telephoneSubsidy;
  final double utilityAllowance;
  final double domesticAllowance;
  final double lunchAllowance;
  final double netSalary;
  final double tax;
  final List<Attendance> overTime;
  final int userId; // Reference to User ID only
  final int? advanceSalaryId; // Reference to Advance Salary ID
  final List<Bonus> bonuses;
  final List<Leave> leaves;

  Salary({
    required this.id,
    required this.paymentDate,
    required this.medicare,
    required this.providentFund,
    required this.insurance,
    required this.transportAllowance,
    required this.telephoneSubsidy,
    required this.utilityAllowance,
    required this.domesticAllowance,
    required this.lunchAllowance,
    required this.netSalary,
    required this.tax,
    required this.overTime,
    required this.userId,
    this.advanceSalaryId,
    required this.bonuses,
    required this.leaves,
  });

  // Factory constructor to create a Salary instance from JSON
  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'] ?? 0,
      paymentDate: DateTime.parse(json['paymentDate'] ?? DateTime.now().toString()),
      medicare: json['medicare']?.toDouble() ?? 0.0,
      providentFund: json['providentFund']?.toDouble() ?? 0.0,
      insurance: json['insurance']?.toDouble() ?? 0.0,
      transportAllowance: json['transportAllowance']?.toDouble() ?? 0.0,
      telephoneSubsidy: json['telephoneSubsidy']?.toDouble() ?? 0.0,
      utilityAllowance: json['utilityAllowance']?.toDouble() ?? 0.0,
      domesticAllowance: json['domesticAllowance']?.toDouble() ?? 0.0,
      lunchAllowance: json['lunchAllowance']?.toDouble() ?? 0.0,
      netSalary: json['netSalary']?.toDouble() ?? 0.0,
      tax: json['tax']?.toDouble() ?? 0.0,
      overTime: (json['overTime'] as List<dynamic>?)
          ?.map((item) => Attendance.fromJson(item))
          .toList() ??
          [],
      userId: json['user']['id'] ?? 0, // Assuming `user` is an object with `id`
      advanceSalaryId: json['advanceSalary']?['id'],
      bonuses: (json['bonuses'] as List<dynamic>?)
          ?.map((item) => Bonus.fromJson(item))
          .toList() ??
          [],
      leaves: (json['leaves'] as List<dynamic>?)
          ?.map((item) => Leave.fromJson(item))
          .toList() ??
          [],
    );
  }

  // Method to convert a Salary instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentDate': paymentDate.toIso8601String(),
      'medicare': medicare,
      'providentFund': providentFund,
      'insurance': insurance,
      'transportAllowance': transportAllowance,
      'telephoneSubsidy': telephoneSubsidy,
      'utilityAllowance': utilityAllowance,
      'domesticAllowance': domesticAllowance,
      'lunchAllowance': lunchAllowance,
      'netSalary': netSalary,
      'tax': tax,
      'overTime': overTime.map((item) => item.toJson()).toList(),
      'user': {'id': userId}, // Only userId is serialized here
      'advanceSalary': advanceSalaryId != null ? {'id': advanceSalaryId} : null,
      'bonuses': bonuses.map((item) => item.toJson()).toList(),
      'leaves': leaves.map((item) => item.toJson()).toList(),
    };
  }
}
