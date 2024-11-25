import 'package:hr_and_pms/administration/model/User.dart';

class Attendance {
  int? id;
  DateTime? date;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  double? overtimeHours;
  bool? lateCheckIn;
  User? user;

  Attendance({
    this.id,
    this.date,
    this.clockInTime,
    this.clockOutTime,
    this.overtimeHours,
    this.lateCheckIn,
    this.user,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      clockInTime: DateTime.parse(
          json['clockInTime'] ?? DateTime.now().toIso8601String()),
      clockOutTime: json['clockOutTime'] != null
          ? DateTime.tryParse(json['clockOutTime'])
          : null,
      overtimeHours: (json['overtimeHours'] ?? 0).toDouble(),
      lateCheckIn: json['lateCheckIn'] ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'clockInTime': clockInTime?.toIso8601String(),
      'clockOutTime': clockOutTime?.toIso8601String(),
      'overtimeHours': overtimeHours,
      'lateCheckIn': lateCheckIn,
      'user': user?.toJson(),
    };
  }
}

//
// import 'package:hr_and_pms/administration/model/User.dart';
//
// class Attendance {
//    int id;
//    DateTime date;
//    DateTime clockInTime;
//    DateTime clockOutTime;
//    User user;  // Referencing User object
//
//   Attendance({
//      this.id,
//      this.date,
//      this.clockInTime,
//      this.clockOutTime,
//      this.user,
//   });
//
//   factory Attendance.fromJson(Map<String, dynamic> json) {
//     return Attendance(
//       id: json['id'] ?? 0,
//       date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
//       clockInTime: DateTime.parse(json['clockInTime'] ?? DateTime.now().toString()),
//       clockOutTime: DateTime.parse(json['clockOutTime'] ?? DateTime.now().toString()),
//       user: User.fromJson(json['user'] ?? {}),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date.toIso8601String(),
//       'clockInTime': clockInTime.toIso8601String(),
//       'clockOutTime': clockOutTime.toIso8601String(),
//       'user': user.toJson(),  // Serializing the User object
//     };
//   }
// }
