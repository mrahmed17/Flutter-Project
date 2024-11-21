enum LeaveType { sickPaid, sickUnpaid, reserveUnpaid }

extension LeaveTypeExtension on LeaveType {
  // Convert a string to LeaveType enum
  static LeaveType fromString(String leaveTypeString) {
    return LeaveType.values.firstWhere(
          (leaveType) => leaveType.toString().split('.').last.toLowerCase() == leaveTypeString.toLowerCase(),
      orElse: () => LeaveType.sickPaid, // Default if no match is found
    );
  }

  // Convert LeaveType enum to a string
  String toShortString() {
    return toString().split('.').last;
  }
}
