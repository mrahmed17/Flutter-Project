enum Role { admin, manager, employee }

extension RoleExtension on Role {
    static Role fromString(String roleString) {
    return Role.values.firstWhere(
          (role) => role.toString().split('.').last.toLowerCase() == roleString.toLowerCase(),
      orElse: () => Role.employee,
    );
  }

  String toShortString() {
    return toString().split('.').last.toUpperCase();
  }
}
