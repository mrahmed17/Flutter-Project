import 'package:hr_and_pms/administration/model/User.dart';
import '../../salary/model/Salary.dart';

class Bonus {
  int? id;
  double? bonusAmount;
  DateTime? bonusDate;
  String? bonusType; // Performance, Annual, Festival, Promotional
  Salary? salary;
  User? user;

  Bonus({
    this.id,
    this.bonusAmount,
    this.bonusDate,
    this.bonusType,
    this.salary,
    this.user,
  });

  // Factory constructor to create Bonus object from JSON
  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(
      id: json['id'] ?? 0,
      bonusAmount: (json['bonusAmount'] ?? 0).toDouble(),
      bonusDate: json['bonusDate'] != null
          ? DateTime.tryParse(json['bonusDate'])
          : null,
      bonusType: json['bonusType'] ?? '',
      salary: json['salary'] != null ? Salary.fromJson(json['salary']) : null, // Deserialize Salary
      user: json['user'] != null ? User.fromJson(json['user']) : null, // Deserialize User
    );
  }

  // Method to convert Bonus object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bonusAmount': bonusAmount,
      'bonusDate': bonusDate?.toIso8601String(),
      'bonusType': bonusType,
      'salary': salary?.toJson(), // Serialize Salary object
      'user': user?.toJson(), // Serialize User object
    };
  }
}

// import 'package:hr_and_pms/administration/model/User.dart';
//
// class Bonus {
//    int id;
//    double bonusAmount;
//    DateTime bonusDate;
//    User user;
//
//   // Constructor with  fields
//   Bonus({
//      this.id,
//      this.bonusAmount,
//      this.bonusDate,
//      this.user,  // Using User object instead of userId
//   });
//
//   // Method to convert JSON to Bonus instance
//   factory Bonus.fromJson(Map<String, dynamic> json) {
//     return Bonus(
//       id: json['id'] ?? 0,
//       bonusAmount: json['bonusAmount']?.toDouble() ?? 0.0,
//       bonusDate: DateTime.parse(json['bonusDate'] ?? DateTime.now().toString()),
//       user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),  // Ensure safe deserialization of User
//     );
//   }
//
//   // Method to convert Bonus instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'bonusAmount': bonusAmount,
//       'bonusDate': bonusDate.toIso8601String(),
//       'user': user.toJson(),  // Serializing the User object
//     };
//   }
// }
