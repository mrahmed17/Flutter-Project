enum BonusType {
  PERFORMANCE,
  ANNUAL,
  FESTIVAL,
  PROMOTIONAL,
}

// Extension to add method to convert string to BonusType
extension BonusTypeExtension on BonusType {
  static BonusType fromString(String type) {
    return BonusType.values.firstWhere(
          (e) => e.toString().split('.').last.toUpperCase() == type.toUpperCase(),
      orElse: () => BonusType.PERFORMANCE, // Default to PERFORMANCE if invalid
    );
  }

  String toShortString() {
    return toString().split('.').last.toUpperCase(); // Convert enum to string in uppercase
  }
}
