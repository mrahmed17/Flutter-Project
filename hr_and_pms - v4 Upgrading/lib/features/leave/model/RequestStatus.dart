enum RequestStatus {
  APPROVED,
  PENDING,
  REJECTED,
}

extension RequestStatusExtension on RequestStatus {
  // Converts a string to a RequestStatus enum value
  static RequestStatus fromString(String statusString) {
    return RequestStatus.values.firstWhere(
          (status) => status.toString().split('.').last.toUpperCase() ==
          statusString.toUpperCase(),
      orElse: () => RequestStatus.PENDING, // Default to pending if not found
    );
  }

  // Converts RequestStatus enum to a lowercase string
  String toShortString() {
    return toString().split('.').last.toUpperCase();
  }
}

// enum RequestStatus { pending, approved, rejected }
//
// extension RequestStatusExtension on RequestStatus {
//   static RequestStatus fromString(String statusString) {
//     return RequestStatus.values.firstWhere(
//           (status) =>
//       status.toString().split('.').last.toLowerCase() ==
//           statusString.toLowerCase(),
//       orElse: () => RequestStatus.pending,
//     );
//   }
//
//   String toShortString() {
//     return toString().split('.').last.toUpperCase();
//   }
// }
