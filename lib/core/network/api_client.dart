import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'token_storage.dart';

/// Base URL of the Cerca backend. Defaults to the Android emulator's
/// alias for the host machine's localhost. Override at build/run time
/// for other targets, e.g.:
/// `flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8080`
/// (physical device on the same Wi-Fi) or `http://localhost:8080` (iOS
/// simulator / desktop).
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://10.0.2.2:8080',
);

/// Builds the shared [Dio] client: attaches the stored bearer token to
/// every request and maps every failure to an [ApiException] so
/// repositories only ever need to catch one error type.
Dio buildApiClient(TokenStorage tokenStorage) {
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await tokenStorage.read();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) {
      handler.next(error.copyWith(error: _toApiException(error)));
    },
  ));

  return dio;
}

ApiException _toApiException(DioException error) {
  final data = error.response?.data;
  if (data is Map && data['error'] is String) {
    return ApiException(message: data['error'] as String, statusCode: error.response?.statusCode);
  }
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const ApiException(message: 'No se pudo conectar con el servidor. Verifica tu conexión.');
    default:
      return ApiException(message: error.message ?? 'Ocurrió un error inesperado.', statusCode: error.response?.statusCode);
  }
}

/// Repositories call this in every `catch (e) on DioException` block to
/// unwrap the [ApiException] attached by the interceptor above.
ApiException apiExceptionOf(DioException error) {
  final apiError = error.error;
  return apiError is ApiException ? apiError : _toApiException(error);
}
