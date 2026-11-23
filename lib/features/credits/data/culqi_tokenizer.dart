import 'package:dio/dio.dart';

import '../../../core/network/api_exception.dart';

/// Creates Culqi tokens straight from the device with the *public* key, so
/// card numbers and Yape codes never pass through Cerca's servers — the
/// backend only ever sees the resulting `tkn_…` / `ype_…` id.
///
/// Uses its own Dio: the app's API client would attach the Cerca session
/// token, which must never be sent to a third party.
class CulqiTokenizer {
  CulqiTokenizer({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://secure.culqi.com',
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
            ));

  final Dio _dio;

  Future<String> cardToken({
    required String publicKey,
    required String cardNumber,
    required String cvv,
    required int expirationMonth,
    required int expirationYear,
    required String email,
  }) =>
      _token(publicKey, '/v2/tokens', {
        'card_number': cardNumber.replaceAll(RegExp(r'\s'), ''),
        'cvv': cvv,
        'expiration_month': expirationMonth.toString(),
        'expiration_year': expirationYear.toString(),
        'email': email,
      });

  /// [otp] is the 6-digit approval code the payer generates in their Yape
  /// app; [amountCents] must match the charge.
  Future<String> yapeToken({
    required String publicKey,
    required String phone,
    required String otp,
    required int amountCents,
  }) =>
      _token(publicKey, '/v2/tokens/yape', {
        'number_phone': phone,
        'otp': otp,
        'amount': amountCents.toString(),
      });

  Future<String> _token(String publicKey, String path, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $publicKey'}),
      );
      return (response.data as Map<String, dynamic>)['id'] as String;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? (data['user_message'] ?? data['merchant_message']) as String?
          : null;
      throw ApiException(
        message: message ?? 'No se pudo validar el medio de pago. Revisa los datos e inténtalo de nuevo.',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
