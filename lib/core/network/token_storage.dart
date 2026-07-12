import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT issued by `POST /auth/login` / `POST /auth/register`
/// across app restarts.
class TokenStorage {
  const TokenStorage();

  static const _tokenKey = 'cerca_auth_token';
  static const _storage = FlutterSecureStorage();

  Future<String?> read() => _storage.read(key: _tokenKey);

  Future<void> save(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> clear() => _storage.delete(key: _tokenKey);
}
