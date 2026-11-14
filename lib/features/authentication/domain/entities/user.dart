enum UserRole { citizen, maintenanceCompany }

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.token,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? token;
}
