import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_payment_method.freezed.dart';
part 'client_payment_method.g.dart';

/// Mirrors the backend's `PaymentMethodResponse`.
@freezed
abstract class ClientPaymentMethod with _$ClientPaymentMethod {
  const factory ClientPaymentMethod({
    required String id,
    required String label,
    required String detail,
  }) = _ClientPaymentMethod;

  factory ClientPaymentMethod.fromJson(Map<String, dynamic> json) => _$ClientPaymentMethodFromJson(json);
}
