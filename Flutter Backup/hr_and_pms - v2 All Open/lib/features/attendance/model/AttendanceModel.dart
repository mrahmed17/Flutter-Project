
import 'package:hr_and_pms/administration/model/User.dart';

class Attendance {
  final int id;
  final DateTime date;
  final DateTime clockInTime;
  final DateTime clockOutTime;
  final User user;  // Referencing User object

  Attendance({
    required this.id,
    required this.date,
    required this.clockInTime,
    required this.clockOutTime,
    required this.user,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
      clockInTime: DateTime.parse(json['clockInTime'] ?? DateTime.now().toString()),
      clockOutTime: DateTime.parse(json['clockOutTime'] ?? DateTime.now().toString()),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'clockInTime': clockInTime.toIso8601String(),
      'clockOutTime': clockOutTime.toIso8601String(),
      'user': user.toJson(),  // Serializing the User object
    };
  }
}
