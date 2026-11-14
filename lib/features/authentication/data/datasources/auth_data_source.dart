import 'package:inframind/features/authentication/data/models/user_model.dart';

abstract interface class AuthDataSource {
  Future<UserModel> login(String identifier, String password, String role);
  Future<UserModel> signup(String name, String email, String phone, String password, String role);
  Future<bool> forgotPassword(String identifier);
}

class LocalAuthDataSource implements AuthDataSource {
  @override
  Future<UserModel> login(String identifier, String password, String role) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate mock latency
    return UserModel(
      id: 'USR-001',
      name: 'أحمد حسن',
      email: identifier.contains('@') ? identifier : 'ahmed.hassan@example.com',
      phone: identifier.contains('@') ? '01012345678' : identifier,
      role: role,
      token: 'mock_jwt_token_inframind_2026',
    );
  }

  @override
  Future<UserModel> signup(String name, String email, String phone, String password, String role) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      token: 'mock_jwt_token_inframind_2026',
    );
  }

  @override
  Future<bool> forgotPassword(String identifier) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
