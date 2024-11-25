enum LeaveType { SICK, UNPAID, RESERVE }

extension LeaveTypeExtension on LeaveType {
  static LeaveType fromString(String leaveTypeString) {
    return LeaveType.values.firstWhere(
          (leaveType) => leaveType.toString().split('.').last.toUpperCase() == leaveTypeString.toUpperCase(),
    );
  }

  String toShortString() {
    return toString().split('.').last.toUpperCase();  // Ensure it's in uppercase
  }
}

