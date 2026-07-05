import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/auth_credentials.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

/// TODO(backend): replace with a real implementation once the backend is
/// decided (Firebase Auth or a REST API). This placeholder only validates
/// the shape of the credentials locally so the Login feature is fully
/// wired end-to-end and ready to swap the data source later.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(AuthCredentials credentials) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!credentials.email.contains('@')) {
      throw const AuthException('Ingresa un correo electrónico válido.');
    }
    if (credentials.password.length < 6) {
      throw const AuthException(
        'La contraseña debe tener al menos 6 caracteres.',
      );
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl();
}
