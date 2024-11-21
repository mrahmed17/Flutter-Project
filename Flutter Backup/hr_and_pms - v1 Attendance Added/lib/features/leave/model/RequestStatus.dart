enum RequestStatus { pending, approved, rejected }

extension RequestStatusExtension on RequestStatus {
  // Convert a string to RequestStatus enum
  static RequestStatus fromString(String statusString) {
    return RequestStatus.values.firstWhere(
          (status) => status.toString().split('.').last.toLowerCase() == statusString.toLowerCase(),
      orElse: () => RequestStatus.pending, // Default if no match is found
    );
  }

  // Convert RequestStatus enum to a string
  String toShortString() {
    return toString().split('.').last;
  }
}
