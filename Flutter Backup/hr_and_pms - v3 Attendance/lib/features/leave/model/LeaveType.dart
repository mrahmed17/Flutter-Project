enum LeaveType { sick, unpaid, reserve }

extension LeaveTypeExtension on LeaveType {
  static LeaveType fromString(String leaveTypeString) {
    return LeaveType.values.firstWhere(
          (leaveType) =>
      leaveType.toString().split('.').last.toLowerCase() ==
          leaveTypeString.toLowerCase(),
      orElse: () => LeaveType.sick,
    );
  }

  String toShortString() {
    return toString().split('.').last;
  }
}
