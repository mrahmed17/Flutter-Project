import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/salary/model/Salary.dart';

class PaySlip {
   int? id;
   double? totalAmount;
   DateTime? billingDate;
   String? paymentMethod;
   String? status;
   User? paidBy;
   User? receivedBy;
   Salary? salary;

  PaySlip({
     this.id,
     this.totalAmount,
     this.billingDate,
     this.paymentMethod,
     this.status,
     this.paidBy,
     this.receivedBy,
     this.salary,
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
      'billingDate': billingDate?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
      'paidBy': paidBy?.toJson(),
      'receivedBy': receivedBy?.toJson(),
      'salary': salary?.toJson(),
    };
  }
}
