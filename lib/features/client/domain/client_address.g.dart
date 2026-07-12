// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientAddress _$ClientAddressFromJson(Map<String, dynamic> json) =>
    _ClientAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$ClientAddressToJson(_ClientAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'detail': instance.detail,
    };
