import 'package:inframind/features/authentication/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login(String identifier, String password, String role);
  Future<User> signup(String name, String email, String phone, String password, String role);
  Future<bool> forgotPassword(String identifier);
}
