enum Role { ADMIN, MANAGER, EMPLOYEE }

extension RoleExtension on Role {
  static Role fromString(String roleString) {
    return Role.values.firstWhere(
            (role) => role.toString().split('.').last.toLowerCase()
                == roleString.toLowerCase(),
      orElse: () => Role.EMPLOYEE,
    );
  }

  // Convert Role enum to a string
  String toShortString() {
    return toString().split('.').last;
  }
}
