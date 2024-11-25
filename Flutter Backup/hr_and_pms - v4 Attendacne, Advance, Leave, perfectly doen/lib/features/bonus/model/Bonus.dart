import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/bonus/model/BonusType.dart'; // Make sure this import is correct
import '../../salary/model/Salary.dart';

class Bonus {
  int? id;
  double? bonusAmount;
  DateTime? bonusDate;
  BonusType? bonusType;  // Enum for Performance, Annual, Festival, Promotional
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
      bonusType: json['bonusType'] != null
          ? BonusTypeExtension.fromString(json['bonusType'])
          : null, // Use the extension method to get the enum from string
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
      'bonusType': bonusType?.toString(), // Ensure BonusType is serialized properly
      'salary': salary?.toJson(), // Serialize Salary object
      'user': user?.toJson(), // Serialize User object
    };
  }
}
