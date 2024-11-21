
import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:hr_and_pms/features/user/model/User.dart';

class Leave {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime requestDate;
  final String reason;
  final int remainingLeave;
  final LeaveType leaveType;
  final RequestStatus requestStatus;
  final User user;  // Referencing User object directly

  Leave({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.requestDate,
    required this.reason,
    required this.remainingLeave,
    required this.leaveType,
    required this.requestStatus,
    required this.user,  // Using User object instead of userId
  });

  // Method to convert JSON to Leave instance
  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
      requestDate: DateTime.parse(json['requestDate'] ?? DateTime.now().toString()),
      reason: json['reason'] ?? '',
      remainingLeave: json['remainingLeave'] ?? 0,
      leaveType: LeaveType.values.firstWhere((e) => e.toString().split('.').last == json['leaveType']),
      requestStatus: RequestStatus.values.firstWhere((e) => e.toString().split('.').last == json['requestStatus']),
      user: User.fromJson(json['user'] ?? {}),  // Deserializing the User object
    );
  }

  // Method to convert Leave instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requestDate': requestDate.toIso8601String(),
      'reason': reason,
      'remainingLeave': remainingLeave,
      'leaveType': leaveType.toString().split('.').last,
      'requestStatus': requestStatus.toString().split('.').last,
      'user': user.toJson(),  // Serializing the User object
    };
  }
}
