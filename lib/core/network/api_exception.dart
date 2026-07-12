/// Uniform error shape for every backend call, built from the `{"error":
/// "..."}` body the Rust API returns on non-2xx responses (see
/// `backend/src/shared/error.rs`).
class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => message;
}
