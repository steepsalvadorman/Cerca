import '../entities/auth_credentials.dart';

/// Contract for authentication. No backend is wired up yet (see
/// [AuthRepositoryImpl] in the data layer) — swap the implementation
/// once Firebase/REST auth is decided, without touching the presentation
/// or application layers.
abstract interface class AuthRepository {
  Future<void> login(AuthCredentials credentials);
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
