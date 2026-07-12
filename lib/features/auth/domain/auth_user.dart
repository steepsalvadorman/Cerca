import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// Mirrors the backend's `UserResponse` (see
/// `backend/src/features/auth/interfaces/http/dto.rs`).
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String email,
    required String name,
    required String role, // "client" | "technician"
    required DateTime createdAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}

extension AuthUserRole on AuthUser {
  bool get isTechnician => role == 'technician';
  bool get isClient => role == 'client';
}
