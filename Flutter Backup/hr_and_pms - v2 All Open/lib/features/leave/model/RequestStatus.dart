enum RequestStatus { pending, approved, rejected }

extension RequestStatusExtension on RequestStatus {
  // Convert a string to the corresponding enum value
  static RequestStatus fromString(String statusString) {
    return RequestStatus.values.firstWhere(
          (status) =>
      status.toString().split('.').last.toLowerCase() ==
          statusString.toLowerCase(),
      orElse: () => RequestStatus.pending,
    );
  }

  // Convert the enum to a lowercase string
  String toShortString() {
    return toString().split('.').last.toLowerCase();
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
