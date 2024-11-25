import 'package:hr_and_pms/administration/model/User.dart';

class Bonus {
   int? id;
   double? bonusAmount;
   DateTime? bonusDate;
   String? bonusType;
   User? user;

  Bonus({
     this.id,
     this.bonusAmount,
     this.bonusDate,
     this.bonusType,
     this.user,
  });

  // Factory constructor to create Bonus object from JSON
  factory Bonus.fromJson(Map<String, dynamic> json) {
    return Bonus(
      id: json['id'] ?? 0,
      bonusAmount: (json['bonusAmount'] ?? 0).toDouble(),
      bonusDate: DateTime.parse(json['bonusDate'] ?? DateTime.now().toString()),
      bonusType: json['bonusType'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  // Method to convert Bonus object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bonusAmount': bonusAmount,
      'bonusDate': bonusDate?.toIso8601String(),
      'bonusType': bonusType,
      'user': user?.toJson(), // Serializing the User object
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
