enum LeaveType { SICK, UNPAID, RESERVE }

extension LeaveTypeExtension on LeaveType {
  static LeaveType fromInt(int value) {
    return LeaveType.values.firstWhere(
          (leaveType) => leaveType.index == value,
      orElse: () => LeaveType.SICK, // Default to SICK if value is unknown
    );
  }

  int toInt() {
    return this.index; // Returns the integer index of the enum (0, 1, or 3)
  }
}



// enum LeaveType { SICK, UNPAID, RESERVE }
//
// extension LeaveTypeExtension on LeaveType {
//   static LeaveType fromString(String leaveTypeString) {
//     return LeaveType.values.firstWhere(
//       (leaveType) =>
//           leaveType.toString().split('.').last.toUpperCase() ==
//           leaveTypeString.toUpperCase(),
//       orElse: () => LeaveType.SICK, // Default to SICK if not found
//     );
//   }
//
//   String toShortString() {
//     return toString()
//         .split('.')
//         .last
//         .toUpperCase(); // Ensure uppercase string representation
//   }
// }
