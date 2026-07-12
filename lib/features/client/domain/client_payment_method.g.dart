// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientPaymentMethod _$ClientPaymentMethodFromJson(Map<String, dynamic> json) =>
    _ClientPaymentMethod(
      id: json['id'] as String,
      label: json['label'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$ClientPaymentMethodToJson(
  _ClientPaymentMethod instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'detail': instance.detail,
};
