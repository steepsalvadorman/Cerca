import 'package:freezed_annotation/freezed_annotation.dart';

import 'auth_user.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

/// Mirrors the backend's `AuthResponse` returned by `/auth/register` and
/// `/auth/login`.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    required AuthUser user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) => _$AuthSessionFromJson(json);
}
