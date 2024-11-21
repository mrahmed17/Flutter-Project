import 'package:hr_and_pms/administration/model/User.dart';

class Bonus {
  final int id;
  final double bonusAmount;
  final DateTime bonusDate;
  final User user;

  // Constructor with required fields
  Bonus({
    required this.id,
    required this.bonusAmount,
    required this.bonusDate,
    required this.user,  // Using User object instead of userId
  });

  // Method to convert JSON to Bonus instance
  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(
      id: json['id'] ?? 0,
      bonusAmount: json['bonusAmount']?.toDouble() ?? 0.0,
      bonusDate: DateTime.parse(json['bonusDate'] ?? DateTime.now().toString()),
      user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),  // Ensure safe deserialization of User
    );
  }

  // Method to convert Bonus instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bonusAmount': bonusAmount,
      'bonusDate': bonusDate.toIso8601String(),
      'user': user.toJson(),  // Serializing the User object
    };
  }
}
