
import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:hr_and_pms/administration/model/User.dart';

class Leave {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime requestDate;
  final String reason;
  final int remainingLeave;
  final LeaveType leaveType;
  final RequestStatus requestStatus;
  final User user;

  Leave({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.requestDate,
    required this.reason,
    required this.remainingLeave,
    required this.leaveType,
    required this.requestStatus,
    required this.user,
  });

  // Method to convert JSON to Leave instance
  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : DateTime.now(),
      reason: json['reason'] ?? '',
      remainingLeave: json['remainingLeave'] ?? 0,
      leaveType: LeaveTypeExtension.fromString(json['leaveType'] ?? ''),
      requestStatus:
      RequestStatusExtension.fromString(json['requestStatus'] ?? ''),
      user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requestDate': requestDate.toIso8601String(),
      'reason': reason,
      'remainingLeave': remainingLeave,
      'leaveType': leaveType.toShortString().toUpperCase(),
      'requestStatus': requestStatus.toShortString().toUpperCase(),
      'user': user.toJson(),
    };
  }

}
