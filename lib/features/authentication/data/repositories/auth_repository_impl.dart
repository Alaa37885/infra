import 'package:inframind/features/authentication/data/datasources/auth_data_source.dart';
import 'package:inframind/features/authentication/domain/entities/user.dart';
import 'package:inframind/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthDataSource _dataSource;

  @override
  Future<User> login(String identifier, String password, String role) async {
    final model = await _dataSource.login(identifier, password, role);
    return model.toEntity();
  }

  @override
  Future<User> signup(String name, String email, String phone, String password, String role) async {
    final model = await _dataSource.signup(name, email, phone, password, role);
    return model.toEntity();
  }

  @override
  Future<bool> forgotPassword(String identifier) async {
    return await _dataSource.forgotPassword(identifier);
  }
}
