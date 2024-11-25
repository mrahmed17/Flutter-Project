import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:hr_and_pms/administration/model/User.dart';

class Leave {
   int? id;
   DateTime? startDate;
   DateTime? endDate;
   DateTime? requestDate;
   String? reason;
   int? duration;
   LeaveType? leaveType;
   RequestStatus? requestStatus;
   User? user;

  Leave({
     this.id,
     this.startDate,
     this.endDate,
     this.requestDate,
     this.reason,
     this.duration,
     this.leaveType,
     this.requestStatus,
     this.user,
  });

  // Factory constructor to create a Leave instance from JSON
  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      id: json['id'] ?? 0,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      requestDate: DateTime.parse(json['requestDate'] ?? DateTime.now().toIso8601String()),
      reason: json['reason'] ?? '',
      duration: json['duration'] ?? 0,
      leaveType: LeaveTypeExtension.fromString(json['leaveType'] ?? ''),
      requestStatus: RequestStatusExtension.fromString(json['requestStatus'] ?? ''),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  // Method to convert Leave instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'requestDate': requestDate?.toIso8601String(),
      'reason': reason,
      'duration': duration,
      'leaveType': leaveType?.toShortString(),
      'requestStatus': requestStatus?.toShortString(),
      'user': user?.toJson(),
    };
  }
}


// import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
// import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
// import 'package:hr_and_pms/administration/model/User.dart';
//
// class Leave {
//   int? id;
//   DateTime? startDate;
//   DateTime? endDate;
//   DateTime? requestDate;
//   String? reason;
//   int? remainingLeave;
//   LeaveType? leaveType;
//   RequestStatus? requestStatus;
//   User? user;
//
//   Leave({
//     this.id,
//     this.startDate,
//     this.endDate,
//     this.requestDate,
//     this.reason,
//     this.remainingLeave,
//     this.leaveType,
//     this.requestStatus,
//     this.user,
//   });
//
//   // Method to convert JSON to Leave instance
//   factory Leave.fromJson(Map<String, dynamic> json) {
//     return Leave(
//       id: json['id'] ?? 0,
//       startDate: json['startDate'] != null
//           ? DateTime.parse(json['startDate'])
//           : DateTime.now(),
//       endDate: json['endDate'] != null
//           ? DateTime.parse(json['endDate'])
//           : DateTime.now(),
//       requestDate: json['requestDate'] != null
//           ? DateTime.parse(json['requestDate'])
//           : DateTime.now(),
//       reason: json['reason'] ?? '',
//       remainingLeave: json['remainingLeave'] ?? 0,
//       leaveType: LeaveTypeExtension.fromString(json['leaveType'] ?? ''),
//       requestStatus:
//           RequestStatusExtension.fromString(json['requestStatus'] ?? ''),
//       user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'startDate': startDate?.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//       'requestDate': requestDate?.toIso8601String(),
//       'reason': reason,
//       'remainingLeave': remainingLeave,
//       'leaveType': leaveType?.toShortString().toUpperCase(),
//       'requestStatus': requestStatus?.toShortString().toUpperCase(),
//       'user': user?.toJson(),
//     };
//   }
// }
