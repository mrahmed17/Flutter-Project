import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';

class Salary {
  int? id;
  DateTime? paymentDate;
  double? netSalary;
  double? tax;
  double? providentFund;

  double? advanceSalaryId;
  List<Bonus>? bonuses;
  List<Leave>? leaves;
  List<Attendance>? overTime;
  int? userId;
  RequestStatus? salaryStatus;

  Salary({
    this.id,
    this.paymentDate,
    this.netSalary,
    this.tax,
    this.providentFund,
    this.advanceSalaryId,
    this.bonuses,
    this.leaves,
    this.overTime,
    this.userId,
    this.salaryStatus,
  });

  /// Factory constructor to create a `Salary` instance from JSON
  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      id: json['id'] ?? 0,
      paymentDate: DateTime.tryParse(json['paymentDate'] ?? '') ?? DateTime.now(),
      netSalary: json['netSalary']?.toDouble() ?? 0.0,
      tax: json['tax']?.toDouble() ?? 0.0,
      providentFund: json['providentFund']?.toDouble() ?? 0.0,
      advanceSalaryId: json['advanceSalaryId'], // Mapped directly as an ID
      bonuses: (json['bonuses'] as List<dynamic>?)
          ?.map((item) => Bonus.fromJson(item))
          .toList() ?? [],
      leaves: (json['leaves'] as List<dynamic>?)
          ?.map((item) => Leave.fromJson(item))
          .toList() ?? [],
      overTime: (json['overTime'] as List<dynamic>?)
          ?.map((item) => Attendance.fromJson(item))
          .toList() ?? [],
      userId: json['userId'] ?? 0, // Direct userId mapping for consistency
      salaryStatus: json['salaryStatus'] != null
          ? RequestStatusExtension.fromString(json['salaryStatus'])
          : null, // Assuming you have a RequestStatus enum and extension
    );
  }

  /// Method to convert a `Salary` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paymentDate': paymentDate?.toIso8601String(),
      'netSalary': netSalary,
      'tax': tax,
      'providentFund': providentFund,
      'advanceSalaryId': advanceSalaryId, // Serialized as ID directly
      'bonuses': bonuses?.map((item) => item.toJson()).toList(),
      'leaves': leaves?.map((item) => item.toJson()).toList(),
      'overTime': overTime?.map((item) => item.toJson()).toList(),
      'userId': userId, // User ID directly serialized
      'salaryStatus': salaryStatus?.toShortString(), // Assuming you want to serialize it as a string
    };
  }
}