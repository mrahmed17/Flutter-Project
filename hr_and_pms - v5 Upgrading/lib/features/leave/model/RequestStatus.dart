enum RequestStatus { APPROVED, PENDING, REJECTED}

extension RequestStatusExtension on RequestStatus {
  // Converts a string to a RequestStatus enum value
  static RequestStatus fromString(String statusString) {
    return RequestStatus.values.firstWhere(
          (status) => status.toString().split('.').last.toUpperCase() ==
          statusString.toUpperCase(),
      orElse: () => RequestStatus.PENDING,
    );
  }

  // Converts RequestStatus enum to a toUpperCase string
  String toShortString() {
    return toString().split('.').last.toUpperCase();
  }
}
