import 'package:inframind/features/authentication/domain/entities/user.dart';

class UserModel {
  const UserModel({
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
  final String role;
  final String? token;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'citizen',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'token': token,
      };

  User toEntity() => User(
        id: id,
        name: name,
        email: email,
        phone: phone,
        role: role == 'company' ? UserRole.maintenanceCompany : UserRole.citizen,
        token: token,
      );
}
