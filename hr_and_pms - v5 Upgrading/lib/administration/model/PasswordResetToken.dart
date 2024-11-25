import 'package:hr_and_pms/administration/model/User.dart';

class PasswordResetToken {
  int? id;
  String? token;
  DateTime? expiryDate;
  User? user; // Assuming you have a User model

  PasswordResetToken({
    this.id,
    this.token,
    this.expiryDate,
    this.user,
  });

  // Factory constructor to create a PasswordResetToken from JSON
  factory PasswordResetToken.fromJson(Map<String, dynamic> json) {
    return PasswordResetToken(
      id: json['id'] ?? 0,
      token: json['token'] ?? '',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  // Method to convert PasswordResetToken to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'expiryDate': expiryDate?.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}