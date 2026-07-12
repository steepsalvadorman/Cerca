import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_address.freezed.dart';
part 'client_address.g.dart';

/// Mirrors the backend's `AddressResponse`.
@freezed
abstract class ClientAddress with _$ClientAddress {
  const factory ClientAddress({
    required String id,
    required String label,
    required String detail,
  }) = _ClientAddress;

  factory ClientAddress.fromJson(Map<String, dynamic> json) => _$ClientAddressFromJson(json);
}
