import 'package:hr_and_pms/features/attendance/model/AttendanceModel.dart';

class PaginatedAttendance {
  final List<Attendance> attendances;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  PaginatedAttendance({
    required this.attendances,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  factory PaginatedAttendance.fromJson(Map<String, dynamic> json) {
    return PaginatedAttendance(
      attendances: (json['content'] as List)
          .map((attendance) => Attendance.fromJson(attendance))
          .toList(),
      currentPage: json['pageable']['pageNumber'],
      totalPages: json['totalPages'],
      totalItems: json['totalElements'],
    );
  }
}
