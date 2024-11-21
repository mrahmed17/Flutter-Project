import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/salary/model/Salary.dart';

class PaySlip {
  final int id;
  final double totalAmount;
  final DateTime billingDate;
  final String paymentMethod;
  final String status;
  final User paidBy;
  final User receivedBy;
  final Salary salary;

  PaySlip({
    required this.id,
    required this.totalAmount,
    required this.billingDate,
    required this.paymentMethod,
    required this.status,
    required this.paidBy,
    required this.receivedBy,
    required this.salary,
  });

  // Factory method to create a PaySlipModel from a JSON map
  factory PaySlip.fromJson(Map<String, dynamic> json) {
    return PaySlip(
      id: json['id'],
      totalAmount: json['totalAmount'],
      billingDate: DateTime.parse(json['billingDate']),
      paymentMethod: json['paymentMethod'],
      status: json['status'],
      paidBy: User.fromJson(json['paidBy']),
      receivedBy: User.fromJson(json['receivedBy']),
      salary: Salary.fromJson(json['salary']),
    );
  }

  // Method to convert a PaySlipModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'billingDate': billingDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
      'paidBy': paidBy.toJson(),
      'receivedBy': receivedBy.toJson(),
      'salary': salary.toJson(),
    };
  }
}
