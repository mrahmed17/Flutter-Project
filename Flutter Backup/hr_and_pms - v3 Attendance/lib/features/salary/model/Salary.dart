import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';

class Salary {
   int? id;
   DateTime? paymentDate;
   double? medicare;
   double? providentFund;
   double? insurance;
   double? transportAllowance;
   double? telephoneSubsidy;
   double? utilityAllowance;
   double? domesticAllowance;
   double? lunchAllowance;
   double? netSalary;
   double? tax;
   List<Attendance>? overtime; // Updated naming for clarity
   int? userId; // Reference to User ID
   int? advanceSalaryId; // Reference to Advance Salary ID
   List<Bonus>? bonuses;
   List<Leave>? leaves;

  Salary({
     this.id,
     this.paymentDate,
     this.medicare,
     this.providentFund,
     this.insurance,
     this.transportAllowance,
     this.telephoneSubsidy,
     this.utilityAllowance,
     this.domesticAllowance,
     this.lunchAllowance,
     this.netSalary,
     this.tax,
     this.overtime,
     this.userId,
    this.advanceSalaryId,
     this.bonuses,
     this.leaves,
  });

  /// Factory constructor to create a `Salary` instance from JSON
  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'] ?? 0,
      paymentDate: DateTime.parse(json['paymentDate']),
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
      overtime: (json['overtime'] as List<dynamic>?)
          ?.map((item) => Attendance.fromJson(item))
          .toList() ??
          [],
      userId: json['userId'] ?? 0, // Direct userId mapping for consistency
      advanceSalaryId: json['advanceSalaryId'], // Mapped directly as an ID
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

  /// Method to convert a `Salary` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentDate': paymentDate?.toIso8601String(),
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
      'overtime': overtime?.map((item) => item.toJson()).toList(),
      'userId': userId, // User ID directly serialized
      'advanceSalaryId': advanceSalaryId, // Serialized as ID directly
      'bonuses': bonuses?.map((item) => item.toJson()).toList(),
      'leaves': leaves?.map((item) => item.toJson()).toList(),
    };
  }
}
